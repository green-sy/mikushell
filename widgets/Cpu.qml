import "../theme"
// ~/.config/quickshell/widgets/Cpu.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: root

    property int cpuUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    implicitHeight: text.height
    implicitWidth: text.implicitWidth

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            if (!cpuProc.running)
                cpuProc.running = true;

        }
    }

    Process {
        id: cpuProc

        command: ["sh", "-c", "head -1 /proc/stat"]
        Component.onCompleted: running = true

        stdout: SplitParser {
            onRead: (data) => {
                if (!data)
                    return ;

                var p = data.trim().split(/\s+/);
                var idle = parseInt(p[4]) + parseInt(p[5]);
                var total = p.slice(1, 8).reduce((a, b) => {
                    return a + parseInt(b);
                }, 0);
                if (lastCpuTotal > 0)
                    cpuUsage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)));

                lastCpuTotal = total;
                lastCpuIdle = idle;
            }
        }

    }

    Text {
        id: text

        anchors.centerIn: parent
        text: "CPU: " + cpuUsage + "%"
        color: Theme.fg

        font {
            family: Theme.fontFamily
            pixelSize: Theme.fontSize
        }

    }

}
