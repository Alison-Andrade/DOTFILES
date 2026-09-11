//@ pragma UseQApplication
//@ pragma RespectSystemStyle
//@ pragma IconTheme Vimix-black

import Quickshell
import QtQuick
import QtQuick.Layouts
import "./modules" as Modules

ShellRoot {
    Variants {
        model: Quickshell.screens

        delegate: Component {
            Modules.Bar {}
        }
    }
}