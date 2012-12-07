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

#include <linux/kxtf9.h>

#include <cutils/log.h>

#include "KXTF9Sensor.h"

/*****************************************************************************/

KXTF9Sensor::KXTF9Sensor()
    : SensorBase(KXTF9_DEVICE_NAME, "accelerometer"),
      mEnabled(0),
      mOrientationEnabled(0),
      mInputReader(32)
{
    mPendingEvent.version = sizeof(sensors_event_t);
    mPendingEvent.sensor = SENSOR_TYPE_ACCELEROMETER;
    mPendingEvent.type = SENSOR_TYPE_ACCELEROMETER;
    mPendingEvent.acceleration.status = SENSOR_STATUS_ACCURACY_HIGH;
    memset(mPendingEvent.data, 0x00, sizeof(mPendingEvent.data));

    open_device();

    int flags = 0;
    if (!ioctl(dev_fd, KXTF9_IOCTL_GET_ENABLE, &flags)) {
        if (flags)  {
            mEnabled = 1;
        }
    }
    if (!mEnabled) {
        close_device();
    }
}

KXTF9Sensor::~KXTF9Sensor() {
}

int KXTF9Sensor::enable(int32_t, int en)
{
    int flags = en ? 1 : 0;
    int err = 0;
    if (flags != mEnabled) {
        // don't turn the accelerometer off, if the orientation
        // sensor is enabled
        if (mOrientationEnabled && !en) {
            mEnabled = flags;
            return 0;
        }
        if (flags) {
            open_device();
        }
        err = ioctl(dev_fd, KXTF9_IOCTL_SET_ENABLE, &flags);
        err = err<0 ? -errno : 0;
        ALOGE_IF(err, "KXTF9_IOCTL_SET_ENABLE failed (%s)", strerror(-err));
        if (!err) {
            mEnabled = flags;
        }
        if (!flags) {
            close_device();
        }
    }
    return err;
}

int KXTF9Sensor::enableOrientation(int en)
{
    int flags = en ? 1 : 0;
    int err = 0;
    if (flags != mOrientationEnabled) {
        // don't turn the accelerometer off, if the user has requested it
        if (mEnabled && !en) {
            mOrientationEnabled = flags;
            return 0;
        }

        if (flags) {
            open_device();
        }
        err = ioctl(dev_fd, KXTF9_IOCTL_SET_ENABLE, &flags);
        err = err<0 ? -errno : 0;
        ALOGE_IF(err, "KXTF9_IOCTL_SET_ENABLE failed (%s)", strerror(-err));
        if (!err) {
            mOrientationEnabled = flags;
        }
        if (!flags) {
            close_device();
        }
    }
    return err;
}

int KXTF9Sensor::setDelay(int32_t handle, int64_t ns)
{
    if (ns < 0)
        return -EINVAL;

    if (mEnabled || mOrientationEnabled) {
        int delay = ns / 1000000;
        if (ioctl(dev_fd, KXTF9_IOCTL_SET_DELAY, &delay)) {
            return -errno;
        }
    }
    return 0;
}

int KXTF9Sensor::readEvents(sensors_event_t* data, int count)
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
        } else if (type == EV_SYN) {
            int64_t time = timevalToNano(event->time);
            mPendingEvent.timestamp = time;
            if (mEnabled) {
                *data++ = mPendingEvent;
                count--;
                numEventReceived++;
            }
        } else {
            ALOGE("KXTF9Sensor: unknown event (type=%d, code=%d)",
                    type, event->code);
        }
        mInputReader.next();
    }

    return numEventReceived;
}

void KXTF9Sensor::processEvent(int code, int value)
{
    switch (code) {
		//x and y are backwards for d3 it seems....
        case ABS_X:
            mPendingEvent.acceleration.y = value * CONVERT_A_Y;
            break;
        case ABS_Y:
            mPendingEvent.acceleration.x = value * CONVERT_A_X;
            break;
        case ABS_Z:
            mPendingEvent.acceleration.z = value * CONVERT_A_Z;
            break;
    }
}
