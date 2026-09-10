pragma Singleton
import QtQuick

QtObject {
    property color backgroundColor: "#181818"
    property color foregroundColor: "#ffffff"
    property color accentColor: "#3a3a4a"

    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 14
}