#ifndef SYSTEMSTATUS_H
#define SYSTEMSTATUS_H

#include <QDBusMessage>

class SystemStatus : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(int coverStatus READ getCoverStatus NOTIFY coverStatusChanged())
    Q_PROPERTY(QString displayStatus READ getDisplayStatus NOTIFY displayStatusChanged())
    Q_PROPERTY(int deviceLock READ getDeviceLock NOTIFY deviceLockChanged())
    Q_PROPERTY(bool coverVisible READ getCoverVisible NOTIFY coverVisibleChanged())

    explicit SystemStatus(QObject *parent = 0);

public:
    int getCoverStatus() { return m_coverStatus; }
    QString getDisplayStatus() { return m_displayStatus; }
    int getDeviceLock() { return m_deviceLock; }
    bool getCoverVisible() { return m_coverVisible; }

public slots:
    void handleCoverStatusChange(const QDBusMessage& msg);
    void handleDisplayStatusChange(const QDBusMessage& msg);
    void handleDeviceLockChange(const QDBusMessage& msg);
private:
    void handleCoverVisibleChange();

signals:
    void coverStatusChanged();
    void displayStatusChanged();
    void deviceLockChanged();
    void coverVisibleChanged();

private:
    int m_coverStatus;
    QString m_displayStatus;
    int m_deviceLock;
    bool m_coverVisible;
};

#endif // SYSTEMSTATUS_H
