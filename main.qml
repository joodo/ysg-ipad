import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3

Window {
    id: window
    visible: true
    title: qsTr("Hello World")
    visibility: Window.FullScreen
    color: "#212329"

    SwipeView {
        id: view

        currentIndex: 2
        anchors.horizontalCenter: parent.horizontalCenter
        width: 1536; height: parent.height

        PageDebug {}
        PageHelp {}
        PagePower {}
        PageSandbox {}
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Back) {
            console.log("Back button of phone pressed")
            event.accepted = true
        }
    }
}
