#ifndef SNAPSHOTIMAGEPROVIDER_H
#define SNAPSHOTIMAGEPROVIDER_H

#include <QQuickImageProvider>

class SnapshotImageProvider : public QQuickImageProvider
{
public:
    SnapshotImageProvider()
              : QQuickImageProvider(QQuickImageProvider::Pixmap)
          {
          }
public:
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize) override;

public:
    void setData(const QByteArray& data);
private:
    QByteArray m_data;
};

#endif // SNAPSHOTIMAGEPROVIDER_H
