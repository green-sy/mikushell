import "../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: root

    implicitHeight: parent.height
    implicitWidth: clock.implicitWidth

    Text {
        id: clock

        anchors.verticalCenter: parent.verticalCenter
        color: Theme.fg
        text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")

        font {
            family: Theme.fontFamily
            pixelSize: Theme.fontSize
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
        }

    }

}
