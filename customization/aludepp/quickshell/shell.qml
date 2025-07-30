import QtQuick
import QtQuick.Layouts
import Quickshell

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panel

            property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            color: "transparent"

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 4
                color: "#20000000"
                radius: 9999
                implicitHeight: 32

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 2
                    spacing: 8

                    // Clock pill
                    Rectangle {
                        Layout.alignment: Qt.AlignVCenter
                        implicitWidth: clockText.implicitWidth + 16
                        implicitHeight: 24
                        color: "#40000000"
                        radius: 9999

                        Text {
                            id: clockText
                            anchors.centerIn: parent
                            text: Time.time
                            color: "#B8FFFFFF"
                            font.pixelSize: 14
                            font.weight: Font.DemiBold
                        }
                    }

                    // Spacer to push other items to the right
                    Item {
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}