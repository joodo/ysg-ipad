import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3

Window {
    visible: true
    title: qsTr("Hello World")
    width: 800; height: 800
    color: "#212329"

    SwipeView {
        id: view

        anchors.fill: parent
        currentIndex: 2

        PageDebug {}
        PageHelp {}
        PagePower {}
        PageSandbox {}
    }
}
