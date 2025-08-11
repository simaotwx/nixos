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

            implicitHeight: 48  // Increased by 2px more
            color: "transparent"

            Rectangle {
                anchors.fill: parent
                anchors.margins: 6  // Margin around the bar for the pill shape
                color: "#20000000"
                radius: height / 2  // Perfect pill shape

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8  // Back to 8px since bar is bigger
                    spacing: 8

                    // Clock pill
                    Rectangle {
                        Layout.alignment: Qt.AlignVCenter
                        implicitWidth: clockText.implicitWidth + 20  // Increased from 16 to 20 (2px on each side)
                        implicitHeight: 28  // Increased height for better proportions
                        color: "#40000000"
                        radius: height / 2

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

                    // Power controls on the right
                    PowerMenuWidget {}
                }
            }
        }
    }
}