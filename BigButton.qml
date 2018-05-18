import QtQuick 2.10
import QtQuick.Controls 2.3

Button {
    id: button
    property color color: "#3b8cf3"
    property int fontSize: 26

    contentItem: Text {
        text: button.text
        font.pointSize: button.fontSize
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        color: "white"
    }
    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 75
        color: button.down||!button.enabled? Qt.darker(button.color, 1.3) : button.color
        radius: 4
    }
}
