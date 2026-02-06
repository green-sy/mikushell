import "../theme"
import QtQuick

Text {
    id: root

    property bool enabled: true
    property bool active: false
    //Unused sof far
    property bool hovered: false
    property string label: "1"

    font.weight: active ? Font.DemiBold : Font.Normal
    text: label
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
    color: enabled ? Theme.fg : Theme.muted
}
