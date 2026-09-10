import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "."

Rectangle {

    id: rect

    radius: 4
    color: "#181818"

    implicitHeight: root.implicitHeight + 2
    implicitWidth: root.implicitWidth + 6

    property HyprlandMonitor monitor

    RowLayout {
        id: root
        spacing: 1

        function getWorkspaces() {
            if (!rect.monitor) return []

            let list = []
            for (let ws of Hyprland.workspaces.values) {
                if (ws.monitor === rect.monitor) {
                    list.push(ws)
                }
            }

            return list.sort((a, b) => a.id - b.id)
        }

        property var workspaceList: getWorkspaces()

        Connections {
            target: Hyprland.workspaces
            function onObjectAdded() { root.workspaceList = root.getWorkspaces() }
            function onObjectRemoved() { root.workspaceList = root.getWorkspaces() }
        }

        Repeater {
            model: root.workspaceList

            delegate: Rectangle {
                id: wsButton

                required property var modelData

                readonly property bool isFocused: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id === modelData.id : false

                implicitWidth: 36
                implicitHeight: 26
                radius: 4

                color: hoverArea.containsMouse ? "#3a3a4a" : "transparent"

                border.color: isFocused ? "white" : "transparent"
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
                    color: "white"
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