//@ pragma UseQApplication

import "../theme"
import QtQuick
import QtQuick
import QtQuick.Layouts
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.SystemTray
import Quickshell.Wayland

Item {
    id: root

    property QtObject parentWindow

    implicitHeight: parent.height
    implicitWidth: row.implicitWidth

    RowLayout {
        id: row

        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        Repeater {
            model: SystemTray.items

            Item {
                id: item

                width: 18
                height: 18

                Image {
                    anchors.fill: parent
                    source: modelData.icon
                    fillMode: Image.PreserveAspectFit
                    enabled: false
                    smooth: true
                    mipmap: true
                }

                MouseArea {
                    acceptedButtons: Qt.AllButtons
                    cursorShape: Qt.PointingHandCursor
                    anchors.fill: parent
                    onClicked: (m) => {
                        const gloabalPos = item.mapToGlobal(0, 0);
                        if (m.button == Qt.RightButton)
                            modelData.display(parentWindow, gloabalPos.x, gloabalPos.y);
                        else
                            modelData.activate();
                    }
                }

            }

        }

    }

}
