#ifndef SYSTEMSTATUS_H
#define SYSTEMSTATUS_H

#include <QDBusMessage>

class SystemStatus : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(int coverStatus READ getCoverStatus NOTIFY coverStatusChanged())
    Q_PROPERTY(QString displayStatus READ getDisplayStatus NOTIFY displayStatusChanged())

    explicit SystemStatus(QObject *parent = 0);

public:
    int getCoverStatus() { return m_coverStatus; }
    QString getDisplayStatus() { return m_displayStatus; }

public slots:
    void handleCoverStatusChange(const QDBusMessage& msg);
    void handleDisplayStatusChange(const QDBusMessage& msg);

signals:
    void coverStatusChanged();
    void displayStatusChanged();
private:
    int m_coverStatus;
    QString m_displayStatus;
};

#endif // SYSTEMSTATUS_H
