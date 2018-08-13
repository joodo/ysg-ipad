import QtQuick 2.10
import QtQuick.Controls 2.3

Rectangle {
    id: popupZoom

    onVisibleChanged: {
        if (visible) {
            imageSnapshot.source = Backend.snapshotUrlData()
            imageSnapshot.scale = 1
            //imageSnapshot.source = "image://snapshot/"
        }
    }

    color: "#cc000000"

    Image {
        id: imageSnapshot

        property real xOffset: 0
        property real yOffset: 0

        fillMode: Image.PreserveAspectFit
        transformOrigin: Item.TopLeft
        onStatusChanged: {
            if (status === Image.Ready) {
                var videoSize = sourceSize
                var videoRatio = videoSize.width / videoSize.height
                var itemRatio = popupZoom.width / popupZoom.height
                if (itemRatio > videoRatio) {
                    height = popupZoom.height
                    y = 0
                    yOffset = 0

                    width = height * videoRatio
                    x = (popupZoom.width-width) / 2
                    xOffset = x
                } else {
                    width = popupZoom.width
                    x = 0
                    xOffset = 0

                    height = width / videoRatio
                    y = (popupZoom.height-height) / 2
                    yOffset = y
                }
            }
        }

        PinchArea {
            function sendSnapshotPos() {
                var scale = imageSnapshot.sourceSize.width / imageSnapshot.width
                var message = "snapshotmove " +
                        ((imageSnapshot.x-imageSnapshot.xOffset)*scale).toFixed(2) + " " +
                        ((imageSnapshot.y-imageSnapshot.yOffset)*scale).toFixed(2) + " " +
                        imageSnapshot.scale.toFixed(2)
                Backend.sendMessage(message)
            }

            anchors.fill: parent
            pinch.minimumScale: 1
            pinch.maximumScale: 2
            pinch.target: imageSnapshot
            pinch.dragAxis: Pinch.XAndYAxis
            onPinchFinished: sendSnapshotPos()

            MouseArea {
                anchors.fill: parent
                drag.target: imageSnapshot
                onReleased: parent.sendSnapshotPos()
            }
        }
    }
    Button {
        text: "关闭"
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 20
        }

        onClicked: popupZoom.visible = false
    }
}
