import QtQuick 2.10
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3

Item {
    Component.onCompleted: {
        if (Qt.platform.os === "android") scale = 1200/1536
    }
    PopupZoom {
        id: popupZoom
        anchors.fill: parent
        z: 100
        visible: false
    }

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
                            connectCodeInput.visible = true
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
                        onClicked: dialog.visible = true
                    }
                }
            ]
        }

        Item {
            width: 700; height: 450
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
                        onClicked: {
                            buttonZoom.visible = false
                            Backend.sendMessage("a")
                        }
                    }
                    BigButton {
                        text: "宣传片英文"
                        onClicked: {
                            buttonZoom.visible = false
                            Backend.sendMessage("b")
                        }
                    }
                    BigButton {
                        text: "幻灯片"
                        onClicked: {
                            buttonZoom.visible = false
                            Backend.sendMessage("c")
                        }
                    }
                }

                Row {
                    y: 240; anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 16
                    MyRoundButton {
                        source: "qrc:/img/play.png"
                        onClicked: {
                            buttonZoom.visible = false
                            Backend.sendMessage("play")
                        }
                    }
                    MyRoundButton {
                        source: "qrc:/img/pause.png"
                        onClicked: {
                            buttonZoom.visible = true
                            Backend.sendMessage("pause")
                        }

                        MyRoundButton {
                            id: buttonZoom
                            onVisibleChanged: busyIndicator.running = visible
                            y: 80
                            source: "qrc:/img/zoom.png"
                            visible: false
                            onClicked: popupZoom.visible = true
                            enabled: !busyIndicator.running
                            Rectangle {
                                anchors.centerIn: parent
                                width: parent.width; height: width; radius: width
                                color: "#ccffffff"
                                visible: busyIndicator.running
                                z: 5
                            }
                            BusyIndicator {
                                id: busyIndicator
                                anchors.centerIn: parent
                                width: 56; height: 56
                                running: true
                                z: 10
                                Connections {
                                    target: Backend
                                    onSnapshotReceived: busyIndicator.running = false
                                }
                            }
                            Timer {
                                // 重复发出截图请求
                                interval: 1000; triggeredOnStart: false; running: busyIndicator.running; repeat: true
                                onTriggered: Backend.sendMessage("pause")
                            }
                        }
                    }
                    MyRoundButton {
                        source: "qrc:/img/stop.png"
                        onClicked: {
                            buttonZoom.visible = false
                            Backend.sendMessage("stop")
                        }
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

            ConnectCodeInput {
                id: connectCodeInput
                anchors.fill: parent
                z: 1
                visible: false
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
                z: 2

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

    Dialog {
        id: dialog
        standardButtons: Dialog.Yes | Dialog.No
        modal: true
        x: (parent.width-width) / 2; y: (parent.height-height)/2

        Text {
            text: "确认关闭电源吗？"
            font.pointSize: 32
        }

        onAccepted: {
            buttonPower.enabled = false
            buttonPower.text = "正在关闭…"
            rectMediaControl.visible = false
            connectCodeInput.visible = false
            rectWaitMask.wait(25000)

            Backend.sendMessage("shutdown")
            Backend.lightAction("1b43dd0d0a660080,1b43dd0d0a660000")
        }
    }
}
