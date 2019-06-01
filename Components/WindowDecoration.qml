import QtQuick 2.9
import "./"


Rectangle {
    x: 0
    y: 0
    width: parent.width
    height: 25
    color: "transparent"

    property var win: Object
    property string detail: "#ffffff"

    Rectangle {
        anchors.fill: parent
        color: "#000"
        opacity: 0.5
    }

    MouseArea {
        id: geral
        anchors.fill: parent
        hoverEnabled: true

        onHoveredChanged: {
            decoration.opacity = 1.0
        }

        onExited: {
            decoration.opacity = 0.0
        }
    }

    Label {
        id: btnMin
        x: btnMax.x - width - 15
        y: btnMax.y - 2
        text: "\uf2d1"
        font.family: "Font Awesome 5 Free"
        size: 10
        opacity: 0.8
        color: "#ffffff"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onHoveredChanged: {
                decoration.opacity = 1.0
                btnMin.color = detail
            }

            onExited: {
                btnMin.color = "#ffffff"
            }

            onClicked: {
                win.showMinimized()
            }
        }
    }

    Label {
        id: btnClose
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 8
        text: "\uf00d" //"\uf410"
        font.family: "Font Awesome 5 Free"
        size: 12
        opacity: 0.8
        color: "#ffffff"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onHoveredChanged: {
                decoration.opacity = 1.0
                btnClose.color = detail
            }

            onExited: {
                btnClose.color = "#ffffff"
            }

            onClicked: {
                win.close()
            }
        }
    }

    Label {
        id: btnMax
        x: btnClose.x - width - 15
        y: btnClose.y + 2
        text: "\uf2d0"
        font.family: "Font Awesome 5 Free"
        size: 10
        opacity: 0.8
        color: "#ffffff"

        MouseArea {
            anchors.fill: parent
            property bool maximezed: true
            hoverEnabled: true

            onHoveredChanged: {
                decoration.opacity = 1.0
                btnMax.color = detail
            }

            onExited: {
                btnMax.color = "#ffffff"
            }

            onClicked: {
                if (maximezed) {
                    win.showMaximized()
                } else {
                    win.showNormal()
                }
                maximezed = !maximezed
            }
        }
    }
}
