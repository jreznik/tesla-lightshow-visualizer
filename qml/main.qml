import QtQuick
import QtQuick.Controls
import QtQuick3D
import QtQuick3D.Helpers
import QtQuick3D.Effects
import QtQuick.Dialogs
import QtCore
import Qt.labs.settings
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
    
    // PERSISTENCE
    Settings {
        id: appSettings
        category: "Visualizer"
        property string carType: "ModelS"
        property real carRotationZ: 315
        property real cameraZ: 2000
        property real envBrightness: 1.0
        property bool autoloadShow: true
        property string lastShowPath: ""
        property bool showModeActive: true
    }

    property string carType: appSettings.carType
    property real carRotationZ: appSettings.carRotationZ
    property real cameraZ: appSettings.cameraZ
    property real cameraY: 400
    property real cameraX: 0
    property real cameraPitch: -15
    property real cameraYaw: 0
    property real envBrightness: appSettings.envBrightness
    property bool showModeActive: appSettings.showModeActive
    property int currentHeroShot: -1
    property int countdownValue: 0

    onCarTypeChanged: appSettings.carType = carType
    onCarRotationZChanged: appSettings.carRotationZ = carRotationZ
    onCameraZChanged: appSettings.cameraZ = cameraZ
    onEnvBrightnessChanged: appSettings.envBrightness = envBrightness
    onShowModeActiveChanged: appSettings.showModeActive = showModeActive

    property int shotCount: 0
    property real currentEnergy: 0.0
    property real lastCutTime: 0

    // Calculate "Energy" (activity) of the current frame
    function updateEnergy() {
        if (!sync.playing || !sync.currentFrameData) { currentEnergy = 0; return; }
        let sum = 0
        for (let i = 0; i < 48; i++) sum += (sync.currentFrameData[i] || 0)
        let energy = sum / (48 * 255.0)
        // Smooth the energy
        currentEnergy = currentEnergy * 0.8 + energy * 0.2
    }

    // GUARANTEED VIEWPORT LOCK:
    // Camera pitch calculated to point at car center (Y=100) from camera position
    // pitch = -atan((cameraY - carY) / cameraZ) in degrees
    property var heroShots: [
        { rot: 315, zoom: 2200, y: 400, pitch: -8 },       // 0: DEFAULT (was -15)
        { rot: 45,  zoom: 1800, y: 250, pitch: -5 },       // 1: Front (was -10)
        { rot: 135, zoom: 2500, y: 450, pitch: -8 },       // 2: Rear High (was -20)
        { rot: 225, zoom: 1800, y: 250, pitch: -5 },       // 3: Rear Side (was -12)
        { rot: 270, zoom: 2800, y: 200, pitch: -2 },       // 4: Side (was -5)
        { rot: 450, zoom: 3200, y: 1200, pitch: -20 },     // 5: DRONE (was -45)
        { rot: 675, zoom: 3800, y: 1500, pitch: -22 },     // 6: Top Down (was -90)
        { rot: 315, zoom: 1600, y: 150, pitch: -2 },       // 7: Front Low (was -5)
        { rot: 135, zoom: 1600, y: 150, pitch: -2 }        // 8: Rear Low (was -5)
    ]

    function nextHeroShot() {
        shotCount++
        // Randomly pick a shot, but not the same as current
        let nextShot = currentHeroShot
        while (nextShot === currentHeroShot) {
            nextShot = Math.floor(Math.random() * heroShots.length)
        }
        currentHeroShot = nextShot
        let shot = heroShots[currentHeroShot]

        // Energy-reactive transition speed (more toned down for high energy)
        // High energy: 1000-1500ms (smooth)
        // Medium energy: 1500-2300ms (smoother)
        // Low energy: 2500-3500ms (slow, cinematic)
        let energyLevel = Math.max(0.1, currentEnergy)
        let baseDuration = 1000 + (1.0 - energyLevel) * 2500  // 1000-3500ms
        let variance = energyLevel * 300  // Some variance
        shotTransitionGroup.duration = baseDuration + (Math.random() - 0.5) * variance

        // Scaling factor for Cybertruck (larger footprint)
        let zoomFactor = (window.carType === "Cybertruck" ? 1.25 : 1.0)

        // Use faster easing for high energy
        if (energyLevel > 0.5) {
            shotTransitionX.easing.type = Easing.OutQuad
            shotTransitionY.easing.type = Easing.OutQuad
            shotTransitionZ.easing.type = Easing.OutQuad
            shotTransitionRot.easing.type = Easing.OutQuad
            shotTransitionPitch.easing.type = Easing.OutQuad
        } else {
            shotTransitionX.easing.type = Easing.InOutSine
            shotTransitionY.easing.type = Easing.InOutSine
            shotTransitionZ.easing.type = Easing.InOutSine
            shotTransitionRot.easing.type = Easing.InOutSine
            shotTransitionPitch.easing.type = Easing.InOutSine
        }

        // DYNAMIC CINEMATIC SWITCHING (Energy-based)
        if (shotCount % 5 === 0 && Math.random() > 0.3) {
            window.envBrightness = (window.envBrightness > 0.5 ? 0.4 : 1.0)
        }
        if (shotCount % 8 === 0 && Math.random() > 0.5) {
            window.carType = (window.carType === "ModelS" ? "Cybertruck" : "ModelS")
        }

        // Apply targets
        shotTransitionY.to = shot.y * (window.carType === "Cybertruck" ? 1.15 : 1.0); 
        shotTransitionZ.to = shot.zoom * zoomFactor
        driftTimer.targetY = shot.y  // Update drift target

        // More rotation variation at high energy for dynamic feel
        let rotVariation = 5 + (energyLevel * 10)  // 5-15 degree variation
        shotTransitionRot.to = shot.rot + (Math.random() - 0.5) * rotVariation

        shotTransitionPitch.to = shot.pitch
        shotTransitionX.to = 0; shotTransitionYaw.to = 0

        shotTransitionGroup.restart()
        lastCutTime = sync.position
    }

    // Dynamic Director: Energy-reactive cuts (toned down)
    Timer {
        id: directorTimer
        interval: 100; repeat: true; running: window.showModeActive && sync.playing
        property real energyHistory: 0.0
        property real peakEnergy: 0.0

        onTriggered: {
            updateEnergy()
            let timeSinceCut = sync.position - lastCutTime

            // Track energy history for detecting changes
            energyHistory = energyHistory * 0.9 + currentEnergy * 0.1
            peakEnergy = Math.max(peakEnergy * 0.98, currentEnergy)

            // Energy-based cut timing (toned down):
            // High energy (>0.6): 2-4s between cuts
            // Medium energy (0.3-0.6): 4-6s between cuts
            // Low energy (<0.3): 6-10s between cuts

            let minTime = 1800   // Absolute minimum (1.8s)
            let maxTime = 10000  // Maximum for very quiet scenes

            // Calculate dynamic timing based on energy
            let energyFactor = Math.max(0.1, peakEnergy)
            let idealCutTime = 2000 + (1.0 - energyFactor) * 6000  // 2s-8s range

            // Energy spike detection for quicker cuts (much less sensitive)
            let energySpike = (currentEnergy - energyHistory) > 0.5

            if (timeSinceCut < minTime) return  // Absolute minimum

            // Quick cut on massive energy spike (but not too quick)
            if (energySpike && timeSinceCut > 3500) {
                nextHeroShot()
                return
            }

            // Dynamic threshold that adapts to energy level
            let baseThreshold = 0.45 - (currentEnergy * 0.15)
            let timeDecay = timeSinceCut / (idealCutTime * 2.0)
            let threshold = baseThreshold - timeDecay

            // High energy = more cuts, low energy = fewer cuts
            if (currentEnergy > threshold || timeSinceCut > maxTime) {
                nextHeroShot()
            }
        }
    }

    ParallelAnimation {
        id: shotTransitionGroup
        property int duration: 2500
        NumberAnimation { id: shotTransitionX; target: window; property: "cameraX"; duration: shotTransitionGroup.duration; easing.type: Easing.InOutSine }
        NumberAnimation { id: shotTransitionY; target: window; property: "cameraY"; duration: shotTransitionGroup.duration; easing.type: Easing.InOutSine }
        NumberAnimation { id: shotTransitionZ; target: window; property: "cameraZ"; duration: shotTransitionGroup.duration; easing.type: Easing.InOutSine }
        NumberAnimation { id: shotTransitionRot; target: window; property: "carRotationZ"; duration: shotTransitionGroup.duration; easing.type: Easing.InOutSine }
        NumberAnimation { id: shotTransitionPitch; target: window; property: "cameraPitch"; duration: shotTransitionGroup.duration; easing.type: Easing.InOutSine }
        NumberAnimation { id: shotTransitionYaw; target: window; property: "cameraYaw"; duration: shotTransitionGroup.duration; easing.type: Easing.InOutSine }
    }

    // Cinematic Drift: Energy-reactive movement (toned down)
    Timer {
        id: driftTimer
        interval: 16; repeat: true; running: window.showModeActive && sync.playing
        property real targetY: 400  // Target Y from current shot
        onTriggered: {
            if (!shotTransitionGroup.running) {
                // Energetic rotation - subtle energy response
                let energyFactor = 0.15 + (window.currentEnergy * 0.35)
                window.carRotationZ += energyFactor

                // Subtle Y drift based on energy
                let time = new Date().getTime() / 1000.0
                let driftAmount = window.currentEnergy > 0.6 ? 20 : 10  // Modest drift
                let driftSpeed = 0.4 + (window.currentEnergy * 0.6)  // Moderate oscillation
                let drift = Math.sin(time * driftSpeed) * (energyFactor * 1.0)
                window.cameraY = Math.max(targetY - driftAmount, Math.min(targetY + driftAmount, window.cameraY + drift))
            }
        }
    }

    Timer {
        id: orbitTimer
        interval: 16; repeat: true; running: window.showModeActive && !sync.playing
        onTriggered: window.carRotationZ += 0.1
    }


    function startShowWithCountdown() {
        if (sync.showName === "") return
        sync.stop()
        
        if (window.showModeActive) {
            // RANDOM START SCENE
            window.carType = (Math.random() > 0.5 ? "ModelS" : "Cybertruck")
            window.envBrightness = (Math.random() > 0.5 ? 1.0 : 0.4)
            
            // RESET TO DEFAULT (Slightly safer zoom 2200)
            window.carRotationZ = 315; window.cameraZ = 2200; window.cameraY = 400; 
            window.cameraX = 0; window.cameraPitch = -15; window.cameraYaw = 0;
            
            countdownValue = 5
            countdownTimer.start()
        } else {
            sync.play()
        }
    }

    Timer {
        id: countdownTimer
        interval: 1000; repeat: true
        onTriggered: {
            countdownValue -= 1
            if (countdownValue <= 0) {
                stop()
                if (window.showModeActive) {
                    window.currentHeroShot = -1
                    window.nextHeroShot()
                }
                sync.play()
            }
        }
    }

    function loadShowFile(fseqPath) {
        let audioPathWav = fseqPath.replace(".fseq", ".wav")
        let audioPathMp3 = fseqPath.replace(".fseq", ".mp3")
        if (sync.loadShow(fseqPath, audioPathWav) || sync.loadShow(fseqPath, audioPathMp3)) {
            sync.position = 0
            if (appSettings.autoloadShow) {
                // If it's the very first startup autoload, maybe skip countdown or keep it?
                // The user said "when file is loaded, autoplay", and now wants countdown.
                startShowWithCountdown()
            }
            appSettings.lastShowPath = fseqPath
            return true
        }
        return false
    }

    Component.onCompleted: {
        if (appSettings.autoloadShow && appSettings.lastShowPath !== "") {
            loadShowFile(appSettings.lastShowPath)
        }
    }

    property bool showDebug: false
    property bool showFPS: false
    property string errorMessage: ""
    property var manualFrameData: [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

    property var channelNames: [
        "Left Outer Main", "Right Outer Main", "Left Inner Main", "Right Inner Main", "Left Signature", "Right Signature",
        "Left Channel 4", "Right Channel 4", "Left Channel 5", "Right Channel 5", "Left Channel 6", "Right Channel 6",
        "Left Front Turn", "Right Front Turn", "Left Front Fog", "Right Front Fog", "Left Aux Park", "Right Aux Park",
        "Left Side Marker", "Right Side Marker", "Left Side Repeater", "Right Side Repeater", "Left Rear Turn", "Right Rear Turn",
        "Brake Lights", "Left Tail", "Right Tail", "Reverse Lights", "Rear Fog Lights", "License Plate",
        "Left Falcon Door", "Right Falcon Door", "Left Front Door", "Right Front Door", "Left Mirror", "Right Mirror",
        "Left Front Window", "Left Rear Window", "Right Front Window", "Right Rear Window", "Liftgate", "Left Front Door Handle",
        "Left Rear Door Handle", "Right Front Door Handle", "Right Rear Door Handle", "Charge Port"
    ]

    property var keyHints: {
        return {
            0: "0", 1: "1", 2: "2", 3: "3", 4: "4", 5: "5", 6: "6", 7: "7", 8: "8", 9: "9",
            10: "Q", 11: "W", 12: "E", 13: "R", 14: "T", 15: "Y", 16: "U", 17: "I", 18: "O", 19: "P",
            20: "A", 21: "S", 22: "Z", 23: "X", 24: "G", 25: "H", 26: "J", 27: "K", 28: "L", 29: ";",
            30: "C", 31: "V", 32: "B", 33: "N", 34: "M", 35: ",", 36: ".", 37: "/", 38: "-", 39: "=",
            40: "[", 41: "L", 42: "\\", 43: "'", 44: "SPACE", 45: "ENTER"
        }
    }

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
            if (!loadShowFile(fseqPath)) {
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
            if (event.key === Qt.Key_Left) { window.showModeActive = false; rotationTimer.dir = -1 }
            else if (event.key === Qt.Key_Right) { window.showModeActive = false; rotationTimer.dir = 1 }
            else if (event.key === Qt.Key_Up) { window.showModeActive = false; zoomTimer.dir = -1 }
            else if (event.key === Qt.Key_Down) { window.showModeActive = false; zoomTimer.dir = 1 }

            else if (window.showDebug) {
                let ch = getChannelForKey(event.key)
                if (ch !== -1) {
                    if (ch === 41 || ch === 35 || ch === 36) {
                        // Toggle for dance moves
                        let current = window.manualFrameData[ch]
                        setManualChannel(ch, current > 0 ? 0 : 255)
                    } else {
                        setManualChannel(ch, 255)
                    }
                }
            }
        }
        Keys.onReleased: (event) => {
            if (event.isAutoRepeat) return
            if (event.key === Qt.Key_Left || event.key === Qt.Key_Right) rotationTimer.dir = 0
            else if (event.key === Qt.Key_Up || event.key === Qt.Key_Down) zoomTimer.dir = 0
            else if (window.showDebug) {
                let ch = getChannelForKey(event.key)
                if (ch !== -1 && ch !== 41 && ch !== 35 && ch !== 36) setManualChannel(ch, 0)
            }
        }
        function getChannelForKey(key) {
            if (key >= Qt.Key_0 && key <= Qt.Key_9) return key - Qt.Key_0
            if (key === Qt.Key_Q) return 10; if (key === Qt.Key_W) return 11; if (key === Qt.Key_E) return 12; if (key === Qt.Key_R) return 13
            if (key === Qt.Key_T) return 14; if (key === Qt.Key_Y) return 15; if (key === Qt.Key_U) return 16; if (key === Qt.Key_I) return 17
            if (key === Qt.Key_O) return 18; if (key === Qt.Key_P) return 19; if (key === Qt.Key_A) return 20; if (key === Qt.Key_S) return 21
            if (key === Qt.Key_Z) return 22; if (key === Qt.Key_X) return 23; if (key === Qt.Key_G) return 24; if (key === Qt.Key_H) return 25
            if (key === Qt.Key_J) return 26; if (key === Qt.Key_K) return 27; if (key === Qt.Key_L) return 41; // Liftgate
            if (key === Qt.Key_Semicolon) return 29

            if (key === Qt.Key_C) return 30; if (key === Qt.Key_V) return 31; if (key === Qt.Key_B) return 32; if (key === Qt.Key_N) return 33
            if (key === Qt.Key_M) return 34; if (key === Qt.Key_Comma) return 35; // Left Mirror
            if (key === Qt.Key_Period) return 36; // Right Mirror
            if (key === Qt.Key_Slash) return 37
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

        // macOS Metal workaround: ExtendedSceneEnvironment glow is broken in Qt 6.11
        // Use HDRBloomTonemap effect instead
        environment: SceneEnvironment {
            clearColor: window.envBrightness > 0.5 ? "skyblue" : "#050505"
            backgroundMode: SceneEnvironment.Color
            antialiasingMode: SceneEnvironment.SSAA
            antialiasingQuality: SceneEnvironment.VeryHigh
            tonemapMode: SceneEnvironment.TonemapModeLinear

            // HDR Bloom effect for light glow
            effects: [
                HDRBloomTonemap {
                    gamma: 2.2
                    exposure: 0.5
                    bloomThreshold: 0.5
                    blurFalloff: 2
                    tonemappingLerp: 1.0
                }
            ]
        }
        PerspectiveCamera {
            id: camera
            position: Qt.vector3d(window.cameraX, window.cameraY, window.cameraZ)
            eulerRotation: Qt.vector3d(window.cameraPitch, window.cameraYaw, 0)
        }
        
        Node {
            id: carRotationNode
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
                baseColor: window.envBrightness > 0.5 ? "#888888" : "#080808"
                roughness: 1.0; metalness: 0.0; specularAmount: 0.0
            } ]
        }

        // --- Sun / Day Main Lighting ---
        DirectionalLight {
            id: sunLight
            eulerRotation: Qt.vector3d(-60, 45, 0)
            brightness: window.envBrightness > 0.5 ? 1.2 : 0.0
            color: "#ffffcc"
            castsShadow: true
            shadowMapQuality: DirectionalLight.ShadowMapQualityHigh
            shadowBias: 0.5
        }

        // --- Moon / Night Main Lighting ---
        DirectionalLight {
            id: moonLight
            eulerRotation: Qt.vector3d(-70, -45, 0)
            brightness: window.envBrightness > 0.5 ? 0.0 : 0.4
            color: "#aaaaff"
            castsShadow: true
            shadowMapQuality: DirectionalLight.ShadowMapQualityHigh
            shadowBias: 0.5
        }

        // Fill light - REDUCED TO 1 to stay under 4 DirectionalLight limit
        // This allows PointLights and SpotLights from car models to work!
        DirectionalLight {
            eulerRotation: Qt.vector3d(-45, 45, 0)
            brightness: window.envBrightness * 0.4
            color: "white"
        }
    }

    // --- OVERLAYS ---
    
    Column {
        anchors.centerIn: parent
        opacity: window.countdownValue > 0 ? 1.0 : 0.0
        visible: opacity > 0
        spacing: -10
        z: 500
        
        Behavior on opacity { NumberAnimation { duration: 500 } }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: window.countdownValue
            color: window.envBrightness > 0.5 ? "black" : "white"
            font.pixelSize: 120
            font.bold: true
            style: Text.Outline; styleColor: window.envBrightness > 0.5 ? "white" : "black"
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "seconds until showtime"
            color: window.envBrightness > 0.5 ? "black" : "white"
            font.pixelSize: 32
            font.bold: true
            style: Text.Outline; styleColor: window.envBrightness > 0.5 ? "white" : "black"
        }
    }

    MouseArea {
        anchors.fill: parent
        property real lastX: 0
        onPressed: (mouse) => { window.showModeActive = false; lastX = mouse.x; keyboardHandler.forceActiveFocus() }
        onPositionChanged: (mouse) => { let dx = mouse.x - lastX; window.carRotationZ += dx * 0.5; lastX = mouse.x }
        onWheel: (wheel) => { window.showModeActive = false; let zoomDelta = -wheel.angleDelta.y * 2; window.cameraZ = Math.max(1000, Math.min(5000, window.cameraZ + zoomDelta)) }
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
        width: 100; height: window.showModeActive ? 130 : 620
        color: "#66000000"; radius: 15; border.color: "#33ffffff"; z: 200
        clip: true
        
        Behavior on height { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }

        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 15
            Column {
                width: parent.width; spacing: 8
                
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: window.envBrightness > 0.5 ? "\u2600" : "\u263E" 
                    font.pixelSize: 24; width: 70; height: 50
                    visible: !window.showModeActive
                    onClicked: window.envBrightness = (window.envBrightness > 0.5 ? 0.4 : 1.0)
                }
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "\u21BA" // Reset icon
                    font.pixelSize: 24; width: 70; height: 50
                    visible: !window.showModeActive
                    onClicked: { 
                        window.showModeActive = false
                        window.carRotationZ = 315; window.cameraZ = 2200; window.cameraY = 400; window.cameraX = 0; window.cameraPitch = -15; window.cameraYaw = 0; window.envBrightness = 1.0 
                    }
                }
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: window.visibility === Window.FullScreen ? "\u25A3" : "\u26F6" 
                    font.pixelSize: 24; width: 70; height: 50
                    onClicked: window.visibility = (window.visibility === Window.FullScreen) ? Window.Windowed : Window.FullScreen
                }
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "\uD83C\uDFA5" // Movie camera icon
                    font.pixelSize: 24; width: 70; height: 50
                    highlighted: window.showModeActive
                    onClicked: window.showModeActive = !window.showModeActive
                }
            }

            Rectangle { width: parent.width - 20; height: 1; color: "#33ffffff"; anchors.horizontalCenter: parent.horizontalCenter; visible: !window.showModeActive }

            Column {
                width: parent.width; spacing: 8; visible: !window.showModeActive
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Model S"
                    font.pixelSize: 10; font.bold: true
                    width: 80; height: 40; flat: window.carType !== "ModelS"
                    highlighted: window.carType === "ModelS"
                    onClicked: window.carType = "ModelS"
                }
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Cybertruck"
                    font.pixelSize: 10; font.bold: true
                    width: 80; height: 40; flat: window.carType !== "Cybertruck"
                    highlighted: window.carType === "Cybertruck"
                    onClicked: window.carType = "Cybertruck"
                }
            }

            Rectangle { width: parent.width - 20; height: 1; color: "#33ffffff"; anchors.horizontalCenter: parent.horizontalCenter; visible: !window.showModeActive }

            Column {
                width: parent.width; spacing: 10; visible: !window.showModeActive
                Column {
                    width: parent.width; spacing: 2
                    Text { text: "ROT"; color: "white"; font.pixelSize: 10; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                    Slider { id: rotSlider; orientation: Qt.Vertical; from: 0; to: 360; value: window.carRotationZ % 360; height: 100; anchors.horizontalCenter: parent.horizontalCenter; onMoved: { window.showModeActive = false; window.carRotationZ = value } }
                }
                Column {
                    width: parent.width; spacing: 2
                    Text { text: "ZOOM"; color: "white"; font.pixelSize: 10; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                    Slider { id: zoomSlider; orientation: Qt.Vertical; from: 1000; to: 5000; value: window.cameraZ; height: 100; anchors.horizontalCenter: parent.horizontalCenter; onMoved: { window.showModeActive = false; window.cameraZ = value } }
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
        id: playbackPanel
        anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter; anchors.margins: 20
        width: window.showModeActive ? 400 : 900; height: window.showModeActive ? 75 : 100
        color: "#66000000"; radius: 15; border.color: "#33ffffff"; z: 230
        clip: true
        
        Behavior on width { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }
        Behavior on height { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }

        Column {
            anchors.centerIn: parent; spacing: window.showModeActive ? 4 : 8
            Row {
                anchors.horizontalCenter: parent.horizontalCenter; spacing: 15
                Button { 
                    text: sync.playing ? "\u23F8" : "\u25B6"
                    font.pixelSize: 20; width: 60; height: window.showModeActive ? 32 : 45
                    enabled: sync.showName !== "" && countdownValue <= 0
                    onClicked: { 
                        if (sync.playing) sync.pause(); 
                        else if (sync.position === 0) startShowWithCountdown();
                        else sync.play(); 
                        keyboardHandler.forceActiveFocus() 
                    }
                }
                Button { 
                    text: "\u25A0"
                    font.pixelSize: 20; width: 60; height: 45
                    enabled: sync.showName !== "" && !window.showModeActive
                    visible: !window.showModeActive
                    onClicked: { sync.stop(); sync.position = 0; keyboardHandler.forceActiveFocus() }
                }
                Button { 
                    text: "Load Show"; height: 45; width: 120; 
                    visible: !window.showModeActive
                    onClicked: { fileDialog.open(); keyboardHandler.forceActiveFocus() } 
                }
                
                Rectangle { width: 1; height: 35; color: "#33ffffff"; anchors.verticalCenter: parent.verticalCenter; visible: !window.showModeActive }

                CheckBox {
                    id: autoloadCheck
                    text: "Autoload previous"
                    height: 45; visible: !window.showModeActive
                    checked: appSettings.autoloadShow
                    onToggled: appSettings.autoloadShow = checked
                    indicator: Rectangle {
                        implicitWidth: 26; implicitHeight: 26; x: autoloadCheck.leftPadding; y: parent.height / 2 - height / 2; radius: 3; border.color: "#33ffffff"; color: "transparent"
                        Rectangle { width: 14; height: 14; x: 6; y: 6; radius: 2; color: "white"; visible: autoloadCheck.checked }
                    }
                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 14; color: "white"
                        verticalAlignment: Text.AlignVCenter; leftPadding: autoloadCheck.indicator.width + autoloadCheck.spacing
                    }
                }
            }
            Row {
                spacing: 15; anchors.horizontalCenter: parent.horizontalCenter
                Text { text: formatTime(sync.position); color: "white"; font.family: "Monospace"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter; opacity: sync.showName !== "" ? 1.0 : 0.3 }
                Slider { 
                    id: progressSlider; width: window.showModeActive ? 250 : 650; from: 0; to: sync.duration; value: sync.position; 
                    onMoved: sync.position = value; 
                    enabled: sync.showName !== "" && !window.showModeActive
                    opacity: window.showModeActive ? 0.5 : 1.0
                    Behavior on width { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }
                }
                Text { text: formatTime(sync.duration); color: "white"; font.family: "Monospace"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter; opacity: sync.showName !== "" ? 1.0 : 0.3 }
            }
        }
    }

    property var activeCar: carType === "ModelS" ? modelS : ct

    Item {
        anchors.fill: parent; visible: window.showDebug; z: 210
        // (Removed non-working 2D labels for 3D markers)
    }

    Rectangle {
        id: debugPanel; visible: window.showDebug; anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 320; color: "#cc000000"; z: 220
        Flickable {
            anchors.fill: parent; contentHeight: debugFlow.height; clip: true
            Column {
                id: debugFlow; width: parent.width; spacing: 2
                Repeater {
                    model: window.channelNames.length
                    Rectangle {
                        width: 310; height: 20; color: (sync.currentFrameData && sync.currentFrameData[index] > 0) ? "red" : "#333333"
                        Text { 
                            anchors.centerIn: parent
                            text: "[" + (window.keyHints[index] || "?") + "] " + index + ": " + (window.channelNames[index] || "Unknown") + " (" + (sync.currentFrameData ? (sync.currentFrameData[index] || 0) : 0) + ")"
                            color: "white"; font.pixelSize: 11 
                        }
                    }
                }
            }
        }
    }
}
