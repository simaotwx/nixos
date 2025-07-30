pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property string time: {
        Qt.formatDateTime(clock.date, "HH:mm  dd")
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}