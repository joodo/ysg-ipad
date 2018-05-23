import QtQuick 2.10
import QtQuick.Layouts 1.3

Rectangle {
    id: connectCodeInput

    function addNum(num) {
        textCode.text += num
    }
    function clearNum() {
        textCode.text = ""
    }
    function ok() {
        Backend.setConnectCode(textCode.text)
        Backend.sendMessage("ping")
        visible = false
    }

    color: "#212329"

    Rectangle {
        id: rectCode
        anchors.horizontalCenter: parent.horizontalCenter
        height: 64; width: 300
        Text {
            id: textCode
            anchors.centerIn: parent
            font.pointSize: 32
        }
    }
    GridLayout {
        anchors { top: rectCode.bottom; topMargin: 26; bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }
        width: 250
        columns: 3
        clip: true

        BigButton { Layout.preferredWidth: 75; text: "1"; onClicked: connectCodeInput.addNum(text) }
        BigButton { Layout.preferredWidth: 75; text: "2"; onClicked: connectCodeInput.addNum(text) }
        BigButton { Layout.preferredWidth: 75; text: "3"; onClicked: connectCodeInput.addNum(text) }
        BigButton { Layout.preferredWidth: 75; text: "4"; onClicked: connectCodeInput.addNum(text) }
        BigButton { Layout.preferredWidth: 75; text: "5"; onClicked: connectCodeInput.addNum(text) }
        BigButton { Layout.preferredWidth: 75; text: "6"; onClicked: connectCodeInput.addNum(text) }
        BigButton { Layout.preferredWidth: 75; text: "7"; onClicked: connectCodeInput.addNum(text) }
        BigButton { Layout.preferredWidth: 75; text: "8"; onClicked: connectCodeInput.addNum(text) }
        BigButton { Layout.preferredWidth: 75; text: "9"; onClicked: connectCodeInput.addNum(text) }
        BigButton { Layout.preferredWidth: 75; text: "清除"; onClicked: connectCodeInput.clearNum() }
        BigButton { Layout.preferredWidth: 75; text: "0"; onClicked: connectCodeInput.addNum(text) }
        BigButton { Layout.preferredWidth: 75; text: "确定"; onClicked: connectCodeInput.ok() }
    }
}
