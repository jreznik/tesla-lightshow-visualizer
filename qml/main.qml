import QtQuick
import QtQuick.Controls
import QtQuick3D
import QtQuick3D.Helpers
import QtQuick.Dialogs
import QtCore
import Tesla.Lightshow
import "cars/ModelS"
import "cars/Cybertruck"

Window {
    id: window
    width: 1280
    height: 720
    visible: true
    title: qsTr("Tesla Lightshow 3D Visualizer")
    color: "black"
    
    property string carType: "ModelS"
    property real carRotationZ: 270
    property real cameraZ: 3000 
    property real envBrightness: 0.8
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
        camera: camera
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
            
            Node {
                position: Qt.vector3d(0, 0, 0)
                scale: Qt.vector3d(1.0, 1.0, 1.0)
                
                ModelSCar {
                    id: modelS
                    visible: window.carType === "ModelS"
                    showDebug: window.showDebug
                    frameData: sync.playing ? sync.currentFrameData : window.manualFrameData
                }
                
                CybertruckCar {
                    id: ct
                    visible: window.carType === "Cybertruck"
                    showDebug: window.showDebug
                    frameData: sync.playing ? sync.currentFrameData : window.manualFrameData
                }
            }
        }
        Model {
            source: "#Rectangle"; scale: Qt.vector3d(100, 100, 1); eulerRotation: Qt.vector3d(-90, 0, 0); position: Qt.vector3d(0, 0, 0)
            materials: [ PrincipledMaterial { 
                baseColor: window.envBrightness > 0.5 ? "#888888" : "#222222"
                roughness: 0.6; metalness: 0.1 
            } ]
        }

        // --- Sun / Main Lighting ---
        DirectionalLight { 
            id: sunLight
            eulerRotation: Qt.vector3d(-60, 45, 0)
            brightness: window.envBrightness > 0.5 ? 2.5 : 0.4
            color: window.envBrightness > 0.5 ? "#ffffcc" : "#9999ff"
            castsShadow: window.envBrightness > 0.5
            shadowMapQuality: DirectionalLight.ShadowMapQualityHigh
            shadowBias: 0.5
        }
        
        // Simplified fill lights (Shader handles side visibility)
        DirectionalLight { eulerRotation: Qt.vector3d(-45, 45, 0); brightness: window.envBrightness * 1.0; color: "white" } 
        DirectionalLight { eulerRotation: Qt.vector3d(0, 90, 0); brightness: window.envBrightness * 0.4; color: "white" }
        DirectionalLight { eulerRotation: Qt.vector3d(0, -90, 0); brightness: window.envBrightness * 0.4; color: "white" }


        // Night-time rim lighting to make CT silhouette visible
        DirectionalLight { 
            eulerRotation: Qt.vector3d(-10, 180, 0)
            brightness: window.envBrightness > 0.5 ? 0.0 : 1.5
            color: "#444466"
        }
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
        width: 80; height: 600; color: "#66000000"; radius: 15; border.color: "#33ffffff"; z: 200
        
        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 20
            Column {
                width: parent.width; spacing: 10
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: window.envBrightness > 0.5 ? "\u2600" : "\u263E" 
                    font.pixelSize: 24; width: 60; height: 50
                    onClicked: window.envBrightness = (window.envBrightness > 0.5 ? 0.4 : 1.0)
                }
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: window.visibility === Window.FullScreen ? "\u25A3" : "\u26F6" 
                    font.pixelSize: 24; width: 60; height: 50
                    onClicked: window.visibility = (window.visibility === Window.FullScreen) ? Window.Windowed : Window.FullScreen
                }
                ComboBox {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 60; height: 40
                    model: ["S", "CT"]
                    onActivated: (index) => { window.carType = (index === 0 ? "ModelS" : "Cybertruck") }
                }
            }
            Column {
                width: parent.width; spacing: 15
                Column {
                    width: parent.width; spacing: 5
                    Text { text: "ROT"; color: "white"; font.pixelSize: 10; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                    Slider { id: rotSlider; orientation: Qt.Vertical; from: 0; to: 360; value: window.carRotationZ % 360; height: 120; anchors.horizontalCenter: parent.horizontalCenter; onMoved: window.carRotationZ = value }
                }
                Column {
                    width: parent.width; spacing: 5
                    Text { text: "ZOOM"; color: "white"; font.pixelSize: 10; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                    Slider { id: zoomSlider; orientation: Qt.Vertical; from: 1000; to: 5000; value: window.cameraZ; height: 120; anchors.horizontalCenter: parent.horizontalCenter; onMoved: window.cameraZ = value }
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
                    onClicked: { if (sync.playing) sync.pause(); else sync.play(); keyboardHandler.forceActiveFocus() }
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

    property var activeCar: carType === "ModelS" ? modelS : ct

    Item {
        anchors.fill: parent; visible: window.showDebug; z: 210
        Repeater {
            model: activeCar ? activeCar.markerModel : []
            Label {
                text: modelData.ch; color: "white"; font.bold: true; font.pixelSize: 16
                property var scenePos: (activeCar && modelData) ? activeCar.mapPositionToScene(modelData.pos) : Qt.vector3d(0,0,0)
                property var screenPos: (view && scenePos) ? view.mapFrom3DScene(scenePos) : Qt.vector3d(0,0,0)
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
                    model: 46
                    Rectangle {
                        width: 310; height: 20; color: (sync.currentFrameData && sync.currentFrameData[index] > 0) ? "red" : "#333333"
                        Text { anchors.centerIn: parent; text: index + ": (" + (sync.currentFrameData ? (sync.currentFrameData[index] || 0) : 0) + ")"; color: "white"; font.pixelSize: 11 }
                    }
                }
            }
        }
    }
}
