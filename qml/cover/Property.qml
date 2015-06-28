import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    property alias label: labelComp.text
    property alias value: valueComp.text

    //anchors.leftMargin: Theme.paddingSmall
    //anchors.rightMargin: Theme.paddingSmall
    anchors.left: parent.left
    anchors.right: parent.right
    //anchors.fill: parent
    //anchors.onLeftChanged:
    height: valueComp.height

//    x: Theme.paddingSmall
//    width: parent.width - Theme.paddingSmall * 2
//    spacing: 0
//    anchors.horizontalCenter: parent.horizontalCenter
    Label {
        id: labelComp
        text: "<missing label binding>"
        //width: parent.width
        color: Theme.secondaryHighlightColor
        font.pixelSize: Theme.fontSizeTiny
        anchors.left: parent.left
        anchors.right: parent.right
    }
    Label {
        id: valueComp
        text: "<missing value binding>"
        //width: parent.width
        font.pixelSize: Theme.fontSizeExtraSmall
//        anchors.right: parent.right
        horizontalAlignment: Text.AlignRight
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
