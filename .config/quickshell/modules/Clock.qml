import Quickshell
import QtQuick
import "."

Text {
    id: root

    property string format: "hh:mm"

    color: Theme.foregroundColor
    font.pixelSize: Theme.fontSize
    font.family: Theme.fontFamily
    font.weight: Font.Bold
    text: " " + Qt.formatTime(clock.date, root.format)

    SystemClock {
        id: clock
        
        precision: SystemClock.Minutes
    }
}