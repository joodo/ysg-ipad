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
    connect(m_socket, &QAbstractSocket::readyRead, this, &Backend::onTcpReadyRead);

    // m_snapshotImageProvider = new SnapshotImageProvider();
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

void Backend::setConnectCode(const QString& code)
{
    m_hostAddress = "192.168.1." + code;
    emit hostAddressChanged(m_hostAddress);
}

void Backend::onTcpReadyRead()
{
    QString s = QString::fromUtf8(m_socket->readAll());
    if (s == "pong") {
        qDebug("pong");
        return;
    }
    if (s.startsWith("data:")) {
        m_snapshotUrlData = s;
        emit snapshotReceived();
    } else {
        m_snapshotUrlData += s;
    }
}

QString Backend::snapshotUrlData() const
{
    return m_snapshotUrlData;
}
