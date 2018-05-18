import QtQuick 2.10
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3

Item {
    ColumnLayout {
        anchors { top: parent.top; left: parent.left; right: parent.right; margins: 16 }
        spacing: 32


        Text {
            text: "电源和视频播放"
            font.pointSize: 32
            Layout.alignment: Qt.AlignHCenter
            color: "white"
        }

        BigButton {
            id: buttonPower
            state: "poweroff"
            fontSize: 32
            Layout.alignment: Qt.AlignHCenter

            states: [
                State {
                    name: "poweroff"
                    PropertyChanges {
                        target: buttonPower
                        text: "打开电源"
                        color: "#1fcc75"
                        enabled: true
                        onClicked: {
                            enabled = false
                            text = "正在打开…"
                            rectMediaControl.visible = true
                            rectWaitMask.wait(50000)
                            Backend.lightAction("1b43dd0d0a650080,1b43dd0d0a650000")
                        }
                    }
                },
                State {
                    name: "poweron"
                    PropertyChanges {
                        target: buttonPower
                        text: "关闭电源"
                        color: "#e55c5c"
                        enabled: true
                        onClicked: {
                            enabled = false
                            text: "正在关闭…"
                            rectMediaControl.visible = false
                            rectWaitMask.wait(25000)

                            Backend.sendMessage("shutdown")
                            Backend.lightAction("1b43dd0d0a660080,1b43dd0d0a660000")
                        }
                    }
                }
            ]
        }

        Item {
            width: 700; height: 400
            Layout.alignment: Qt.AlignHCenter


            Rectangle {
                id: rectMediaControl
                anchors.fill: parent
                color: "#292d38"
                visible: false

                Row {
                    y: 64; anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 16
                    BigButton {
                        text: "宣传片中文"
                        onClicked: Backend.sendMessage("a")
                    }
                    BigButton {
                        text: "宣传片英文"
                        onClicked: Backend.sendMessage("b")
                    }
                    BigButton {
                        text: "幻灯片"
                        onClicked: Backend.sendMessage("c")
                    }
                }

                Row {
                    y: 240; anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 16
                    MyRoundButton {
                        source: "qrc:/img/play.png"
                        onClicked: Backend.sendMessage("play")
                    }
                    MyRoundButton {
                        source: "qrc:/img/pause.png"
                        onClicked: Backend.sendMessage("pause")
                    }
                    MyRoundButton {
                        source: "qrc:/img/stop.png"
                        onClicked: Backend.sendMessage("stop")
                    }
                    Item { height: 1; width: 16 }
                    MyRoundButton {
                        source: "qrc:/img/volume_up.png"
                        onClicked: Backend.sendMessage("volumeup")
                    }
                    MyRoundButton {
                        source: "qrc:/img/volume_down.png"
                        onClicked: Backend.sendMessage("volumedown")
                    }
                    MyRoundButton {
                        source: "qrc:/img/mute.png"
                        onClicked: Backend.sendMessage("mute")
                    }
                }
            }

            Rectangle {
                id: rectWaitMask
                function wait(duration) {
                    rectWaitMask.visible = true
                    anime.duration = duration
                    anime.start()
                }

                anchors.fill: parent
                color: "#212329"
                visible: false

                ProgressBar {
                    id: progressBar
                    y: 56; anchors.horizontalCenter: parent.horizontalCenter

                    background: Rectangle {
                        implicitWidth: 600
                        implicitHeight: 6
                        color: "#e6e6e6"
                        radius: 3
                    }
                    contentItem: Item {
                        implicitWidth: 600
                        implicitHeight: 4

                        Rectangle {
                            width: progressBar.visualPosition * parent.width
                            height: parent.height
                            radius: 2
                            color: "#3b8cf3"
                        }
                    }


                    PropertyAnimation {
                        id: anime
                        target: progressBar; property: "value"; from: 0; to: 1
                        onStopped: {
                            if (buttonPower.state === "poweroff") buttonPower.state = "poweron"
                            else buttonPower.state = "poweroff"
                            rectWaitMask.visible = false
                        }
                    }
                }
            }
        }
    }
}
