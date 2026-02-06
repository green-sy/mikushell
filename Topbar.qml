//@ pragma UseQApplication

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import "theme"
import "widgets"

PanelWindow {
    id: root

    required property var modelData
    property QtObject shellRoot

    anchors.top: true
    anchors.left: true
    anchors.right: true
    exclusiveZone: ExclusiveZone.Normal
    implicitHeight: Theme.barHeight + Theme.pad / 2
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.16)
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: Qt.rgba(1, 1, 1, 0.12)
    }

    RowLayout {
        anchors {
            fill: parent
        }

        Pill {
            Layout.alignment: Qt.AlignVCenter

            RowLayout {
                anchors.centerIn: parent

                Cpu {
                }

                Separator {
                }

                Memory {
                }

            }

        }

        Item {
            Layout.fillWidth: true
        }

        Pill {
            Layout.alignment: Qt.AlignVCenter

            Workspaces {
            }

        }

        Item {
            Layout.fillWidth: true
        }

        Pill {
            Tray {
                parentWindow: root
            }

        }

        Pill {
            Clock {
            }

        }

        Pill {
            Keyboard {
            }

        }

    }

}
