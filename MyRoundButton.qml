import QtQuick 2.10
import QtQuick.Controls 2.3

Button {
    id: button
    property color color: "#7d8999"
    property string source

    contentItem: Item {
        Image {
            anchors.centerIn: parent
            width: 36
            fillMode: Image.PreserveAspectFit
            source: button.source
        }
    }
    background: Rectangle {
        implicitWidth: 64
        implicitHeight: 64
        color: button.down||!button.enabled? Qt.darker(button.color, 1.3) : button.color
        radius: 64
    }
}
