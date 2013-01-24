#include <fcntl.h>
#include <cfloat>
#include <cerrno>
#include <cutils/log.h>

#include "inc/akm8975.h"

#include "AkmAotController.h"

#define AKM_AOT_DEVICE_PATH "/dev/akm8975_aot"

static AkmAotController g_instance_;

AkmAotController::AkmAotController()
        : aot_fd(-1), m_magEn(0), m_accEn(0), m_oriEn(0), mLock(), m_solEn(0)
{
        if (0 > ioctl(ECS_IOCTL_APP_GET_MVFLAG, &m_magEn)) {
                ALOGE_IF(ENXIO != errno, "%s - ioctl failed (%s).", __func__, strerror(errno));
        }
        if (0 > ioctl(ECS_IOCTL_APP_GET_AFLAG, &m_accEn)) {
                ALOGE_IF(ENXIO != errno, "%s - ioctl failed (%s).", __func__, strerror(errno));
        }
        if (0 > ioctl(ECS_IOCTL_APP_GET_AFLAG, &m_oriEn)) {
                ALOGE_IF(ENXIO != errno, "%s - ioctl failed (%s).", __func__, strerror(errno));
        }
        closeDevice_internal();
}

AkmAotController::~AkmAotController()
{
        closeDevice_internal();
}

AkmAotController & AkmAotController::getInstance()
{
        return g_instance_;
}

void AkmAotController::writeAccels(int16_t value[ACCEL_AXIS])
{
        if (0 <= aot_fd) {
                if (0 > ioctl(ECS_IOCTL_APP_SET_ACCEL, value)) {
                        ALOGE_IF(ENXIO != errno, "%s - ioctl failed (%s).", __func__, strerror(errno));
                }
        }
}

bool AkmAotController::getEnabled(SensorType sensorType)
{
        switch (sensorType) {
        case AKM_SENSOR_TYPE_MAGNETOMETER:
                return (0 == m_magEn) ? false : true;
        case AKM_SENSOR_TYPE_ACCELEROMETER:
                return (0 == m_accEn) ? false : true;
        case AKM_SENSOR_TYPE_ORIENTATION:
                return (0 == m_oriEn) ? false : true;
        default:
                ALOGE("Unknown sensor type.");
                return false;
        }
}

void AkmAotController::setSolanaFlag() {

	if(!m_solEn) { 
		short solana = 1;
		if ( 0 > ioctl(ECS_IOCTL_APP_SET_SOLANAFLAG, &solana)) {
			ALOGE_IF(ENXIO != errno, "%s - ioctl failed (%s).", __func__, strerror(errno));
		}
		m_solEn = solana;
	}
}

void AkmAotController::setEnabled(SensorType sensorType, bool isEnabled)
{
        unsigned int cmd;
        short value = (false == isEnabled) ? 0 : 1;
		
	//lets set switch to flip x and y in driver to fix solana
	setSolanaFlag();
		
        switch (sensorType) {
        case AKM_SENSOR_TYPE_MAGNETOMETER:
                cmd = ECS_IOCTL_APP_SET_MVFLAG;
                break;
        case AKM_SENSOR_TYPE_ACCELEROMETER:
                cmd = ECS_IOCTL_APP_SET_AFLAG;
                break;
        case AKM_SENSOR_TYPE_ORIENTATION:
                cmd = ECS_IOCTL_APP_SET_MFLAG;
                break;
        default:
                ALOGE("Unknown sensor type.");
                return;
        }
        if (0 > ioctl(cmd, &value)) {
                ALOGE_IF(ENXIO != errno, "%s - ioctl failed (%s).", __func__, strerror(errno));
        } else {
                switch (sensorType) {
                case AKM_SENSOR_TYPE_MAGNETOMETER:
                        m_magEn = value;
                        break;
                case AKM_SENSOR_TYPE_ACCELEROMETER:
                        m_accEn = value;
                        break;
                case AKM_SENSOR_TYPE_ORIENTATION:
                        m_oriEn = value;
                        break;
                default:
                        break;
                }
        }
        // Currently, ignore accelerometer
        if ((m_magEn == 0) && (m_oriEn == 0)) {
                closeDevice_internal();
        }
        //ALOGD("Enabled: Mag(%d), Acc(%d), Ori(%d)", m_magEn, m_accEn, m_oriEn);
}

void AkmAotController::setDelay(int64_t ns[3])
{
        if (0 > ioctl(ECS_IOCTL_APP_SET_DELAY, ns)) {
                ALOGE_IF(ENXIO != errno, "%s - ioctl failed (%s).", __func__, strerror(errno));
        }
        //ALOGD("Delay: Mag(%lld), Acc(%lld), Ori(%lld)", ns[0], ns[1], ns[2]);
}

int AkmAotController::ioctl(unsigned int cmd, void *argp)
{
        if (!openDevice()){
                return -1;
        }
        if (0 > ::ioctl(aot_fd, cmd, argp)) {
                return -1;
        }
        return 0;
}

bool AkmAotController::openDevice() {
        android::AutoMutex lock(mLock);
        return openDevice_internal();
}

void AkmAotController::closeDevice() {
        android::AutoMutex lock(mLock);
        closeDevice_internal();
}

bool AkmAotController::openDevice_internal()
{
        if (0 <= aot_fd) {
                return true;
        }
        aot_fd = open(AKM_AOT_DEVICE_PATH, O_RDWR);
        if (0 > aot_fd) {
                ALOGE("Colud not open AKM's aot device file (%s).", strerror(errno));
                return false;
        }
        return true;
}

void AkmAotController::closeDevice_internal()
{
        if (0 <= aot_fd) {
                int const errno_old = errno;
                close(aot_fd);
                aot_fd = -1;
                errno = errno_old;
        }
}
