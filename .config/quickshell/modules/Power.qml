import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Rectangle {
    id: root

    radius: 4
    color: Theme.backgroundColor

    implicitWidth: layout.implicitWidth + 8
    implicitHeight: 28

    property PanelWindow barWindow

    property bool expanded: false
    readonly property bool hovering: powerArea.containsMouse 
                                || logoutArea.containsMouse
                                || lockArea.containsMouse
                                || suspendArea.containsMouse

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

    Process {
        id: sysCommand
    }

    function runCmd(cmd) {
        sysCommand.command = ["sh", "-c", cmd]
        sysCommand.running = true
    }

    PanelWindow {
        id: confirmWindow

        visible: false

        // Ocupa toda a área da tela
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        // Configuração de Camada e Foco no Wayland (Sintaxe Quickshell 3.x)
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        color: "transparent"

        // Força o foco visual no caixa assim que a janela abre
        onVisibleChanged: {
            if (visible) {
                dialogContent.forceActiveFocus()
            }
        }

        // Fundo invisível para fechar a caixa se clicar fora
        MouseArea {
            anchors.fill: parent
            onClicked: confirmWindow.visible = false
        }

        // Conteúdo da caixa de confirmação
        Rectangle {
            id: dialogContent

            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 0
            anchors.rightMargin: 12

            implicitWidth: 200
            implicitHeight: 90
            radius: 4
            color: Theme.backgroundColor
            border.color: "#313244"
            border.width: 1

            // Previne fechar ao clicar dentro da própria caixa
            MouseArea {
                anchors.fill: parent
            }

            focus: true

            // Tecla ESC fecha a janela
            Keys.onEscapePressed: confirmWindow.visible = false

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                Text {
                    text: "Desligar o sistema?"
                    color: Theme.foregroundColor
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    Layout.alignment: Qt.AlignHCenter
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 12

                    // Botão Confirmar
                    Rectangle {
                        implicitWidth: 70
                        implicitHeight: 28
                        radius: 4
                        color: confirmArea.containsMouse ? "#f38ba8" : "#313244"

                        Text {
                            text: "Sim"
                            color: confirmArea.containsMouse ? "#11111b" : "white"
                            anchors.centerIn: parent
                            font.bold: true
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSize
                        }

                        MouseArea {
                            id: confirmArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                confirmWindow.visible = false
                                root.runCmd("poweroff")
                            }
                        }
                    }

                    // Botão Cancelar
                    Rectangle {
                        implicitWidth: 70
                        implicitHeight: 28
                        radius: 4
                        color: cancelArea.containsMouse ? "#45475a" : "#313244"

                        Text {
                            text: "Não"
                            color: "white"
                            anchors.centerIn: parent
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSize
                        }

                        MouseArea {
                            id: cancelArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: confirmWindow.visible = false
                        }
                    }
                }
            }
        }
    }

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 4

        Rectangle {
            id: suspend
            implicitHeight: root.implicitHeight
            implicitWidth: root.expanded ? 28 : 0
            clip: true
            visible: implicitWidth > 0

            color: suspendArea.containsMouse ? Theme.hoverColor : "transparent"
            radius: 4

            Behavior on implicitWidth {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }

            Text {
                text: "󰤄"
                anchors.centerIn: parent
                font.pixelSize: Theme.fontSize
                font.family: Theme.fontFamily
                color: Theme.foregroundColor
            }

            MouseArea {
                id: suspendArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.runCmd("systemctl suspend")
            }
        }

        Rectangle {
            id: lock
            implicitHeight: root.implicitHeight
            implicitWidth: root.expanded ? 28 : 0
            clip: true
            visible: implicitWidth > 0

            color: lockArea.containsMouse ? Theme.hoverColor : "transparent"
            radius: 4

            Behavior on implicitWidth {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }

            Text {
                text: "󰌾"
                anchors.centerIn: parent
                font.pixelSize: Theme.fontSize
                font.family: Theme.fontFamily
                color: Theme.foregroundColor
            }

            MouseArea {
                id: lockArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor


                onClicked: root.runCmd("hyprlock")
            }
        }

        Rectangle {
            id: logout
            implicitHeight: root.implicitHeight
            implicitWidth: root.expanded ? 28 : 0
            clip: true
            visible: implicitWidth > 0

            color: logoutArea.containsMouse ? Theme.hoverColor : "transparent"
            radius: 4

            Behavior on implicitWidth {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }

            Text {
                text: "󰍃"
                anchors.centerIn: parent
                font.pixelSize: Theme.fontSize
                font.family: Theme.fontFamily
                color: Theme.foregroundColor
            }

            MouseArea {
                id: logoutArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: root.runCmd("hyprctl dispatch exit 0")
            }
        }

        Rectangle {
            id: poweroff
            implicitHeight: root.implicitHeight
            implicitWidth: 28

            color: powerArea.containsMouse ? Theme.hoverColor : "transparent"
            radius: 4

            Text {
                text: "⏻"
                anchors.centerIn: parent
                font.pixelSize: Theme.fontSize
                font.family: Theme.fontFamily
                color: Theme.foregroundColor
            }

            MouseArea {
                id: powerArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: confirmWindow.visible = !confirmWindow.visible
            }
        }
    }
}