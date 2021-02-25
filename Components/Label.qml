//contents of Label.qml
import QtQuick 2.12

Text {
    id: label
    text: "Option 1"
    horizontalAlignment: Text.horizontalCenter
    font.pixelSize: 26
    font.family: "roboto light"
    color: "#ffffff"
    antialiasing: true
    property alias size: label.font.pixelSize
}
