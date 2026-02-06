import "../theme"
// ~/.config/quickshell/widgets/Cava.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: root

    property int padding: 160
    property int bars: 24
    property var levels: Array(bars).fill(0)

    implicitHeight: parent.height
    implicitWidth: bars * 3 + (bars - 1) * 2 + padding

    Process {
        id: cavaProc

        command: ["sh", "-lc", "cava -p ~/.config/quickshell/cava.conf 2>/dev/null"]
        Component.onCompleted: running = true
        Component.onDestruction: running = false

        stdout: SplitParser {
            onRead: (data) => {
                if (!data)
                    return ;

                const parts = data.trim().split(";");
                const out = [];
                for (let i = 0; i < root.bars; i++) out.push(parseInt(parts[i] ?? "0") || 0)
                root.levels = out;
            }
        }

    }

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        spacing: padding

        RowLayout {
            id: row_left

            spacing: 2
            anchors.verticalCenter: parent.verticalCenter

            Repeater {
                model: root.bars / 2

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 3
                    radius: 2
                    height: (root.levels[index] * 0.25)
                    color: Theme.accentSecondary

                    Behavior on height {
                        NumberAnimation {
                            duration: 60
                        }

                    }

                }

            }

        }

        RowLayout {
            id: row_right

            spacing: 2
            anchors.verticalCenter: parent.verticalCenter

            Repeater {
                model: root.bars / 2

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 3
                    radius: 2
                    height: (root.levels[index + root.bars / 2 - 1] * 0.25)
                    color: Theme.accentSecondary

                    Behavior on height {
                        NumberAnimation {
                            duration: 60
                        }

                    }

                }

            }

        }

    }

}
