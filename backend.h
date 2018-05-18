#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QTcpSocket>
#include <QTimer>
#include <QFile>

#include "socketsandbox.h"

class Backend : public QObject
{
    Q_OBJECT
public:
    explicit Backend(QObject *parent = nullptr);

signals:
    void tcpConnected();

public slots:
    void connectToHost();
    void sendMessage(const QString& message);
    void lightAction(const QString& command);
    QString readFile(const QString& path);

private:
    SocketSandBox m_socketSandBox;
    QTcpSocket *m_socket = nullptr;
};

#endif // BACKEND_H
