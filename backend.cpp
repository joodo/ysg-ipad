#include "backend.h"

Backend* Backend::m_instance = nullptr;

void myMessageOutput(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    Backend::instance()->log(QDateTime::currentDateTime().toString(Qt::ISODate) + ": " + msg);
}

Backend::Backend(QObject *parent) : QObject(parent)
{
    qInstallMessageHandler(myMessageOutput);

    m_socket = new QTcpSocket();
    connect(m_socket, &QAbstractSocket::connected, this, &Backend::tcpConnected);
    connect(m_socket, &QAbstractSocket::stateChanged, this, &Backend::socketStateChanged);
    connect(m_socket, &QAbstractSocket::readyRead, [=]() {
        QString message = "Host response: " + m_socket->readAll();
        qDebug(message.toUtf8());
    });

    m_udpSocket = new QUdpSocket();
    m_udpSocket->bind(QHostAddress::AnyIPv4, 8901);
    connect(m_udpSocket, &QUdpSocket::readyRead, [=]() {
        QByteArray array;
        array.resize(m_udpSocket->bytesAvailable());//根据可读数据来设置空间大小
        m_udpSocket->readDatagram(array.data(), array.size()); //读取数据

        QString message = QString(array);
        if (message.startsWith("ysgserver:")) {
            QString hostAddress = message.mid(10);
            if (m_hostAddress != hostAddress) {
                emit hostAddressChanged(hostAddress);
            }
        }
    });
    connect(this, &Backend::hostAddressChanged, [=](const QString& newAddress) {
        m_hostAddress = newAddress;
        qDebug(("Host address changed: "+m_hostAddress).toUtf8());
    });
}

Backend *Backend::instance()
{
    if (m_instance == nullptr) {
        m_instance = new Backend();
    }
    return m_instance;
}

void Backend::connectToHost()
{
    m_socket->connectToHost(m_hostAddress, 8899);
}

void Backend::sendMessage(const QString &message)
{
    qDebug("sendMessage: %s", message.toStdString().c_str());
    if (m_socket->state() != QAbstractSocket::ConnectedState) {
        m_socket->abort();
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
