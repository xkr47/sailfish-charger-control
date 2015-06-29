#ifndef COVERSTATUS_H
#define COVERSTATUS_H

#include <QDBusMessage>

class CoverStatus : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(int status READ getStatus NOTIFY statusChanged())

    explicit CoverStatus(QObject *parent = 0);

public:
    int getStatus() { return m_status; }

public slots:
    void handleStatusChange(const QDBusMessage& msg);

signals:
    void statusChanged();
private:
    int m_status;
};

#endif // COVERSTATUS_H
