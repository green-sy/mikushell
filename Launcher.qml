// ~/.config/quickshell/launcher/Launcher.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "theme"
import "widgets"

PanelWindow {
    id: win

    property string query: ""

    function norm(s) {
        if (!s)
            return "";

        return String(s).toLowerCase();
    }

    function matches(name) {
        if (query.trim().length === 0)
            return true;

        return norm(name).indexOf(norm(query.trim())) !== -1;
    }

    function runApp(app) {
        launcherProc.command = ["sh", "-c", "gtk-launch '" + app.id + "' || " + app.tryExec + " >/dev/null 2>&1 & disown"];
        launcherProc.running = true;
        Qt.quit();
    }

    visible: true
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.focusable: true
    anchors.top: true
    anchors.left: true
    anchors.right: true
    anchors.bottom: true
    color: "transparent"
    Component.onCompleted: input.forceActiveFocus()

    ListModel {
        id: apps
    }

    Process {
        id: launcherProc
    }

    Process {
        id: loadApps

        command: ["python3", Qt.resolvedUrl("scripts/list_apps.py").toString().replace("file://", "")]
        Component.onCompleted: running = true

        stdout: SplitParser {
            onRead: (data) => {
                if (!data)
                    return ;

                const line = data.trim();
                if (!line)
                    return ;

                const parts = line.split("\t");
                if (parts.length < 2)
                    return ;

                const app = {
                    "id": parts[0],
                    "name": parts[1],
                    "category": parts[2],
                    "comment": parts[3],
                    "exec": parts[4],
                    "tryExec": parts[5],
                    "path": parts[6],
                    "icon": parts[7] ?? "",
                    "terminal": parts[8]
                };
                if (app.name == "Advanced Network Configuration")
                    console.log(app.icon);

                apps.append(app);
            }
        }

    }

    // ---- UI ----
    Rectangle {
        anchors.fill: parent
        color: "transparent"

        MouseArea {
            anchors.fill: parent
            onClicked: Qt.quit()
        }

    }

    Item {
        id: box

        width: Math.min(parent.width * 0.55, 720)
        height: Math.min(parent.height * 0.6, 520)
        anchors.centerIn: parent

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.85)
            border.width: 1
            border.color: Qt.rgba(1, 1, 1, 0.12)
        }

        ColumnLayout {
            anchors.fill: parent

            TextField {
                id: input

                color: Theme.fg
                Layout.fillWidth: true
                placeholderText: "Type to search…"
                focus: true
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                onTextChanged: win.query = text
                Keys.onEscapePressed: Qt.quit()
                Keys.onReturnPressed: {
                    for (let i = 0; i < apps.count; i++) {
                        const it = apps.get(i);
                        if (win.matches(it.name)) {
                            win.runApp(it);
                            return ;
                        }
                    }
                }

                background: Rectangle {
                    color: "transparent"
                }

            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: input.activeFocus ? Qt.rgba(1, 1, 1, 0.36) : Qt.rgba(1, 1, 1, 0.12)
            }

            ListView {
                id: list

                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: apps

                delegate: Item {
                    width: list.width
                    height: win.matches(model.name) ? 34 : 0
                    visible: win.matches(model.name)

                    Chip {
                        anchors.fill: parent
                        active: ma.containsMouse
                        anchors.margins: 6

                        RowLayout {
                            spacing: 8

                            Item {
                                id: icon

                                width: 14
                                height: 14

                                Image {
                                    id: image

                                    property bool failed: false

                                    function normalizeIcon(name) {
                                        if (!name)
                                            return "application-x-executable";

                                        if (name === "network-wired")
                                            return "nm-device-wired";

                                        if (name === "utilities-terminal")
                                            return "terminal";

                                        return name;
                                    }

                                    onStatusChanged: {
                                        if (image.status == Image.Error) {
                                            console.log("==========Error==========:", status);
                                            failed = true;
                                        }
                                    }
                                    anchors.fill: parent
                                    source: failed ? Qt.resolvedUrl("assets/fallback.svg") : ("image://icon/" + normalizeIcon(model.icon))
                                    fillMode: Image.PreserveAspectFit
                                    enabled: false
                                    smooth: true
                                    mipmap: true
                                }

                            }

                            Text {
                                Layout.fillWidth: true
                                text: model.name
                                color: Theme.fg
                                elide: Text.ElideRight
                                width: parent.width
                            }

                        }

                    }

                    MouseArea {
                        id: ma

                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            win.runApp(model);
                        }
                    }

                }

            }

        }

    }

}
