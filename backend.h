#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QTcpSocket>
#include <QTimer>
#include <QFile>
#include <QDateTime>

#include "socketsandbox.h"
#include "snapshotimageprovider.h"

class Backend : public QObject
{
    Q_OBJECT
public:
    explicit Backend(QObject *parent = nullptr);
    static Backend* instance();

private:
    static Backend* m_instance;

signals:
    void tcpConnected();
    void log(const QString& message);
    void socketStateChanged(int state);
    void hostAddressChanged(const QString& newAddress);

public slots:
    void connectToHost();
    void sendMessage(const QString& message);
    void lightAction(const QString& command);
    QString readFile(const QString& path);
    void setConnectCode(const QString& code);

private:
    SocketSandBox m_socketSandBox;
    QTcpSocket *m_socket = nullptr;

public:
    // SnapshotImageProvider *snapshotImageProvider() const;
signals:
    void snapshotReceived();
public slots:
    QString snapshotUrlData() const;
private slots:
    void onTcpReadyRead();
private:
    // SnapshotImageProvider *m_snapshotImageProvider;
    QString m_snapshotUrlData;

private:
    QString m_hostAddress;
};

#endif // BACKEND_H
