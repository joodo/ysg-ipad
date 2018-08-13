#include "snapshotimageprovider.h"

QPixmap SnapshotImageProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    Q_UNUSED(id)
    QPixmap pixmap(300, 300);
    pixmap.fill(QColor("red"));
    //pixmap.loadFromData(m_data);
    if (size) *size = pixmap.size();
    return pixmap;
    return pixmap.scaled(requestedSize, Qt::KeepAspectRatio);
}

void SnapshotImageProvider::setData(const QByteArray &data)
{
    m_data = data;
}
