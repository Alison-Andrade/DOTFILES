import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "."

Rectangle {

    id: rect

    radius: 4
    color: Theme.backgroundColor

    implicitHeight: root.implicitHeight + 2
    implicitWidth: root.implicitWidth + 6

    property HyprlandMonitor monitor

    RowLayout {
        id: root
        spacing: 1

        anchors.centerIn: parent

        function getWorkspaces() {
            if (!rect.monitor) return []

            return Hyprland.workspaces.values
                .filter(ws => ws.monitor === rect.monitor)
                .sort((a, b) => a.id - b.id)
        }

        property var workspaceList: getWorkspaces()

        Repeater {
            model: root.workspaceList

            delegate: Rectangle {
                id: wsButton

                required property var modelData

                readonly property bool isFocused: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id === modelData.id : false

                implicitWidth: 36
                implicitHeight: 26
                radius: 4

                color: hoverArea.containsMouse ? Theme.hoverColor : "transparent"

                border.color: isFocused ? Theme.foregroundColor : "transparent"
                border.width: isFocused ? 2 : 0
                
                Behavior on color {
                    ColorAnimation { duration: 150 }
                }

                Behavior on border.color {
                    ColorAnimation { duration: 150 }
                }

                Text {
                    anchors.centerIn: parent
                    text: wsButton.modelData.id.toString()
                    color: Theme.foregroundColor
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    font.bold: true
                }

                MouseArea {
                    id: hoverArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: wsButton.modelData.activate()
                    
                    hoverEnabled: true
                }
            }
        }
    }
}