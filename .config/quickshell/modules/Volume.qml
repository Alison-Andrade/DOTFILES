import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

Rectangle {
    id: root

    radius: 4
    color: Theme.backgroundColor

    property int padding: 4

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink?.audio.muted ?? false
    readonly property real volume: sink?.audio.volume ?? 0
    readonly property bool hovering: iconArea.containsMouse || sliderArea.containsMouse || sliderArea.pressed
    property bool expanded: false

    onHoveringChanged: {
        if (hovering) {
            colapseTimer.stop()
            root.expanded = true
        } else {
            colapseTimer.start()
        }
    }

    Timer {
        id: colapseTimer
        interval: 200
        onTriggered: root.expanded = false
    }


    implicitWidth: layout.implicitWidth + padding * 2
    implicitHeight: 24

    PwObjectTracker {
        objects: [root.sink]
    }

    function iconFor(vol, isMuted) {
        if (isMuted || vol === 0) return ""
        if (vol < 0.5) return ""
        return ""
    }

    RowLayout {
        id: layout
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8

        Item {
            id: sliderBox
            Layout.preferredHeight: 6
            Layout.preferredWidth: root.expanded ? 80 : 0
            clip: true

            Behavior on Layout.preferredWidth {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }

            Rectangle {
                id: track
                width: 80
                height: parent.height
                radius: height / 2
                color: Theme.hoverColor

                Rectangle {
                    width: track.width * root.volume
                    height: parent.height
                    radius: height / 2
                    color: Theme.foregroundColor
                }
            }

            MouseArea {
                id: sliderArea
                anchors.fill: parent
                hoverEnabled: true

                function setFromX(x) {
                    const ratio = Math.max(0, Math.min(1, x / 80))
                    if (root.sink?.ready && root.sink?.audio) {
                        root.sink.audio.volume = ratio
                    }
                }

                onPressed: (mouse) => setFromX(mouse.x)
                onPositionChanged: (mouse) => { if (pressed) setFromX(mouse.x) }
            }
        }

        Text {
            id: icon
            text: Math.trunc(root.sink.audio.volume * 100) + "% " + root.iconFor(root.volume, root.muted)
            color: "white"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize

            MouseArea {
                id: iconArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    if (root.sink?.ready && root.sink?.audio) {
                        root.sink.audio.muted = !root.sink.audio.muted
                    }
                }

                onWheel: (wheel) => {
                    if (!root.sink?.ready || !root.sink?.audio) return
                    const step = 0.05
                    const delta = wheel.angleDelta.y > 0 ? step : -step
                    root.sink.audio.volume = Math.max(0, Math.min(1, root.volume + delta))
                }
            }
        }
    }
}