import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Rectangle {
    id: root

    radius: 4
    property int padding: 4
    color: Theme.backgroundColor

    implicitWidth: layout.implicitWidth + padding * 2
    implicitHeight: layout.implicitHeight + padding * 2

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 6

        Repeater {
            model: SystemTray.items

            delegate: Item {
                id: trayIcon
                required property SystemTrayItem modelData

                implicitWidth: 20
                implicitHeight: 20

                Image {
                    anchors.fill: parent
                    anchors.margins: 2
                    source: trayIcon.modelData.icon
                    sourceSize: Qt.size(16, 16)
                }

                QsMenuAnchor {
                    id: menuAnchor
                    menu: trayIcon.modelData.menu
                    anchor.item: trayIcon
                    anchor.edges: Edges.Bottom | Edges.Left
                    anchor.gravity: Edges.Bottom | Edges.Right
                }

                MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton)
                        trayIcon.modelData.activate()
                    else if (mouse.button === Qt.RightButton)
                        menuAnchor.open()
                    else if (mouse.button === Qt.MiddleButton)
                        trayIcon.modelData.secondaryActivate()
                }
            }
            }
        }
    }
}

