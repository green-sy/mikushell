import "../theme"
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    default property alias contentData: content.data
    property bool outlined: false
    property bool active: false
    property bool filled: false

    implicitWidth: content.implicitWidth + Theme.pad * 2
    implicitHeight: Theme.barHeight

    Rectangle {
        anchors.fill: parent
        color: filled ? Qt.rgba(Theme.bg.r, Theme.bg.g, Theme.bg.b, 0.55) : "transparent"
        border.width: outlined ? Theme.stroke : 0
        border.color: Theme.line
    }

    // active indicator: 2px underline (no glow, no rounding)
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: root.active ? 2 : 0
        color: Theme.accent
    }

    RowLayout {
        id: content

        anchors.fill: parent
        anchors.margins: Theme.pad
        spacing: Theme.gap
    }

}
