import Quickshell
import QtQuick
import "."

Text {
    id: root

    property string format: "hh:mm"

    color: "white"
    font.pixelSize: Theme.fontSize
    font.family: Theme.fontFamily
    text: " " + Qt.formatTime(clock.date, root.format)

    SystemClock {
        id: clock
        
        precision: SystemClock.Minutes
    }
}