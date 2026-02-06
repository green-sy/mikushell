import "../theme"
// ~/.config/quickshell/widgets/Keyboard.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: root

    implicitHeight: parent.height
    implicitWidth: kbLabel.implicitWidth

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            if (!kbProc.running)
                kbProc.running = true;

        }
    }

    Process {
        id: kbProc

        command: ["sh", "-c", "hyprctl devices -j | jq -r '.keyboards[] | select(.main==true) | (.layout | split(\", \"))[.active_layout_index]'"]

        stdout: SplitParser {
            onRead: (data) => {
                if (!data)
                    return ;

                kbLabel.text = data.trim();
            }
        }

    }

    Text {
        id: kbLabel

        anchors.verticalCenter: parent.verticalCenter
        color: Theme.fg

        font {
            family: Theme.fontFamily
            pixelSize: Theme.fontSize
            bold: true
            capitalization: Font.AllUppercase
        }

    }

}
