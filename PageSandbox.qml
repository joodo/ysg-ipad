import QtQuick 2.10
import QtQuick.Layouts 1.3

Item {
    ColumnLayout {
        anchors { top: parent.top; left: parent.left; right: parent.right; margins: 16 }
        spacing: 32


        Text {
            text: "沙盘灯光控制"
            font.pointSize: 32
            Layout.alignment: Qt.AlignHCenter
            color: "white"
        }

        Grid {
            id: gridButtons


            function buttonClicked(number) {
                Backend.lightAction("1b43dd0d0a%100080,1b43dd0d0a%100000".arg(number))
            }

            Layout.alignment: Qt.AlignHCenter
            columns: 3
            spacing: 16


            BigButton {
                text: "全部"
                color: "#2fc2b1"
                onClicked: gridButtons.buttonClicked("af")
            }
            Item { width: 1; height: 1 }
            BigButton {
                text: "中心区域"
                color: "#2fc2b1"
                onClicked: gridButtons.buttonClicked("ae")
            }

            BigButton {
                text: "金融及高端设计"
                onClicked: gridButtons.buttonClicked("a2")
            }
            BigButton {
                text: "新能源新材料"
                onClicked: gridButtons.buttonClicked("a3")
            }
            BigButton {
                text: "新一代信息技术"
                onClicked: gridButtons.buttonClicked("a4")
            }
            BigButton {
                text: "生物医药"
                onClicked: gridButtons.buttonClicked("a5")
            }
            BigButton {
                text: "高端设备制造"
                onClicked: gridButtons.buttonClicked("a6")
            }
            BigButton {
                text: "餐饮区"
                onClicked: gridButtons.buttonClicked("a7")
            }
            BigButton {
                text: "人才公寓"
                onClicked: gridButtons.buttonClicked("a8")
            }
            BigButton {
                text: "商务居住"
                onClicked: gridButtons.buttonClicked("a9")
            }
            BigButton {
                text: "博士创业加速园"
                onClicked: gridButtons.buttonClicked("aa")
            }
            BigButton {
                text: "公共服务区"
                onClicked: gridButtons.buttonClicked("ab")
            }
            BigButton {
                text: "博士创业孵化园"
                onClicked: gridButtons.buttonClicked("ac")
            }
            BigButton {
                text: "环境灯光"
                onClicked: gridButtons.buttonClicked("ad")
            }
        }
    }
}
