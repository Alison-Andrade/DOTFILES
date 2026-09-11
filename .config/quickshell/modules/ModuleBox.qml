import QtQuick

Rectangle {
    id: root

    default property alias content: contentItem.data
    property int padding: 8

    radius: 4
    color: hoverArea.containsMouse ? Theme.hoverColor : Theme.backgroundColor

    implicitWidth: contentItem.childrenRect.width + padding
    implicitHeight: contentItem.childrenRect.height + padding

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    Item {
        id: contentItem
        anchors.centerIn: parent
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true

        cursorShape: Qt.PointingHandCursor
    }
}