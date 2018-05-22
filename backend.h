#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QTcpSocket>
#include <QTimer>
#include <QFile>
#include <QDateTime>
#include <QUdpSocket>

#include "socketsandbox.h"

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

private:
    SocketSandBox m_socketSandBox;
    QTcpSocket *m_socket = nullptr;

private:
    QString m_hostAddress;
    QUdpSocket *m_udpSocket = nullptr;
};

#endif // BACKEND_H
