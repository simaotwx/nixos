import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

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

            margins {
                top: 4
                left: 4
                right: 4
            }

            implicitHeight: 34
            color: "transparent"

            WrapperRectangle {
                anchors.fill: parent
                color: "#20000000"
                radius: height / 2

                // Only add horizontal margins
                leftMargin: 1
                rightMargin: 1
                topMargin: 1
                bottomMargin: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 4
                    anchors.rightMargin: 8
                    spacing: 8

                    // Clock pill
                    Rectangle {
                        Layout.alignment: Qt.AlignVCenter
                        implicitWidth: clockText.implicitWidth + 20
                        implicitHeight: 32
                        color: "#40000000"
                        radius: height / 2

                        Text {
                            id: clockText
                            anchors.centerIn: parent
                            text: Time.time
                            color: "#B8FFFFFF"
                            font.pixelSize: 14
                            font.weight: 600
                        }
                    }

                    // Spacer to push other items to the right
                    Item {
                        Layout.fillWidth: true
                    }

                    // Power controls on the right
                    PowerMenuWidget {}
                }
            }
        }
    }
}