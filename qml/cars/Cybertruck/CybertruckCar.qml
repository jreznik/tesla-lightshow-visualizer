import QtQuick
import QtQuick3D
import "../../shaders"

Node {
    id: carRoot
    property var frameData: []
    property bool showDebug: false

    property var intensities: {
        let a = new Array(48)
        for (let i = 0; i < 48; i++) a[i] = 0.0
        return a
    }

    property var targets: new Array(48).fill(0.0)
    property var steps: new Array(48).fill(0.0)
    property var lastFseqValues: new Array(48).fill(-1)

    function getVal(idx) {
        if (!intensities || intensities.length <= idx) return 0;
        return intensities[idx];
    }

    onFrameDataChanged: {
        if (!frameData || frameData.length === 0) return;
        let nextTargets = Array.from(targets); let nextSteps = Array.from(steps);
        let nextIntensities = Array.from(intensities); let nextLastFseq = Array.from(lastFseqValues);
        let changed = false
        for (let i = 0; i < 48; i++) {
            let val = frameData[i] || 0
            if (val === nextLastFseq[i]) continue
            nextLastFseq[i] = val; changed = true
            let duration = 0; let target = 0.0
            if (val === 0) { target = 0.0; duration = (i === 41 ? 2000 : (i === 35 || i === 36 ? 1000 : 0)); }
            else if (val >= 25 && val <= 26) { target = 0.0; duration = 500; }
            else if (val === 51) { target = 0.0; duration = 1000; }
            else if (val >= 76 && val <= 77) { target = 0.0; duration = 2000; }
            else if (val >= 178 && val <= 179) { target = 1.0; duration = 500; }
            else if (val === 204) { target = 1.0; duration = 1000; }
            else if (val >= 229 && val <= 230) { target = 1.0; duration = 2000; }
            else if (val === 255) { target = 1.0; duration = (i === 41 ? 2000 : (i === 35 || i === 36 ? 1000 : 0)); }
            else { target = val / 255.0; duration = 0; }
            nextTargets[i] = target
            if (duration === 0) { nextIntensities[i] = target; nextSteps[i] = 0; }
            else { let totalSteps = duration / 16.0; nextSteps[i] = (target - nextIntensities[i]) / totalSteps; }
        }
        if (changed) { targets = nextTargets; steps = nextSteps; intensities = nextIntensities; lastFseqValues = nextLastFseq; }
    }

    Timer {
        interval: 16; running: true; repeat: true
        onTriggered: {
            let nextIntensities = Array.from(carRoot.intensities); let changed = false
            for (let i = 0; i < 48; i++) {
                if (carRoot.steps[i] !== 0) {
                    nextIntensities[i] += carRoot.steps[i]
                    if (carRoot.steps[i] > 0) { if (nextIntensities[i] >= carRoot.targets[i]) { nextIntensities[i] = carRoot.targets[i]; carRoot.steps[i] = 0; } }
                    else { if (nextIntensities[i] <= carRoot.targets[i]) { nextIntensities[i] = carRoot.targets[i]; carRoot.steps[i] = 0; } }
                    changed = true
                }
            }
            if (changed) carRoot.intensities = nextIntensities
        }
    }

    // Brushed Stainless Steel Look (Custom Shader)
    BrushedSteelMaterial {
        id: mat_Body
        baseColor: "#fafafa" // Very bright white silver/stainless steel
        metalness: 1.0
        roughness: 0.05 // Very shiny
        reflectivity: 0.7
        nightAlpha: window.envBrightness > 0.5 ? 1.0 : 1.0
        brushScale: 1500.0
        brushStrength: 0.015
    }
    PrincipledMaterial { id: mat_Black; baseColor: "#111111"; metalness: 0.2; roughness: 0.8 }
    // Non-transparent black tinted glass look
    PrincipledMaterial { id: mat_Glass; baseColor: "#020202"; roughness: 0.01; metalness: 0.1; specularAmount: 1.0; clearcoatAmount: 1.0; opacity: 1.0 }
    PrincipledMaterial { id: mat_Wheel; baseColor: "#111111"; metalness: 0.5; roughness: 0.5 }

    // Cybertruck specific light materials - Fixed to prevent glow when off
    PrincipledMaterial { id: mat_Front_Bar; lighting: PrincipledMaterial.NoLighting; baseColor: (getVal(4)>0||getVal(5)>0)?"white":"black"; emissiveFactor: Qt.vector3d(Math.max(getVal(4),getVal(5))*10, Math.max(getVal(4),getVal(5))*10, Math.max(getVal(4),getVal(5))*10) }
    PrincipledMaterial { id: mat_Main_Beam; lighting: PrincipledMaterial.NoLighting; baseColor: (getVal(0)>0||getVal(1)>0||getVal(2)>0||getVal(3)>0)?"white":"black"; emissiveFactor: Qt.vector3d(Math.max(getVal(0),getVal(1),getVal(2),getVal(3))*15, Math.max(getVal(0),getVal(1),getVal(2),getVal(3))*15, Math.max(getVal(0),getVal(1),getVal(2),getVal(3))*15) }
    PrincipledMaterial { id: mat_Offroad_Bar; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(6)>0?"white":"black"; emissiveFactor: Qt.vector3d(getVal(6)*20, getVal(6)*20, getVal(6)*20) }
    PrincipledMaterial { id: mat_Rear_Bar; lighting: PrincipledMaterial.NoLighting; baseColor: (getVal(24)>0||getVal(25)>0||getVal(26)>0)?"red":"black"; emissiveFactor: Qt.vector3d(Math.max(getVal(24),getVal(25),getVal(26))*15, 0, 0) }
    
    PrincipledMaterial { id: mat_L_Turn; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(12)>0?"orange":"black"; emissiveFactor: Qt.vector3d(getVal(12)*30, getVal(12)*12, 0) }
    PrincipledMaterial { id: mat_R_Turn; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(13)>0?"orange":"black"; emissiveFactor: Qt.vector3d(getVal(13)*30, getVal(13)*12, 0) }
    PrincipledMaterial { id: mat_Reverse; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(27)>0?"white":"black"; emissiveFactor: Qt.vector3d(getVal(27)*15, getVal(27)*15, getVal(27)*15) }
    PrincipledMaterial { id: mat_Bed_Light; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(27)>0?"white":"black"; emissiveFactor: Qt.vector3d(getVal(27)*5, getVal(27)*5, getVal(27)*5) }

    Component {
        id: beamComponent
        Node {
            property real intensity: 0; property real length: 15; property color col: "white"
            Model {
                source: "#Cone"; eulerRotation: Qt.vector3d(0, 0, 90) 
                x: length * 0.5 
                scale: Qt.vector3d(0.8, length, 0.8)
                materials: [ PrincipledMaterial { 
                    baseColor: "black"; lighting: PrincipledMaterial.NoLighting; opacity: intensity * 0.2
                    emissiveFactor: Qt.vector3d(col.r * intensity * 10, col.g * intensity * 10, col.b * intensity * 10)
                    alphaMode: PrincipledMaterial.Blend 
                } ]
            }
        }
    }

    Node {
        id: ctContainer
        // scale to match Model S footprint (1.76 to match, 2.11 to be 20% bigger)
        scale: Qt.vector3d(2.11, 2.11, 2.11)
        
        Node {
            id: geometryCorrection
            position: Qt.vector3d(0, 0.54, 0) // Shift bottom to 0

            Model { source: "meshes/body_mesh.mesh"; materials: [ mat_Body ]; castsShadows: true }
            Model { source: "meshes/wheels_mesh.mesh"; materials: [ mat_Wheel ]; castsShadows: true }
            Model { source: "meshes/windows_mesh.mesh"; materials: [ mat_Glass ]; castsShadows: true }
            Model { source: "meshes/lights_mesh.mesh"; materials: [ mat_Black ]; castsShadows: true }
            Model { source: "meshes/ct_Front_Bar_mesh.mesh"; materials: [ mat_Front_Bar ]; castsShadows: true }
            Model { source: "meshes/ct_Main_Beams_mesh.mesh"; materials: [ mat_Main_Beam ]; castsShadows: true }
            Model { source: "meshes/ct_Offroad_Bar_mesh.mesh"; materials: [ mat_Offroad_Bar ]; castsShadows: true }
            Model { source: "meshes/ct_Rear_Bar_mesh.mesh"; materials: [ mat_Rear_Bar ]; castsShadows: true }

            // --- ANIMATED PARTS ---
            // Folding Mirrors (Channels 35 Left, 36 Right)
            Node {
                id: mirrorLNode
                position: Qt.vector3d(215, 120, -90) // Pivot at door attachment
                eulerRotation: Qt.vector3d(0, getVal(35) * 15, 0)
                Model {
                    source: "meshes/ct_Mirror_L_mesh.mesh"
                    position: Qt.vector3d(-215, -120, 90) // Re-center
                    materials: [ mat_Glass ] // Using glass material
                    castsShadows: true
                }
            }
            Node {
                id: mirrorRNode
                position: Qt.vector3d(215, 120, 90) // Pivot at door attachment
                eulerRotation: Qt.vector3d(0, getVal(36) * -15, 0)
                Model {
                    source: "meshes/ct_Mirror_R_mesh.mesh"
                    position: Qt.vector3d(-215, -120, -90) // Re-center
                    materials: [ mat_Glass ]
                    castsShadows: true
                }
            }

            // --- Front Light Effects ---
            // Main Beam (Channel 0/1)
            Loader { sourceComponent: beamComponent; x: 280; y: 100; z: -110; onLoaded: { item.intensity = Qt.binding(function(){ return getVal(0) }); item.length = 200 } } 
            Loader { sourceComponent: beamComponent; x: 280; y: 100; z: 110; onLoaded: { item.intensity = Qt.binding(function(){ return getVal(1) }); item.length = 200 } } 
            SpotLight { position: Qt.vector3d(280, 100, -110); eulerRotation: Qt.vector3d(0, -90, 0); brightness: getVal(0)*15000; coneAngle: 40; color: "white" }
            SpotLight { position: Qt.vector3d(280, 100, 110); eulerRotation: Qt.vector3d(0, -90, 0); brightness: getVal(1)*15000; coneAngle: 40; color: "white" }

            // Offroad Light (Channel 6)
            Loader { sourceComponent: beamComponent; x: 100; y: 180; z: 0; onLoaded: { item.intensity = Qt.binding(function(){ return getVal(6) }); item.length = 250 } } 
            SpotLight { position: Qt.vector3d(100, 180, 0); eulerRotation: Qt.vector3d(0, -90, 0); brightness: getVal(6)*25000; coneAngle: 30; color: "white" }

            // Turn Signals (Channel 12/13)
            PointLight { position: Qt.vector3d(285, 100, -130); brightness: getVal(12)*5000; color: "orange" }
            PointLight { position: Qt.vector3d(285, 100, 130); brightness: getVal(13)*5000; color: "orange" }

            // --- Rear Light Effects ---
            // Brake/Tail (Channel 24/25/26)
            PointLight { position: Qt.vector3d(-265, 68, 0); brightness: Math.max(getVal(24), getVal(25), getVal(26))*8000; color: "red" }

            // Reverse Lights (Channel 27)
            PointLight { position: Qt.vector3d(-260, 68, -100); brightness: getVal(27)*4000; color: "white" }
            PointLight { position: Qt.vector3d(-260, 68, 100); brightness: getVal(27)*4000; color: "white" }

            // Cabin light for night visibility (Reduced for consistency)
            PointLight { 
                position: Qt.vector3d(-50, 140, 0)
                brightness: window.envBrightness > 0.5 ? 0.0 : 150.0
                color: "#e0e0ff"
                linearFade: 1.0
            }
        }
    }

    readonly property var markerModel: [
        // Front Beams
        { ch: 0, pos: Qt.vector3d(280, 100, -110), c: "white" }, { ch: 1, pos: Qt.vector3d(280, 100, 110), c: "white" },
        { ch: 2, pos: Qt.vector3d(280, 100, -80), c: "white" }, { ch: 3, pos: Qt.vector3d(280, 100, 80), c: "white" },
        // Front Signature Bar Segments
        { ch: 4, pos: Qt.vector3d(280, 115, -60), c: "white" }, { ch: 5, pos: Qt.vector3d(280, 115, 60), c: "white" },
        { ch: 6, pos: Qt.vector3d(280, 115, -40), c: "white" }, { ch: 7, pos: Qt.vector3d(280, 115, 40), c: "white" },
        { ch: 8, pos: Qt.vector3d(280, 115, -20), c: "white" }, { ch: 9, pos: Qt.vector3d(280, 115, 20), c: "white" },
        { ch: 10, pos: Qt.vector3d(280, 115, -5), c: "white" }, { ch: 11, pos: Qt.vector3d(280, 115, 5), c: "white" },
        // Turn / Fog / Park
        { ch: 12, pos: Qt.vector3d(285, 105, -130), c: "orange" }, { ch: 13, pos: Qt.vector3d(285, 105, 130), c: "orange" },
        { ch: 14, pos: Qt.vector3d(280, 70, -100), c: "white" }, { ch: 15, pos: Qt.vector3d(280, 70, 100), c: "white" },
        { ch: 16, pos: Qt.vector3d(200, 110, 0), c: "white" }, // Aux Park (Frunk)
        { ch: 18, pos: Qt.vector3d(280, 110, -140), c: "orange" }, { ch: 19, pos: Qt.vector3d(280, 110, 140), c: "orange" }, // Side Markers
        // Side Repeaters
        { ch: 20, pos: Qt.vector3d(100, 120, -110), c: "orange" }, { ch: 21, pos: Qt.vector3d(100, 120, 110), c: "orange" },
        // Rear
        { ch: 22, pos: Qt.vector3d(-260, 75, -100), c: "orange" }, { ch: 23, pos: Qt.vector3d(-260, 75, 100), c: "orange" }, // Rear Turn
        { ch: 24, pos: Qt.vector3d(-265, 68, 0), c: "red" }, // Brake
        { ch: 25, pos: Qt.vector3d(-260, 68, -80), c: "red" }, { ch: 26, pos: Qt.vector3d(-260, 68, 80), c: "red" }, // Tail
        { ch: 27, pos: Qt.vector3d(-260, 60, 0), c: "white" }, // Reverse
        { ch: 28, pos: Qt.vector3d(-260, 50, 0), c: "red" }, // Rear Fog
        { ch: 29, pos: Qt.vector3d(-260, 40, 0), c: "white" }, // License
        { ch: 35, pos: Qt.vector3d(215, 120, -90), c: "white" }, // L Mirror
        { ch: 36, pos: Qt.vector3d(215, 120, 90), c: "white" }   // R Mirror
    ]


    Node {
        id: markers; visible: carRoot.showDebug
        Repeater3D {
            model: carRoot.markerModel
            Node {
                position: Qt.vector3d(modelData.pos.x * 2.11, (modelData.pos.y + 0.54) * 2.11, modelData.pos.z * 2.11)
                Model { source: "#Sphere"; scale: Qt.vector3d(0.1, 0.1, 0.1); materials: [ PrincipledMaterial { baseColor: getVal(modelData.ch) > 0 ? modelData.c : "gray"; emissiveFactor: getVal(modelData.ch) > 0 ? Qt.vector3d(2,2,2) : Qt.vector3d(0,0,0); lighting: PrincipledMaterial.NoLighting } ] }
                Model { source: "#Cube"; y: 40; scale: Qt.vector3d(0.05, 0.05, 0.05); materials: [ PrincipledMaterial { baseColor: "white"; lighting: PrincipledMaterial.NoLighting } ] }
            }
        }
    }
}
