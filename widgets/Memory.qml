import "../theme"
// ~/.config/quickshell/widgets/Memory.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: root

    property int memUsage: 0

    implicitHeight: text.height
    implicitWidth: text.implicitWidth

    Process {
        id: memProc

        command: ["sh", "-c", "free | grep Mem"]
        Component.onCompleted: running = true

        stdout: SplitParser {
            onRead: (data) => {
                if (!data)
                    return ;

                var parts = data.trim().split(/\s+/);
                var total = parseInt(parts[1]) || 1;
                var used = parseInt(parts[2]) || 0;
                memUsage = Math.round(100 * used / total);
            }
        }

    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            if (!memProc.running)
                memProc.running = true;

        }
    }

    Text {
        id: text

        anchors.verticalCenter: parent.verticalCenter
        text: "Mem: " + memUsage + "%"
        color: Theme.fg

        font {
            family: Theme.fontFamily
            pixelSize: Theme.fontSize
        }

    }

}
