/*
 * Copyright (C) 2008 The Android Open Source Project
 * Copyright (C) 2011 Sorin P. <sorin@hypermagik.com>
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

#include <cutils/log.h>

#include "isl29030.h"

#include "ISL29030Sensor.h"

#define TAG "ISL29030"

#define PROX_DEVICE "light-prox"
#define ISL_DEVICE  "light-prox"

#define ISL_PROXIMITY_NEAR 30
#define ISL_PROXIMITY_FAR 1000


/*****************************************************************************/

ISL29030SensorP::ISL29030SensorP()
  : SensorBase(ISL29030_DEVICE_NAME, PROX_DEVICE),
    mEnabled(0),
    mInputReader(32)
{
    memset(&mPendingEvent, 0, sizeof(mPendingEvent));

    mPendingEvent.version = sizeof(sensors_event_t);
    mPendingEvent.sensor = SENSOR_TYPE_PROXIMITY;
    mPendingEvent.type = SENSOR_TYPE_PROXIMITY;

    open_device();

    mEnabled = isEnabled();

    if (!mEnabled) {
        close_device();
    }
}

ISL29030SensorP::~ISL29030SensorP()
{
}

int ISL29030SensorP::enable(int32_t handle, int en)
{
    int err = 0;

    char newState = en ? 1 : 0;
    if (newState == mEnabled) {
        return err;
    }

    if (!mEnabled) {
        open_device();
    }

    err = ioctl(dev_fd, ISL29030_IOCTL_SET_ENABLE, &newState);
    err = err < 0 ? -errno : 0;

    ALOGE_IF(err, TAG "P: ISL29030_IOCTL_SET_ENABLE failed (%s)", strerror(-err));

    if (!err || !newState) {
        mEnabled = newState;
    }

    if (!mEnabled) {
        close_device();
    }

    return err;
}

int ISL29030SensorP::readEvents(sensors_event_t* data, int count)
{
    if (count < 1) {
        return -EINVAL;
    }

    ssize_t n = mInputReader.fill(data_fd);
    if (n < 0) {
        return n;
    }

    int numEventReceived = 0;
    input_event const* event;

    while (count && mInputReader.readEvent(&event)) {
        switch (event->type) {
            case EV_MSC:
                processEvent(event->code, event->value);
                break;
            case EV_LED:
                //ignore light events, from same input device
                break;
            case EV_SYN:
                mPendingEvent.timestamp = timevalToNano(event->time);
                *data++ = mPendingEvent;
                count--;
                numEventReceived++;
                break;
            default:
                ALOGW(TAG "P: unknown event (type=0x%x, code=0x%x, value=0x%x)",
                        event->type, event->code, event->value);
                break;
        }
        mInputReader.next();
    }

    return numEventReceived;
}

void ISL29030SensorP::processEvent(int code, int value)
{
    switch (code) {
        case MSC_RAW:
            //ALOGD(TAG "P: proximity event (code=0x%x, value=0x%x)", code, value);
            mPendingEvent.distance = (value == ISL_PROXIMITY_NEAR ? 3 : 100);
            break;
        default:
            ALOGW(TAG "P: proximity unknown code (code=0x%x, value=0x%x)", code, value);
            break;
    }
}

int ISL29030SensorP::isEnabled()
{
    int err = 0;
    char enabled = 0;

    err = ioctl(dev_fd, ISL29030_IOCTL_GET_ENABLE, &enabled);
    err = err < 0 ? -errno : 0;

    ALOGE_IF(err, TAG "P: ISL29030_IOCTL_GET_ENABLE failed (%s)", strerror(-err));

    return enabled;
}

/*****************************************************************************/

ISL29030SensorL::ISL29030SensorL()
  : SensorBase(ISL29030_DEVICE_NAME, ISL_DEVICE),
    mEnabled(0),
    mInputReader(32)
{
    memset(&mPendingEvent, 0, sizeof(mPendingEvent));

    mPendingEvent.version = sizeof(sensors_event_t);
    mPendingEvent.sensor = SENSOR_TYPE_LIGHT;
    mPendingEvent.type = SENSOR_TYPE_LIGHT;

    open_device();

    mEnabled = isEnabled();

    if (!mEnabled) {
        close_device();
    }

}

ISL29030SensorL::~ISL29030SensorL()
{
}

int ISL29030SensorL::enable(int32_t handle, int en)
{
    int err = 0;

    char newState = en ? 1 : 0;
    if (newState == mEnabled) {
        return err;
    }

    if (!mEnabled) {
        open_device();
    }

    err = ioctl(dev_fd, ISL29030_IOCTL_SET_LIGHT_ENABLE, &newState);
    err = err < 0 ? -errno : 0;

    ALOGE_IF(err, TAG "L: ISL29030_IOCTL_SET_LIGHT_ENABLE failed (%s)", strerror(-err));

    if (!err || !newState) {
        mEnabled = newState;
    }

    if (!mEnabled) {
        close_device();
    }

    mEnabled = en ? 1 : 0;

    return err;
}


int ISL29030SensorL::isEnabled()
{
    int err = 0;
    char enabled = 0;

    err = ioctl(dev_fd, ISL29030_IOCTL_GET_LIGHT_ENABLE, &enabled);
    err = err < 0 ? -errno : 0;

    ALOGE_IF(err, TAG "L: ISL29030_IOCTL_GET_LIGHT_ENABLE failed (%s)", strerror(-err));

    return enabled;
}


int ISL29030SensorL::readEvents(sensors_event_t* data, int count)
{
    if (count < 1) {
        return -EINVAL;
    }

    ssize_t n = mInputReader.fill(data_fd);
    if (n < 0) {
        return n;
    }

    int numEventReceived = 0;
    input_event const* event;

    while (count && mInputReader.readEvent(&event)) {
        switch (event->type) {
            case EV_MSC:
                /* ignored, prox event*/
                break;
            case EV_LED:
                processEvent(event->code, event->value);
                break;
            case EV_SYN:
                mPendingEvent.timestamp = timevalToNano(event->time);
                *data++ = mPendingEvent;
                count--;
                numEventReceived++;
                break;
            default:
                ALOGW(TAG "L: unknown event (type=0x%x, code=0x%x, value=0x%x)",
                        event->type, event->code, event->value);
                break;
        }
        mInputReader.next();
    }

    return numEventReceived;
}

void ISL29030SensorL::processEvent(int code, int value)
{
    switch (code) {
        case LED_MISC:
            mPendingEvent.light = value;
            break;
        default:
            ALOGW(TAG "L: unknown code (code=0x%x, value=0x%x)", code, value);
            break;
    }
}
