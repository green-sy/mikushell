// ~/.config/quickshell/widgets/Workspaces.qml
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "../theme"

Item {
    id: root
    implicitHeight: parent.height
    implicitWidth: row.implicitWidth

    Row {
        id: row
        spacing: 8
        anchors.verticalCenter: parent.verticalCenter
        Repeater {
            model: 5
            Chip{
                property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1) != undefined
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

                active: isActive
                enabled: ws

                text: index + 1
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                }
  
            }
        } 
     }
}