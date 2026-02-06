import QtQuick
pragma Singleton

QtObject {
    // 0 = fully transparent bar
    // optional separators

    // base
    readonly property color bg: "#0b0f11"
    // only used if you want solid bar
    readonly property real barAlpha: 0.12
    // text
    readonly property color fg: "#d6dde3"
    readonly property color muted: "#9aa5ad"
    // lines
    readonly property color line: "#2a343a"
    // hairline borders
    readonly property color lineSoft: "#1c252a"
    // accent (Miku cyan)
    readonly property color accent: "#017783"
    // layout
    readonly property int barHeight: 22
    readonly property int pad: 10
    readonly property int gap: 10
    readonly property int stroke: 1
    // typography
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 13
}
