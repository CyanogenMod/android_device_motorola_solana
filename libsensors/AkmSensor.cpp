/*
 * Copyright (C) 2008 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <fcntl.h>
#include <errno.h>
#include <math.h>
#include <poll.h>
#include <unistd.h>
#include <dirent.h>
#include <sys/select.h>
#include <dlfcn.h>
#include <stdint.h>

#include "inc/akm8975.h"

#include <cutils/log.h>

#include "AkmSensor.h"
#include "AkmAotController.h"

/*****************************************************************************/

#define AKM_DATA_NAME      "compass"

#define AKM_ENABLED_BITMASK_M 0x01
#define AKM_ENABLED_BITMASK_O 0x02

//should be swapped in driver, as x and y are backwards on solana
#define EVENT_TYPE_MAGV_X ABS_HAT0X
#define EVENT_TYPE_MAGV_Y ABS_HAT0Y
#define EVENT_TYPE_MAGV_Z ABS_BRAKE
#define EVENT_TYPE_MAGV_STATUS ABS_GAS

#define EVENT_TYPE_YAW 		 ABS_RX
#define EVENT_TYPE_PITCH 	 ABS_RY
#define EVENT_TYPE_ROLL 	 ABS_RZ
#define EVENT_TYPE_ORIENT_STATUS ABS_RUDDER

/*****************************************************************************/

AkmSensor::AkmSensor()
: SensorBase(NULL, AKM_DATA_NAME),
      mEnabled(0),
      mPendingMask(0),
      mInputReader(32)
{
    memset(mPendingEvents, 0, sizeof(mPendingEvents));

    mPendingEvents[MagneticField].version = sizeof(sensors_event_t);
    mPendingEvents[MagneticField].sensor = SENSOR_TYPE_MAGNETIC_FIELD;
    mPendingEvents[MagneticField].type = SENSOR_TYPE_MAGNETIC_FIELD;
    mPendingEvents[MagneticField].magnetic.status = SENSOR_STATUS_ACCURACY_HIGH;

    mPendingEvents[Orientation  ].version = sizeof(sensors_event_t);
    mPendingEvents[Orientation  ].sensor = SENSOR_TYPE_ORIENTATION;
    mPendingEvents[Orientation  ].type = SENSOR_TYPE_ORIENTATION;
    mPendingEvents[Orientation  ].orientation.status = SENSOR_STATUS_ACCURACY_HIGH;

    for (int i=0 ; i<numSensors ; i++)
        mDelays[i] = -1; // Disable by default
        for (int i=0 ; i<numAccelAxises ; ++i)
                mAccels[i] = 0;

	// read the actual value of all sensors if they're enabled already
    struct input_absinfo absinfo;
    if (is_sensor_enabled(SENSOR_TYPE_MAGNETIC_FIELD))  {
        mEnabled |= AKM_ENABLED_BITMASK_M;
        if (!ioctl(data_fd, EVIOCGABS(EVENT_TYPE_MAGV_X), &absinfo)) {
            mPendingEvents[MagneticField].magnetic.x = absinfo.value * CONVERT_M;
        }
        if (!ioctl(data_fd, EVIOCGABS(EVENT_TYPE_MAGV_Y), &absinfo)) {
            mPendingEvents[MagneticField].magnetic.y = absinfo.value * CONVERT_M;
        }
        if (!ioctl(data_fd, EVIOCGABS(EVENT_TYPE_MAGV_Z), &absinfo)) {
            mPendingEvents[MagneticField].magnetic.z = absinfo.value * CONVERT_M;
        }
        if (!ioctl(data_fd, EVIOCGABS(EVENT_TYPE_MAGV_STATUS), &absinfo)) {
            mPendingEvents[MagneticField].magnetic.status = uint8_t(absinfo.value & SENSOR_STATE_MASK);
        }
    }
    if (is_sensor_enabled(SENSOR_TYPE_ORIENTATION))  {
        mEnabled |= AKM_ENABLED_BITMASK_M;
        if (!ioctl(data_fd, EVIOCGABS(EVENT_TYPE_YAW), &absinfo)) {
            mPendingEvents[Orientation].orientation.azimuth = absinfo.value * CONVERT_O;
        }
        if (!ioctl(data_fd, EVIOCGABS(EVENT_TYPE_PITCH), &absinfo)) {
            mPendingEvents[Orientation].orientation.pitch = absinfo.value * CONVERT_O;
        }
        if (!ioctl(data_fd, EVIOCGABS(EVENT_TYPE_ROLL), &absinfo)) {
            mPendingEvents[Orientation].orientation.roll = absinfo.value * CONVERT_O;
        }
        if (!ioctl(data_fd, EVIOCGABS(EVENT_TYPE_ORIENT_STATUS), &absinfo)) {
            mPendingEvents[Orientation].orientation.status = uint8_t(absinfo.value & SENSOR_STATE_MASK);
        }
    }
}

