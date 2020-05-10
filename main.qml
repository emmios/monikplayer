import QtQuick 2.9
import QtQuick.Controls 2.2
import QtMultimedia 5.9
import QtGraphicalEffects 1.0
import "./Components"


AppCustom {
    id: root
    visible: true
    x: 100
    y: 100
    width: 800
    height: 450//490
    title: qsTr("Synth Player")
    color: "#000000"
    flags: Qt.Window | Qt.FramelessWindowHint

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
                root.showFullScreen();
                output.anchors.topMargin = 0
                output.anchors.bottomMargin = 0
                fullscreen = false
                decoration.visible = false
            } else {
                root.showNormal();
                output.anchors.topMargin = 0//25
                output.anchors.bottomMargin = 0
                fullscreen = true
                decoration.visible = true
            }
        }

        onPressed: {
            startX = mouseX
            startY = mouseY
            cursorShape = Qt.SizeAllCursor
        }

        onReleased: {
            cursorShape = Qt.ArrowCursor
        }

        onMouseXChanged: {
            root.x = Context.mouseX() - startX
            root.y = Context.mouseY() - startY
            Context.windowMove(root.x, root.y, root.width, root.height)
        }
    }

    function imedia(file) {
        var url = "file://" + file
        btn.text = "\uf28b"
        btn.paused = true
        mediaPlayer.source = url
        mediaPlayerPreview.source = url
        titleArea.fullTitle = file
        titleArea.originalTitle = file
        titleArea.titleSize()
    }

    function quality(arg) {
        if (arg) {
            output.smooth = true
            hue.enabled = true
            hue.visible = true
            output.visible = false
            Context.hq(1)
        } else {
            output.smooth = false
            hue.visible = false
            hue.enabled = false
            output.visible = true
            Context.hq(0)
        }
        hue.source = output
    }

    DropArea {
        id: dragTarget
        anchors.fill: parent

        property string url: ""

        onEntered: {
            url = drag.urls[0]
        }
        onDropped:
        {
            mediaPlayer.source = url
            mediaPlayerPreview.source = url
            titleArea.fullTitle = url
            titleArea.originalTitle = url
            titleArea.titleSize()
            //btn.text = "\uf144"
            btn.text = "\uf28b"
            btn.paused = true
        }
    }

    Rectangle {
        id: loading
        visible: false
        anchors.fill: parent

        AnimatedImage {
            id: animation
            anchors.fill: parent
            asynchronous: true
            source: "qrc:/Resources/audio-animação.gif"
        }

        Rectangle {
            property int frames: animation.frameCount

            width: 4; height: 8
            x: (animation.width - width) * animation.currentFrame / frames
            y: animation.height
            color: "#fff"
        }

        Rectangle {
            anchors.fill: parent
            color: "#000000"
            opacity: 0.5
        }
    }

    Image {
        id: musicIcon
        anchors.centerIn: parent
        source: "qrc:/Resources/music-solid.svg"
        width: 60
        height: 60
        visible: false
        antialiasing: true
        smooth: true
    }

    ColorOverlay {
        id: overlay
        x: 20
        y: 20
        width: 60
        height: 60
        source: musicIcon
        color: detail
        antialiasing: true
        smooth: true
        visible: false
        opacity: 0.4
    }

    VideoOutput {
        id: output
        x: 0
        y: 0
        anchors.fill: parent
        anchors.topMargin: 0//25
        anchors.bottomMargin: 0
        source: mediaPlayer
        visible: true
        smooth: false
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
    }

    HueSaturation {
        id: hue
        anchors.fill: output
        hue: 0.0
        saturation: 0.5
        lightness: 0.0
        antialiasing: true
        smooth: true
        enabled: false
        cached: true
    }

    Rectangle {
        id: btnDestak
        anchors.fill: parent
        color: "#000000"
        opacity: 0.0
    }

    Rectangle {
        id: bottomDeskt
        width: root.width
        height: root.height / 4
        y: root.height - (root.height / 4)
        color: "transparent"

        PropertyAnimation {id: animation1; target: btn; property: "opacity"; to: 0.4; duration: 500}
        PropertyAnimation {id: animation2; target: btnDestak; property: "opacity"; to: 0.8; duration: 500}
        PropertyAnimation {id: animation3; target: progress; property: "opacity"; to: 0.8; duration: 500}
        PropertyAnimation {id: animation4; target: preview; property: "opacity"; to: 1; duration: 500}
        PropertyAnimation {id: animation5; target: timeLeft; property: "opacity"; to: 1; duration: 500}
        PropertyAnimation {id: animation6; target: timeRight; property: "opacity"; to: 1; duration: 500}
        PropertyAnimation {id: animation7; target: controller; property: "opacity"; to: 1; duration: 500}
        PropertyAnimation {id: animation9; target: videoTitle; property: "opacity"; to: 0.8; duration: 500}

        function show() {
            animation1.to = 0.4
            animation1.stop()
            animation1.start()
            animation2.to = 0.7
            animation2.stop()
            animation2.start()
            animation3.to = 0.7
            animation3.stop()
            animation3.start()
            animation5.to = 0.7
            animation5.stop()
            animation5.start()
            animation6.to = 0.7
            animation6.stop()
            animation6.start()
            animation7.to = 0.7
            animation7.stop()
            animation7.start()
            loop.animation(0.7)
            hq.animation(0.7)
            animation9.to = 0.7
            animation9.stop()
            animation9.start()
        }

        function hide() {
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
            loop.animation(0)
            hq.animation(0)
            animation9.to = 0
            animation9.stop()
            animation9.start()
        }

        function customShow() {
            animation1.to = 0.3
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
            loop.animation(1)
            hq.animation(1)
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onHoveredChanged: {
                bottomDeskt.show()
            }

            onExited: {
                bottomDeskt.hide()
            }
        }
    }

    Label {
        id: btn
        x: (root.width / 2) - (width / 2)
        y: (root.height / 2) - (height / 2)
        text: "\uf28b"
        size: root.width / 3
        font.family: font_regular.name
        opacity: 0.0
        property bool paused: true
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                if (btn.paused) {
                    btn.text = "\uf144"
                    mediaPlayer.pause()

                } else {
                    parent.text = "\uf28b"
                    mediaPlayer.play()
                }
                btn.paused = !btn.paused
            }

            onHoveredChanged: {
                bottomDeskt.show()
                cursorShape = Qt.PointingHandCursor
            }

            onExited: {
                bottomDeskt.hide()
                cursorShape = Qt.ArrowCursor
            }
        }
    }

    Rectangle {
        id: preview
        x: 0
        y: 0
        width: root.width / 6 + 20
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

    Rectangle {
        id: titleArea
        anchors.top: parent.top
        anchors.topMargin: 12
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        height: 14
        color: "#00000000"
        clip: true
        property bool start: true
        property int space: 10
        property string fullTitle: Context.uri()
        property string originalTitle: Context.uri().split('/')[Context.uri().split('/').length - 1]
        property alias videoTitle: videoTitle
        Label {
            id: videoTitle
            text: titleArea.originalTitle
            size: 12
            opacity: 0.0
            anchors.centerIn: parent
        }

        function titleFormat(arg) {
            if (arg === "") return ""
            if (arg.indexOf("/") === -1) return arg
            return arg.split('/')[arg.split('/').length - 1]
        }

        function titleSize() {
            while (true) {
                if (titleArea.width < 0) break
                if (start) {
                    videoTitle.text = titleArea.originalTitle
                    start = false
                }
                if (videoTitle.width + space > titleArea.width) {
                    var len = videoTitle.text.length
                    videoTitle.text = videoTitle.text.substring(0, len - 6) + "..."
                }
                if (videoTitle.width + space <= titleArea.width) {
                    start = true
                    break
                }
            }
        }

        onOriginalTitleChanged: {
            originalTitle = titleFormat(originalTitle)
            root.title = "Synth Player | " + titleArea.originalTitle
        }

        onWidthChanged: {
            while (true) {
                if (titleArea.width < 0) break
                if (start) {
                    videoTitle.text = titleArea.originalTitle
                    start = false
                }
                if (videoTitle.width + space > titleArea.width) {
                    var len = videoTitle.text.length
                    videoTitle.text = videoTitle.text.substring(0, len - 6) + "..."
                }
                if (videoTitle.width + space <= titleArea.width) {
                    start = true
                    break
                }
            }
        }
    }

    ProgressBar {
        id: progress
        x: 80
        y: root.height - (root.height / 6)
        width: root.width - 160
        height: 6
        max: mediaPlayer.duration
        opacity: 0.0
        detail: detail

        onClick: {
            mediaPlayer.seek(atual)
        }

        Timer {
            id: timer
            running: false
            repeat: false
            interval: 500
            property bool hide: false
            onTriggered: {
                mediaPlayerPreview.seek(parent.value)
                mediaPlayerPreview.play()
                mediaPlayerPreview.pause()
                preview.x = (parent.x + parent.mousex) - (preview.width / 2)
                preview.y = parent.y - (preview.height + 10)
                if (hide) {
                    animation4.to = 0
                    animation4.stop()
                    animation4.start()
                } else {
                    animation4.to = 1
                    animation4.stop()
                    animation4.start()
                }
            }
        }

        onMousexChanged: {
            timer.stop()
            timer.interval = 100
            timer.hide = false
            timer.start()
        }

        onHover: {
            timer.stop()
            timer.interval = 500
            timer.hide = false
            timer.start()

            bottomDeskt.show()
            mouse.cursorShape = Qt.PointingHandCursor
        }

        onOut: {
            timer.stop()
            timer.interval = 0
            timer.hide = true
            timer.start()
            mouse.cursorShape = Qt.ArrowCursor
        }
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

        onHover: {
            bottomDeskt.show()
            mouse.cursorShape = Qt.PointingHandCursor
        }

        onOut: {
            mouse.cursorShape = Qt.ArrowCursor
        }
    }

    Label {
        id: loop
        x: progress.x - timeLeft.width - 8
        y: timeRight.y + 32
        text: "\uf0e2"
        size: 14
        opacity: 0.0
        color: Context.loop() === 0 ? "#ffffff" : detail
        property int activeLoop: Context.loop()
        font.family: font_regular.name
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onHoveredChanged: {
                bottomDeskt.show()
                cursorShape = Qt.PointingHandCursor
            }

            onExited: {
                cursorShape = Qt.ArrowCursor
            }

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
        function animation(arg) {
            loopAni.to = arg
            loopAni.stop()
            loopAni.start()
        }
        PropertyAnimation {id: loopAni; target: loop; property: "opacity"; to: 1; duration: 500}
    }

    Label {
        id: hq
        x: loop.x + loop.width + 10
        y: timeRight.y + 32
        text: "\uf0fd"
        size: 14
        opacity: 0.0
        color: Context.hq() === 0 ? "#ffffff" : detail
        property int activeHq: Context.hq()
        font.family: font_solid.name
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onHoveredChanged: {
                bottomDeskt.show()
                cursorShape = Qt.PointingHandCursor
            }

            onExited: {
                cursorShape = Qt.ArrowCursor
            }

            onClicked: {
                if (hq.activeHq === 1) {
                    quality(false)
                    hq.activeHq = 0
                    hq.color = "#ffffff"
                } else {
                    quality(true)
                    hq.activeHq = 1
                    hq.color = detail
                }
            }
        }

        Component.onCompleted: { quality(activeHq === 1 ? true : false) }

        function animation(arg) {
            hqAni.to = arg
            hqAni.stop()
            hqAni.start()
        }
        PropertyAnimation {id: hqAni; target: hq; property: "opacity"; to: 1; duration: 500}
    }

    WindowDecoration {
        id: decoration
        win: root
        opacity: 0
        detail: detail
        Label {
            x: 8
            y: 5
            text: "\uf2d2"
            size: 12
            opacity: 0.7
            color: "#ffffff"
            font.family: font_regular.name
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                property bool colorTmp: true
                property int rootW: 0
                property int rootH: 0

                onHoveredChanged: {
                    decoration.opacity = 1.0
                    cursorShape = Qt.PointingHandCursor
                }

                onExited: {
                    cursorShape = Qt.ArrowCursor
                }

                onClicked: {
                    if (colorTmp) {
                        parent.color = detail
                        rootW = root.width
                        rootH = root.height
                        root.width = 340
                        root.height = 180
                        root.flags = Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
                    } else {
                        parent.color = "#ffffff"
                        root.width = rootW
                        root.height = rootH
                        root.flags = Qt.Window | Qt.FramelessWindowHint
                    }
                    colorTmp = !colorTmp
                }
            }
        }
    }

    Component.onCompleted: {
        progress.detail = Context.detailColor()
        controller.detail = progress.detail
        decoration.detail = controller.detail
        detail = progress.detail

        if (media.indexOf(".mp3") != -1 ||
            media.indexOf(".m4a") != -1 ||
            media.indexOf(".ogg") != -1 ||
            media.indexOf(".aac") != -1 ||
            media.indexOf(".ac3") != -1 ||
            media.indexOf(".wma") != -1) {
            loading.visible = true
            overlay.visible = true
        } else {
            loading.visible = false
            overlay.visible = false
        }

        titleArea.titleSize()
    }
}
