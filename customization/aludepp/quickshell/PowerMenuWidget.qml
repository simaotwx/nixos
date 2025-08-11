import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
RowLayout {
    id: root
    property bool showPowerMenu: false
    spacing: 4
    // Power options (hidden by default)
    RowLayout {
        Layout.alignment: Qt.AlignVCenter
        spacing: 4
        visible: root.showPowerMenu
        // Reboot
        Rectangle {
            width: 32
            height: 32
            color: "#4CAF50" // Green
            radius: 16
            Text {
                anchors.centerIn: parent
                text: "↻"
                color: "white"
                font.pixelSize: 16
                font.weight: Font.Bold
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: rebootProcess.running = true
                onEntered: parent.color = Qt.lighter(parent.color, 1.2)
                onExited: parent.color = "#4CAF50"
            }
            Process {
                id: rebootProcess
                command: ["systemctl", "reboot"]
            }
        }
        // Logout
        Rectangle {
            width: 32  // Back to 32 since bar is bigger
            height: 32  // Back to 32 since bar is bigger
            color: "#FFC107" // Amber
            radius: 16  // Adjusted for size
            Text {
                anchors.centerIn: parent
                text: "⏻"
                color: "white"
                font.pixelSize: 14
                font.weight: Font.Bold
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: logoutProcess.running = true
                onEntered: parent.color = Qt.lighter(parent.color, 1.2)
                onExited: parent.color = "#FFC107"
            }
            Process {
                id: logoutProcess
                command: ["hyprctl", "dispatch", "exit"]
            }
        }
        // Power off
        Rectangle {
            width: 32  // Back to 32 since bar is bigger
            height: 32  // Back to 32 since bar is bigger
            color: "#F44336" // Red
            radius: 16  // Adjusted for size
            Text {
                anchors.centerIn: parent
                text: "⏼"
                color: "white"
                font.pixelSize: 16
                font.weight: Font.Bold
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: poweroffProcess.running = true
                onEntered: parent.color = Qt.lighter(parent.color, 1.2)
                onExited: parent.color = "#F44336"
            }
            Process {
                id: poweroffProcess
                command: ["systemctl", "poweroff"]
            }
        }
    }
    // Main power button
    Rectangle {
        width: 32  // Back to 32 since bar is bigger
        height: 32  // Back to 32 since bar is bigger
        color: "white"
        radius: 16  // Adjusted for size
        Text {
            anchors.centerIn: parent
            text: "⚙"
            color: "black"
            font.pixelSize: 16
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.showPowerMenu = !root.showPowerMenu
            onEntered: parent.color = "#E0E0E0"
            onExited: parent.color = "white"
        }
    }
}