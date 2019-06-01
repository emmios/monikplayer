import QtQuick 2.9
import QtQuick.Controls 2.2
import QtMultimedia 5.9
import QtGraphicalEffects 1.0
import "Components"


AppCustom {
    id: main
    visible: true
    x: 100
    y: 100
    width: 800
    height: 450//490
    title: qsTr("Synth-Player")
    color: "#00000000"
    flags: Qt.FramelessWindowHint

    property string detail: "#007fff"
    property string media: "file://" + Context.uri() 

    MouseArea {
        id: mouseMain
        property int startX: 0
        property int startY: 0
        property bool fullscreen: true

        anchors.fill: parent

        onDoubleClicked: {

            if (fullscreen) {
                main.showFullScreen();
                output.anchors.topMargin = 0
                output.anchors.bottomMargin = 0
                bg.anchors.topMargin = 0
                bg.anchors.bottomMargin = 0
                fullscreen = false
                decoration.visible = false
            } else {
                main.showNormal();
                output.anchors.topMargin = 0//25
                output.anchors.bottomMargin = 0
                bg.anchors.topMargin = 0//25
                bg.anchors.bottomMargin = 0
                fullscreen = true
                decoration.visible = true
            }
        }

        onPressed: {
            startX = mouseX
            startY = mouseY
        }

        onMouseXChanged: {
            main.x = Context.mouseX() - startX
            main.y = Context.mouseY() - startY
        }
    }

    Rectangle {
        id: bgWindow
        x: 0
        y: 0
        anchors.fill: parent
        color: "#000"
        opacity: 0.5
    }

    Rectangle {
        id: bg
        x: 0
        y: 0
        anchors.fill: parent
        anchors.topMargin: 0//25
        anchors.bottomMargin: 0
        color: "#000000"
    }

    VideoOutput {
        id: output
        x: 0
        y: 0
        anchors.fill: parent
        anchors.topMargin: 0//25
        anchors.bottomMargin: 0
        source: mediaPlayer

        MediaPlayer {
            id: mediaPlayer
            source: media
            autoLoad: true
            loops: Context.loop() === 0 ? 0 : Audio.Infinite
            autoPlay: true
            volume: 0.5

            onStatusChanged: {
                if (status == MediaPlayer.EndOfMedia || status == MediaPlayer.Stopped) {
                    seek(0)
                    pause()
                    btn.text = "\uf144"
                    progress.atual = 0
                    btn.paused = false
                    animation1.to = 0.4
                    animation1.stop()
                    animation1.start()
                    animation2.to = 0.8
                    animation2.stop()
                    animation2.start()
                    animation3.to = 0.8
                    animation3.stop()
                    animation3.start()
                }
            }

            onPositionChanged: {
                progress.atual = position

                var seconds = parseInt((position % 60000) / 1000)
                var minutes = parseInt(((position / 1000) / 60) % 60)
                var hours = parseInt(parseInt((position / 1000) / 60) / 60)

                if (seconds < 10) seconds = '0' + seconds
                if (minutes < 10) minutes = '0' + minutes
                if (hours < 10) hours = '0' + hours

                timeLeft.text = hours + ':' + minutes + ':' + seconds
            }

            onDurationChanged: {
                var _seconds = parseInt((duration % 60000) / 1000)
                var _minutes = parseInt(((duration / 1000) / 60) % 60)
                var _hours = parseInt(parseInt((duration / 1000) / 60) / 60)

                if (_seconds < 10) _seconds = '0' + _seconds
                if (_minutes < 10) _minutes = '0' + _minutes
                if (_hours < 10) _hours = '0' + _hours

                timeRight.text = _hours + ':' + _minutes + ':' + _seconds
            }
        }

//        Image {
//            id: frame
//            x: 0
//            y: 329
//            width: 101
//            height: 71
//            source: "qrc:/qtquickplugin/images/template_image.png"

//            MouseArea {
//                anchors.leftMargin: -7
//                anchors.bottomMargin: -7
//                anchors.fill: parent
//                onClicked: {

//                    output.grabToImage(function(image) {
//                        //console.log("Called...", arguments)
//                        frame.source = image.url
//                        //image.saveToFile("/home/shenoisz/Documents/estudos/QT-creator/build-QmlPlayer2-Qt_5_3_2_qt5-Release/screen.png"); // save happens here
//                    })

//                    /*
//                    output.grabToImage(function(image) {
//                        console.log("Called...", arguments)
//                        image.saveToFile("/home/shenoisz/Documents/estudos/QT-creator/build-QmlPlayer2-Qt_5_3_2_qt5-Release/screen.png"); // save happens here
//                    })*/
//               }
//            }
//        }
    }

    Rectangle {
        id: btnDestak
        anchors.fill: parent
        color: "#000000"
        opacity: 0.0
    }

    Rectangle {
        id: bottomDeskt
        width: main.width
        height: main.height / 4
        y: main.height - (main.height / 4)
        color: "transparent"

        PropertyAnimation {id: animation1; target: btn; property: "opacity"; to: 0.4; duration: 500}
        PropertyAnimation {id: animation2; target: btnDestak; property: "opacity"; to: 0.8; duration: 500}
        PropertyAnimation {id: animation3; target: progress; property: "opacity"; to: 0.8; duration: 500}
        PropertyAnimation {id: animation4; target: preview; property: "opacity"; to: 1; duration: 500}
        PropertyAnimation {id: animation5; target: timeLeft; property: "opacity"; to: 1; duration: 500}
        PropertyAnimation {id: animation6; target: timeRight; property: "opacity"; to: 1; duration: 500}
        PropertyAnimation {id: animation7; target: controller; property: "opacity"; to: 1; duration: 500}
        PropertyAnimation {id: animation8; target: loop; property: "opacity"; to: 1; duration: 500}

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onHoveredChanged: {
                animation1.to = 0.4
                animation1.stop()
                animation1.start()
                animation2.to = 0.8
                animation2.stop()
                animation2.start()
                animation3.to = 0.8
                animation3.stop()
                animation3.start()
                animation5.to = 1
                animation5.stop()
                animation5.start()
                animation6.to = 1
                animation6.stop()
                animation6.start()
                animation7.to = 1
                animation7.stop()
                animation7.start()
                animation8.to = 1
                animation8.stop()
                animation8.start()
            }

            onExited: {
                animation1.to = 0.0
                animation1.stop()
                animation1.start()
                animation2.to = 0.0
                animation2.stop()
                animation2.start()
                animation3.to = 0.0
                animation3.stop()
                animation3.start()
                animation4.to = 0.0
                animation4.stop()
                animation4.start()
                animation5.to = 0
                animation5.stop()
                animation5.start()
                animation6.to = 0
                animation6.stop()
                animation6.start()
                animation7.to = 0
                animation7.stop()
                animation7.start()
                animation8.to = 0
                animation8.stop()
                animation8.start()
            }
        }
    }

    Label {
        id: btn
        x: (main.width / 2) - (width / 2)
        y: (main.height / 2) - (height / 2)
        text: "\uf28b"
        size: main.width / 3
        font.family: "Font Awesome 5 Free"
        opacity: 0.0

        property bool paused: true

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {

                if (parent.paused) {
                    parent.text = "\uf144"
                    mediaPlayer.pause()

                } else {
                    parent.text = "\uf28b"
                    mediaPlayer.play()
                }

                parent.paused = !parent.paused
            }

            onHoveredChanged: {
                animation1.to = 0.4
                animation1.stop()
                animation1.start()
                animation2.to = 0.8
                animation2.stop()
                animation2.start()
                animation3.to = 0.8
                animation3.stop()
                animation3.start()
                animation5.to = 1
                animation5.stop()
                animation5.start()
                animation6.to = 1
                animation6.stop()
                animation6.start()
                animation7.to = 1
                animation7.stop()
                animation7.start()
                animation8.to = 1
                animation8.stop()
                animation8.start()
            }

            onExited: {
                animation1.to = 0.0
                animation1.stop()
                animation1.start()
                animation2.to = 0.0
                animation2.stop()
                animation2.start()
                animation3.to = 0.0
                animation3.stop()
                animation3.start()
                animation5.to = 0.0
                animation5.stop()
                animation5.start()
                animation6.to = 0.0
                animation6.stop()
                animation6.start()
                animation7.to = 0
                animation7.stop()
                animation7.start()
                animation8.to = 0
                animation8.stop()
                animation8.start()
            }
        }
    }

    Rectangle {
        id: preview
        x: 0
        y: 0
        width: main.width / 6 + 20
        height: width - 60
        opacity: 0.0
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: "#fff"
            opacity: 0.3
        }

        VideoOutput {
            anchors.fill: parent
            anchors.margins: 1
            source: mediaPlayerPreview
            MediaPlayer {
                id: mediaPlayerPreview
                source: media
                autoLoad: true
                //loops: Audio.Infinite
                autoPlay: false
                volume: 0.0
            }
        }
    }

    ProgressBar {
        id: progress
        x: 80
        y: main.height - (main.height / 6)
        width: main.width - 160
        height: 6
        max: mediaPlayer.duration
        opacity: 0.0
        detail: detail

        onClick: {
            mediaPlayer.seek(atual)
        }

        onHover: {
            mediaPlayerPreview.seek(value)
            mediaPlayerPreview.play()
            mediaPlayerPreview.pause()
            preview.x = (x + mousex) - (preview.width / 2)
            preview.y = y - (preview.height + 10)

            animation4.to = 1
            animation4.stop()
            animation4.start()

            animation1.to = 0.4
            animation1.stop()
            animation1.start()
            animation2.to = 0.8
            animation2.stop()
            animation2.start()
            animation3.to = 0.8
            animation3.stop()
            animation3.start()
            animation5.to = 1
            animation5.stop()
            animation5.start()
            animation6.to = 1
            animation6.stop()
            animation6.start()
            animation7.to = 1
            animation7.stop()
            animation7.start()

        }

//        onMove: {
//            mediaPlayerPreview.seek(value)
//            mediaPlayerPreview.play()
//            mediaPlayerPreview.pause()
//        }
    }

    Label {
        id: timeLeft
        x: progress.x - width - 8
        y: progress.y - 4
        text: "00:00:00"
        size: 12
        opacity: 0.0
    }

    Label {
        id: timeRight
        x: progress.width + width + 34
        y: progress.y - 4
        text: "00:00:00"
        size: 12
        opacity: 0.0
    }

    Controller {
        id: controller
        x: (timeRight.x + timeRight.width) - width
        y: timeRight.y + 40
        position: Context.volume()
        opacity: 0
        bg.opacity: 0.5
        detail: detail

        onChange: {
            var valor = (value * 1) / 100
            mediaPlayer.volume = valor
            Context.volume(value)
        }
    }

    Label {
        id: loop
        x: progress.x - timeLeft.width - 8
        y: timeRight.y + 32
        text: "\uf0e2"
        size: 14
        opacity: 0.0
        color: Context.loop() === 0 ? "#ffffff" : Context.detailColor()

        property int activeLoop: Context.loop()

        MouseArea {
            anchors.fill: parent
            onClicked: {

                if (loop.activeLoop == 0) {
                    loop.activeLoop = 1
                    loop.color = detail
                    mediaPlayer.loops = Audio.Infinite
                } else {
                    loop.activeLoop = 0
                    loop.color = "#ffffff"
                    mediaPlayer.loops = 0
                }

                Context.loop(loop.activeLoop)
            }
        }
    }

    WindowDecoration {
        id: decoration
        win: main
        opacity: 0
        detail: detail
    }

    Component.onCompleted: {
        progress.detail = Context.detailColor()
        controller.detail = progress.detail
        decoration.detail = controller.detail
        detail = progress.detail
    }
}
