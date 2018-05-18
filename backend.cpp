#include "backend.h"

Backend::Backend(QObject *parent) : QObject(parent)
{
    m_socket = new QTcpSocket();
    connect(m_socket, &QAbstractSocket::connected, this, &Backend::tcpConnected);
}

void Backend::connectToHost()
{
    m_socket->connectToHost("192.168.1.248", 8899);
}

void Backend::sendMessage(const QString &message)
{
    if (m_socket->state() != QAbstractSocket::ConnectedState) {
        connectToHost();
        QTimer::singleShot(500, [=]() { m_socket->write(message.toUtf8()); });
    } else {
        m_socket->write(message.toUtf8());
    }
}

void Backend::lightAction(const QString &command)
{
    m_socketSandBox.sendCommand(command);
}

QString Backend::readFile(const QString &path)
{
    QFile file(path);
    QString re;
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        re = file.readAll();
        file.close();
    }
    return re;
}
