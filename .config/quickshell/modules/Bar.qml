import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "." as Modules

PanelWindow {
    id: window

    readonly property HyprlandMonitor hyprMonitor: Hyprland.monitorFor(window.screen)

    required property var modelData
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 32
    color: "transparent"

    RowLayout {

        // Widgets centro

        anchors.centerIn: parent
        spacing: 8

        Modules.ModuleBox {

            Modules.Clock {
                anchors.centerIn: parent
            }
            
        }
    }

    RowLayout {

        // Widgets na direita

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 8
        spacing: 8

        Modules.Volume {}
        
        Modules.Tray {}
    }

    RowLayout {

        // Widgets na esquerda

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 8
        spacing: 8

        Modules.Workspaces {
            monitor: window.hyprMonitor
        }
    }

}