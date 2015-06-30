#include <QDBusConnection>

#include "systemstatus.h"

SystemStatus::SystemStatus(QObject *parent) :
    QObject(parent)
{
    QDBusConnection::sessionBus().connect("", "/com/jolla/lipstick", "com.jolla.lipstick", "coverstatus",
                                          this, SLOT(handleCoverStatusChange(const QDBusMessage&)));
    QDBusConnection::systemBus().connect("", "/com/nokia/mce/signal", "com.nokia.mce.signal", "display_status_ind",
                                         this, SLOT(handleDisplayStatusChange(const QDBusMessage&)));
}

void SystemStatus::handleCoverStatusChange(const QDBusMessage& msg)
{
    QList<QVariant> args = msg.arguments();
    m_coverStatus = args.at(0).toInt();
    emit coverStatusChanged();
}

void SystemStatus::handleDisplayStatusChange(const QDBusMessage& msg)
{
    QList<QVariant> args = msg.arguments();
    m_displayStatus = args.at(0).toString();
    emit displayStatusChanged();
}
