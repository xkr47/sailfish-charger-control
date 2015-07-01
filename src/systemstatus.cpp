#include <QDBusConnection>

#include "systemstatus.h"

SystemStatus::SystemStatus(QObject *parent) :
    QObject(parent),
    m_coverStatus(0),
    m_displayStatus("on"),
    m_deviceLock(0),
    m_coverVisible(false)
{
    QDBusConnection::sessionBus().connect("", "/com/jolla/lipstick", "com.jolla.lipstick", "coverstatus",
                                          this, SLOT(handleCoverStatusChange(const QDBusMessage&)));
    QDBusConnection::systemBus().connect("", "/com/nokia/mce/signal", "com.nokia.mce.signal", "display_status_ind",
                                         this, SLOT(handleDisplayStatusChange(const QDBusMessage&)));
    QDBusConnection::systemBus().connect("", "/devicelock", "org.nemomobile.lipstick.devicelock", "stateChanged",
                                         this, SLOT(handleDeviceLockChange(const QDBusMessage&)));
}

void SystemStatus::handleCoverStatusChange(const QDBusMessage& msg)
{
    QList<QVariant> args = msg.arguments();
    m_coverStatus = args.at(0).toInt();
    emit coverStatusChanged();
    this->handleCoverVisibleChange();
}

void SystemStatus::handleDisplayStatusChange(const QDBusMessage& msg)
{
    QList<QVariant> args = msg.arguments();
    m_displayStatus = args.at(0).toString();
    emit displayStatusChanged();
    this->handleCoverVisibleChange();
}

void SystemStatus::handleDeviceLockChange(const QDBusMessage& msg)
{
    QList<QVariant> args = msg.arguments();
    m_deviceLock = args.at(0).toInt();
    emit deviceLockChanged();
    this->handleCoverVisibleChange();
}

void SystemStatus::handleCoverVisibleChange() {
    bool newCoverVisible = m_coverStatus != 0 && m_displayStatus != "off" && m_deviceLock == 0;
    if (newCoverVisible != m_coverVisible) {
        m_coverVisible = newCoverVisible;
        emit coverVisibleChanged();
    }
}
