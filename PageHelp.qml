import QtQuick 2.10
import QtQuick.Layouts 1.3

Item {
    ColumnLayout {
        anchors { fill: parent; margins: 16 }
        spacing: 32


        Text {
            text: "维护手册"
            font.pointSize: 32
            Layout.alignment: Qt.AlignHCenter
            color: "white"
        }

        Flickable {
            Layout.fillHeight: true; Layout.fillWidth: true
            contentHeight: textContent.height
            clip: true
            Text {
                id: textContent
                width: parent.width
                font.pointSize: 18;
                wrapMode: Text.Wrap
                text: Backend.readFile(":/manual")
                textFormat: Text.StyledText
                padding: 24

                Rectangle { anchors.fill: parent; z: -1 }
            }
        }
    }
}
