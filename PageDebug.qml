import QtQuick 2.10
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3

Item {
    ColumnLayout {
        anchors { fill: parent; margins: 16 }
        spacing: 32

        Row {
            spacing: 16
            BigButton {
                text: "ping"
                onClicked: Backend.sendMessage("ping")
            }
            Text {
                id: textHostAddress
                font.pointSize: 32
                anchors.verticalCenter: parent.verticalCenter
                color: "white"
                text: "0.0.0.0"
            }
            Text {
                id: textSocketState
                font.pointSize: 32
                anchors.verticalCenter: parent.verticalCenter
                color: "white"
                text: "0"
            }
        }

        ScrollView {
            Layout.fillHeight: true; Layout.fillWidth: true;
            clip: true

            TextArea {
                id: textAreaLog
                Rectangle {
                    anchors.fill: parent
                    z: -1
                }
            }
        }
    }

    Connections {
        target: Backend
        onLog: textAreaLog.append(message)
        onSocketStateChanged: {
            print("Socket state changed: " + state)
            textSocketState.text = state
        }
        onHostAddressChanged: textHostAddress.text = newAddress
    }
}