AkmSensor::~AkmSensor()
{
}

int AkmSensor::enable(int32_t handle, int en)
{
    uint32_t mask;
    uint32_t sensor_type;

    switch (handle) {
        case SENSOR_TYPE_MAGNETIC_FIELD:
            mask = AKM_ENABLED_BITMASK_M;
            sensor_type = SENSOR_TYPE_MAGNETIC_FIELD;
            break;
        case SENSOR_TYPE_ORIENTATION:
            mask = AKM_ENABLED_BITMASK_O;
            sensor_type = SENSOR_TYPE_ORIENTATION;
            break;
        default: return -EINVAL;
    }
        int err = 0;
		
    uint32_t newState  = (mEnabled & ~mask) | (en ? mask : 0);

		if (mEnabled != newState) {
        if (en)
            err = enable_sensor(sensor_type);
        else
            err = disable_sensor(sensor_type);
        ALOGE_IF(err, "Could not change sensor state (%s)", strerror(-err));
        if (!err) {
            mEnabled = newState;
            update_delay();
        }
    }

    return err;
}

int AkmSensor::setDelay(int32_t handle, int64_t ns)
{
    if (ns < 0)
        return -EINVAL;

	switch (handle) {
        case SENSOR_TYPE_MAGNETIC_FIELD: 
                    mDelays[0] = ns;
                        break;
        case SENSOR_TYPE_ORIENTATION: 
                    mDelays[1] = ns;
                        break;
                default:
                        return -EINVAL;
    }

	//ALOGD("setDelay: handle=%d, ns=%lld", handle, ns);
    return update_delay();
}

int AkmSensor::update_delay()
{
    if (mEnabled) {
                int64_t delay[3];
                // Magnetic sensor
                if (mEnabled & AKM_ENABLED_BITMASK_M) {
                        delay[0] = mDelays[0];
                } else {
                        delay[0] = -1;
                }
                // Acceleration sensor
                delay[1] = -1;
                // Orientation sensor
                if (mEnabled & AKM_ENABLED_BITMASK_O) {
                        delay[2] = mDelays[1];
                } else {
                        delay[2] = -1;
                }
                //ALOGD("update_delay:%lld,%lld,%lld",delay[0],delay[1],delay[2]);
                AkmAotController::getInstance().setDelay(delay);
    }
    return 0;
}

int AkmSensor::readEvents(sensors_event_t* data, int count)
{
    if (count < 1)
        return -EINVAL;

	ssize_t n = mInputReader.fill(data_fd);

    if (n < 0)
        return n;

	int numEventReceived = 0;
    input_event const* event;

    while (count && mInputReader.readEvent(&event)) {
        int type = event->type;
        if (type == EV_ABS) {
            processEvent(event->code, event->value);
            mInputReader.next();
        } else if (type == EV_SYN) {
            int64_t time = timevalToNano(event->time);
            for (int j=0 ; count && mPendingMask && j<numSensors ; j++) {
                if (mPendingMask & (1<<j)) {
                    mPendingMask &= ~(1<<j);
                    mPendingEvents[j].timestamp = time;
                    if (0 != (mEnabled & (1 << j))) {
                        *data++ = mPendingEvents[j];
                        count--;
                        numEventReceived++;
                    }
                }
            }
            if (!mPendingMask) {
                mInputReader.next();
            }
        } else {
            ALOGE("AkmSensor: unknown event (type=%d, code=%d)",
                    type, event->code);
            mInputReader.next();
        }
    }
    return numEventReceived;
}

