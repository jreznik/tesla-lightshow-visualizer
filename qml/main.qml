import QtQuick
import QtQuick.Controls
import QtQuick3D
import QtQuick3D.Helpers
import QtQuick.Dialogs
import Tesla.Lightshow

Window {
    id: window
    width: 1280
    height: 720
    visible: true
    title: qsTr("Tesla Lightshow 3D Visualizer")
    color: "black"
    
    property real carRotationZ: 270
    property real cameraZ: 3000 
    property real envBrightness: 0.5 
    property bool showDebug: false
    property bool showFPS: false
    property string errorMessage: ""
    property var manualFrameData: [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

    function setManualChannel(ch, val) {
        if (ch < 0 || ch >= 48) return
        let next = []
        for (let i = 0; i < 48; ++i) next.push(window.manualFrameData[i])
        next[ch] = val
        window.manualFrameData = next
    }

    LightshowSync {
        id: sync
    }

    FileDialog {
        id: fileDialog
        title: "Select Lightshow FSEQ File"
        currentFolder: StandardPaths.writableLocation(StandardPaths.HomeLocation)
        nameFilters: ["FSEQ files (*.fseq)"]
        onAccepted: {
            let fseqPath = selectedFile.toString().replace("file://", "")
            let audioPathWav = fseqPath.replace(".fseq", ".wav")
            let audioPathMp3 = fseqPath.replace(".fseq", ".mp3")
            if (sync.loadShow(fseqPath, audioPathWav) || sync.loadShow(fseqPath, audioPathMp3)) {
                sync.position = 0
            } else {
                errorMessage = "FAILED TO LOAD LIGHTSHOW. ENSURE THE .FSEQ FILE IS VALID AND A MATCHING .MP3/.WAV EXISTS."
                errorDialog.open()
            }
        }
    }

    MessageDialog {
        id: errorDialog
        title: "Load Error"
        text: window.errorMessage
        buttons: MessageDialog.Ok
    }

    Item {
        id: keyboardHandler
        anchors.fill: parent
        focus: true
        Keys.onPressed: (event) => {
            if (event.isAutoRepeat) return
            if (event.key === Qt.Key_D) window.showDebug = !window.showDebug
            else if (event.key === Qt.Key_F) window.showFPS = !window.showFPS
            else if (event.key === Qt.Key_F11) window.visibility = (window.visibility === Window.FullScreen) ? Window.Windowed : Window.FullScreen
            else if (event.key === Qt.Key_Left) rotationTimer.dir = -1
            else if (event.key === Qt.Key_Right) rotationTimer.dir = 1
            else if (event.key === Qt.Key_Up) zoomTimer.dir = -1
            else if (event.key === Qt.Key_Down) zoomTimer.dir = 1
            else if (window.showDebug) {
                let ch = getChannelForKey(event.key)
                if (ch !== -1) setManualChannel(ch, 255)
            }
        }
        Keys.onReleased: (event) => {
            if (event.isAutoRepeat) return
            if (event.key === Qt.Key_Left || event.key === Qt.Key_Right) rotationTimer.dir = 0
            else if (event.key === Qt.Key_Up || event.key === Qt.Key_Down) zoomTimer.dir = 0
            else if (window.showDebug) {
                let ch = getChannelForKey(event.key)
                if (ch !== -1) setManualChannel(ch, 0)
            }
        }
        function getChannelForKey(key) {
            if (key >= Qt.Key_0 && key <= Qt.Key_9) return key - Qt.Key_0
            if (key === Qt.Key_Q) return 10; if (key === Qt.Key_W) return 11; if (key === Qt.Key_E) return 12; if (key === Qt.Key_R) return 13
            if (key === Qt.Key_T) return 14; if (key === Qt.Key_Y) return 15; if (key === Qt.Key_U) return 16; if (key === Qt.Key_I) return 17
            if (key === Qt.Key_O) return 18; if (key === Qt.Key_P) return 19; if (key === Qt.Key_A) return 20; if (key === Qt.Key_S) return 21
            if (key === Qt.Key_Z) return 22; if (key === Qt.Key_X) return 23; if (key === Qt.Key_G) return 24; if (key === Qt.Key_H) return 25
            if (key === Qt.Key_J) return 26; if (key === Qt.Key_K) return 27; if (key === Qt.Key_L) return 28; if (key === Qt.Key_Semicolon) return 29
            if (key === Qt.Key_C) return 30; if (key === Qt.Key_V) return 31; if (key === Qt.Key_B) return 32; if (key === Qt.Key_N) return 33
            if (key === Qt.Key_M) return 34; if (key === Qt.Key_Comma) return 35; if (key === Qt.Key_Period) return 36; if (key === Qt.Key_Slash) return 37
            if (key === Qt.Key_Minus) return 38; if (key === Qt.Key_Equal) return 39; if (key === Qt.Key_BracketLeft) return 40; if (key === Qt.Key_BracketRight) return 41
            if (key === Qt.Key_Backslash) return 42; if (key === Qt.Key_Apostrophe) return 43; if (key === Qt.Key_Space) return 44; if (key === Qt.Key_Return) return 45
            return -1
        }
    }

    Timer { id: rotationTimer; property int dir: 0; interval: 16; running: dir !== 0; repeat: true; onTriggered: window.carRotationZ += dir * 2 }
    Timer { id: zoomTimer; property int dir: 0; interval: 16; running: dir !== 0; repeat: true; onTriggered: window.cameraZ = Math.max(1000, Math.min(5000, window.cameraZ + dir * 20)) }

    View3D {
        id: view
        anchors.fill: parent
        environment: ExtendedSceneEnvironment {
            clearColor: window.envBrightness > 0.5 ? "skyblue" : "#050505"
            backgroundMode: SceneEnvironment.Color
            antialiasingMode: SceneEnvironment.MSAA; antialiasingQuality: SceneEnvironment.High
            glowEnabled: true; glowStrength: 1.5; glowBloom: 0.3; tonemapMode: SceneEnvironment.TonemapModeFilmic
            fog: Fog { enabled: true; color: window.envBrightness > 0.5 ? "skyblue" : "#020202"; density: 0.1; depthEnabled: true; depthNear: 100; depthFar: 5000 }
        }
        PerspectiveCamera { id: camera; position: Qt.vector3d(0, 400, window.cameraZ); eulerRotation: Qt.vector3d(-15, 0, 0) }
        Node {
            eulerRotation: Qt.vector3d(0, window.carRotationZ, 0)
            ModelSCar {
                id: car
                position: Qt.vector3d(450, 0, 80)
                scale: Qt.vector3d(1.8, 1.8, 1.8)
                showDebug: window.showDebug
                frameData: sync.playing ? sync.currentFrameData : window.manualFrameData
            }
        }
        Model {
            source: "#Rectangle"; scale: Qt.vector3d(100, 100, 1); eulerRotation: Qt.vector3d(-90, 0, 0); position: Qt.vector3d(0, -1, 0)
            materials: [ PrincipledMaterial { 
                baseColor: window.envBrightness > 0.5 ? "#888888" : "#222222"
                roughness: 0.6; metalness: 0.1 
            } ]
        }
        DirectionalLight { eulerRotation: Qt.vector3d(-45, 45, 0); brightness: window.envBrightness * 2.5 } 
        DirectionalLight { eulerRotation: Qt.vector3d(45, -135, 0); brightness: window.envBrightness * 1.5 }
    }

    MouseArea {
        anchors.fill: parent
        property real lastX: 0
        onPressed: (mouse) => { lastX = mouse.x; keyboardHandler.forceActiveFocus() }
        onPositionChanged: (mouse) => { let dx = mouse.x - lastX; window.carRotationZ += dx * 0.5; lastX = mouse.x }
        onWheel: (wheel) => { let zoomDelta = -wheel.angleDelta.y * 2; window.cameraZ = Math.max(1000, Math.min(5000, window.cameraZ + zoomDelta)) }
    }

    Text {
        anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter; anchors.topMargin: 20
        text: sync.showName !== "" ? "SHOW: " + sync.showName : "PLEASE LOAD A LIGHTSHOW FILE (.FSEQ) TO START"
        color: sync.showName !== "" ? "white" : "orange"
        font.pixelSize: 24; font.bold: true; style: Text.Outline; styleColor: "black"
        z: 300
    }

    Rectangle {
        id: controlPanel
        anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; anchors.margins: 20
        width: 80; height: 540; color: "#66000000"; radius: 15; border.color: "#33ffffff"; z: 200
        
        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 25
            Column {
                width: parent.width; spacing: 12
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: window.envBrightness > 0.5 ? "\u2600" : "\u263E" 
                    font.pixelSize: 24; width: 60; height: 50
                    onClicked: window.envBrightness = (window.envBrightness > 0.5 ? 0.4 : 1.0)
                    ToolTip.visible: hovered; ToolTip.text: "Toggle Day/Night"
                }
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: window.visibility === Window.FullScreen ? "\u25A3" : "\u26F6" 
                    font.pixelSize: 24; width: 60; height: 50
                    onClicked: window.visibility = (window.visibility === Window.FullScreen) ? Window.Windowed : Window.FullScreen
                    ToolTip.visible: hovered; ToolTip.text: "Toggle Fullscreen"
                }
            }
            Column {
                width: parent.width; spacing: 20
                Column {
                    width: parent.width; spacing: 5
                    Text { text: "ROT"; color: "white"; font.pixelSize: 10; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                    Slider { id: rotSlider; orientation: Qt.Vertical; from: 0; to: 360; value: window.carRotationZ % 360; height: 130; anchors.horizontalCenter: parent.horizontalCenter; onMoved: window.carRotationZ = value }
                }
                Column {
                    width: parent.width; spacing: 5
                    Text { text: "ZOOM"; color: "white"; font.pixelSize: 10; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                    Slider { id: zoomSlider; orientation: Qt.Vertical; from: 1000; to: 5000; value: window.cameraZ; height: 130; anchors.horizontalCenter: parent.horizontalCenter; onMoved: window.cameraZ = value }
                }
            }
        }
    }
    
    Binding { target: rotSlider; property: "value"; value: window.carRotationZ % 360 }
    Binding { target: zoomSlider; property: "value"; value: window.cameraZ }

    function formatTime(ms) {
        if (ms < 0) ms = 0
        let totalSecs = Math.floor(ms / 1000)
        let mins = Math.floor(totalSecs / 60)
        let secs = totalSecs % 60
        return mins + ":" + (secs < 10 ? "0" : "") + secs
    }

    Rectangle {
        anchors.bottom: parent.bottom; width: parent.width; height: 100; color: "#33000000"; z: 230
        Column {
            anchors.centerIn: parent; spacing: 10
            Row {
                spacing: 10
                Button { 
                    text: sync.playing ? "\u23F8" : "\u25B6"
                    font.pixelSize: 18; width: 50; height: 40
                    enabled: sync.showName !== ""
                    onClicked: { 
                        if (sync.playing) sync.pause()
                        else sync.play()
                        keyboardHandler.forceActiveFocus() 
                    }
                }
                Button { 
                    text: "\u25A0"
                    font.pixelSize: 18; width: 50; height: 40
                    enabled: sync.showName !== ""
                    onClicked: { sync.stop(); sync.position = 0; keyboardHandler.forceActiveFocus() }
                }
                Button { text: "Load Show"; height: 40; onClicked: { fileDialog.open(); keyboardHandler.forceActiveFocus() } }
            }
            Row {
                spacing: 15; anchors.horizontalCenter: parent.horizontalCenter
                Text { text: formatTime(sync.position); color: "white"; font.family: "Monospace"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter; opacity: sync.showName !== "" ? 1.0 : 0.3 }
                Slider { width: 700; from: 0; to: sync.duration; value: sync.position; onMoved: sync.position = value; enabled: sync.showName !== "" }
                Text { text: formatTime(sync.duration); color: "white"; font.family: "Monospace"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter; opacity: sync.showName !== "" ? 1.0 : 0.3 }
            }
        }
    }

    Item {
        anchors.fill: parent; visible: window.showDebug; z: 210
        Repeater {
            model: car.markerModel
            Label {
                text: modelData.ch; color: "white"; font.bold: true; font.pixelSize: 16
                property var scenePos: car ? car.mapPositionToScene(modelData.pos) : Qt.vector3d(0,0,0)
                property var screenPos: view ? view.map3dTo2d(scenePos) : Qt.vector2d(0,0)
                x: screenPos.x - width/2; y: screenPos.y - height/2
                background: Rectangle { color: "#aa000000"; radius: 4 }
                padding: 4
            }
        }
    }

    Rectangle {
        id: debugPanel; visible: window.showDebug; anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 320; color: "#cc000000"; z: 220
        Flickable {
            anchors.fill: parent; contentHeight: debugFlow.height; clip: true
            Column {
                id: debugFlow; width: parent.width; spacing: 2
                Repeater {
                    model: [
                        { k: "0", ch: 0, n: "L Outer Beam" }, { k: "1", ch: 1, n: "R Outer Beam" },
                        { k: "2", ch: 2, n: "L Inner Beam" }, { k: "3", ch: 3, n: "R Inner Beam" },
                        { k: "4", ch: 4, n: "L Signature" }, { k: "5", ch: 5, n: "R Signature" },
                        { k: "6", ch: 6, n: "L Channel 4" }, { k: "7", ch: 7, n: "R Channel 4" },
                        { k: "8", ch: 8, n: "L Channel 5" }, { k: "9", ch: 9, n: "R Channel 5" },
                        { k: "Q", ch: 10, n: "L Channel 6" }, { k: "W", ch: 11, n: "R Channel 6" },
                        { k: "E", ch: 12, n: "L Front Turn" }, { k: "R", ch: 13, n: "R Front Turn" },
                        { k: "T", ch: 14, n: "L Front Fog" }, { k: "Y", ch: 15, n: "R Front Fog" },
                        { k: "U", ch: 16, n: "L Aux Park" }, { k: "I", ch: 17, n: "R Aux Park" },
                        { k: "O", ch: 18, n: "L Side Marker" }, { k: "P", ch: 19, n: "R Side Marker" },
                        { k: "A", ch: 20, n: "L Side Repeat" }, { k: "S", ch: 21, n: "R Side Repeat" },
                        { k: "Z", ch: 22, n: "L Rear Turn" }, { k: "X", ch: 23, n: "R Rear Turn" },
                        { k: "G", ch: 24, n: "Brake Lights" }, { k: "H", ch: 25, n: "L Tail" },
                        { k: "J", ch: 26, n: "R Tail" }, { k: "K", ch: 27, n: "Reverse" },
                        { k: "L", ch: 28, n: "Rear Fog" }, { k: ";", ch: 29, n: "License Plate" },
                        { k: "C", ch: 30, n: "L Falcon" }, { k: "V", ch: 31, n: "R Falcon" },
                        { k: "B", ch: 32, n: "L Front Door" }, { k: "N", ch: 33, n: "R Front Door" },
                        { k: "M", ch: 34, n: "L Mirror" }, { k: ",", ch: 35, n: "R Mirror" },
                        { k: ".", ch: 36, n: "L Front Win" }, { k: "/", ch: 37, n: "L Rear Win" },
                        { k: "-", ch: 38, n: "R Front Win" }, { k: "=", ch: 39, n: "R Rear Win" },
                        { k: "[", ch: 40, n: "Liftgate" }, { k: "]", ch: 41, n: "L F Handle" },
                        { k: "\\", ch: 42, n: "L R Handle" }, { k: "'", ch: 43, n: "R F Handle" },
                        { k: "SPC", ch: 44, n: "R R Handle" }, { ch: 45, n: "Charge Port" }
                    ]
                    Rectangle {
                        width: 310; height: 20; color: (car.frameData && car.frameData[modelData.ch] > 0) ? "red" : "#333333"
                        Text { anchors.centerIn: parent; text: "[" + (modelData.k || "?") + "] " + modelData.ch + ": " + modelData.n + " (" + (car.frameData ? (car.frameData[modelData.ch] || 0) : 0) + ")"; color: "white"; font.pixelSize: 11 }
                    }
                }
            }
        }
    }
}
