import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    property alias label: labelComp.text
    property alias value: valueComp.text

    anchors.left: parent.left
    anchors.right: parent.right
    height: valueComp.height

    Label {
        id: labelComp
        text: "<missing label binding>"
        color: Theme.secondaryHighlightColor
        font.pixelSize: Theme.fontSizeTiny
        anchors.left: parent.left
        anchors.right: parent.right
    }
    Label {
        id: valueComp
        text: "<missing value binding>"
        font.pixelSize: Theme.fontSizeExtraSmall
        horizontalAlignment: Text.AlignRight
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
