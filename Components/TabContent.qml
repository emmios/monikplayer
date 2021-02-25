import QtQuick 2.12

Rectangle {
    x: 0
    y: 60
    z: tabs.titles.length - index
    width: parent.width
    height: parent.height - y
    color: "#00000000"
    visible: (index == 0) ? true : false
    //Label {text: "Option - " + index}
}
