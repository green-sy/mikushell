import QtMultimedia
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    // Image {
    //     anchors.fill: parent
    //     source: "/home/greensy/Pictures/Wallpapers/miku-dj.jpg"
    //     fillMode: Image.PreserveAspectCrop
    //     smooth: true
    //     mipmap: true
    // }

    WlrLayershell.layer: WlrLayer.Background
    exclusiveZone: ExclusionMode.Auto
    anchors.top: true
    anchors.left: true
    anchors.right: true
    anchors.bottom: true
    focusable: false

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        hoverEnabled: false
    }

    Video {
        id: loopVideo

        anchors.fill: parent
        source: "file://home/greensy/.config/quickshell/assets/hatsune-miku_room.mp4"
        autoPlay: true
        loops: MediaPlayer.Infinite
        fillMode: VideoOutput.PreserveAspectCrop
        muted: true
    }

}
