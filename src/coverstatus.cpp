#include <QDBusConnection>

#include "coverstatus.h"

CoverStatus::CoverStatus(QObject *parent) :
    QObject(parent)
{
    QDBusConnection::sessionBus().connect("", "/com/jolla/lipstick", "com.jolla.lipstick", "coverstatus",
  this, SLOT(handleStatusChange(const QDBusMessage&)));
}

void CoverStatus::handleStatusChange(const QDBusMessage& msg)
{
    QList<QVariant> args = msg.arguments();
    m_status = args.at(0).toInt();
    emit statusChanged();
}