void AkmSensor::processEvent(int code, int value)
{
	float convYaw;
    switch (code) {
        case EVENT_TYPE_MAGV_X:
            mPendingMask |= 1<<MagneticField;
            mPendingEvents[MagneticField].magnetic.x = value * CONVERT_M;
            break;
        case EVENT_TYPE_MAGV_Y:
            mPendingMask |= 1<<MagneticField;
            mPendingEvents[MagneticField].magnetic.y = value * CONVERT_M;
            break;
        case EVENT_TYPE_MAGV_Z:
            mPendingMask |= 1<<MagneticField;
            mPendingEvents[MagneticField].magnetic.z = value * CONVERT_M;
            break;
        case EVENT_TYPE_MAGV_STATUS:
            mPendingMask |= 1<<MagneticField;
            mPendingEvents[MagneticField].magnetic.status =
                    uint8_t(value & SENSOR_STATE_MASK);
            break;
	case EVENT_TYPE_YAW:
            mPendingMask |= 1<<Orientation;
            mPendingEvents[Orientation].orientation.azimuth = (value * CONVERT_O);
            break;
        case EVENT_TYPE_PITCH:
            mPendingMask |= 1<<Orientation;
            mPendingEvents[Orientation].orientation.pitch   = value * CONVERT_O;
            break;
        case EVENT_TYPE_ROLL:
            mPendingMask |= 1<<Orientation;
            mPendingEvents[Orientation].orientation.roll   = value * CONVERT_O;
            break;
        case EVENT_TYPE_ORIENT_STATUS:
            mPendingMask |= 1<<Orientation;
                   mPendingEvents[Orientation].orientation.status =
                    uint8_t(value & SENSOR_STATE_MASK);
            break;
    }
}

static AkmAotController::SensorType convert_sensor_type(uint32_t sensor_type) {
    switch (sensor_type) {
        case SENSOR_TYPE_MAGNETIC_FIELD:
                return AkmAotController::AKM_SENSOR_TYPE_MAGNETOMETER;
        case SENSOR_TYPE_ORIENTATION:
                return AkmAotController::AKM_SENSOR_TYPE_ORIENTATION;
        default:
                return AkmAotController::AKM_SENSOR_TYPE_UNKNOWN;
        }
}
int AkmSensor::is_sensor_enabled(uint32_t sensor_type) {
        return (false == AkmAotController::getInstance().getEnabled(convert_sensor_type(sensor_type))) ? 0 : 1;
}

int AkmSensor::enable_sensor(uint32_t sensor_type) {
        AkmAotController::getInstance().setEnabled(convert_sensor_type(sensor_type), true);
        return 0;
}

int AkmSensor::disable_sensor(uint32_t sensor_type) {
        AkmAotController::getInstance().setEnabled(convert_sensor_type(sensor_type), false);
        return 0;
}

int AkmSensor::set_delay(int64_t ns[3]) {
        AkmAotController::getInstance().setDelay(ns);
        return 0;
}

int AkmSensor::forwardEvents(sensors_event_t *data)
{
	mAccels[AccelAxisX] =  (int16_t)(data->acceleration.x / GRAVITY_EARTH *  LSG);
    mAccels[AccelAxisY] =  (int16_t)(data->acceleration.y / GRAVITY_EARTH *  LSG);
	mAccels[AccelAxisZ] =  (int16_t)(data->acceleration.z / GRAVITY_EARTH *  LSG);
	 
	AkmAotController::getInstance().writeAccels(mAccels);
    return 0;
}

bool AkmSensor::isEnabled(int32_t handle) {
        switch (handle) {
        case SENSOR_TYPE_MAGNETIC_FIELD:
            return (0 != (mEnabled & AKM_ENABLED_BITMASK_M)) ? true : false;
        case SENSOR_TYPE_ORIENTATION:
            return (0 != (mEnabled & AKM_ENABLED_BITMASK_O)) ? true : false;
        default:
            ALOGE("Unknown handle(%d).", handle);
            return false;
    }
}
