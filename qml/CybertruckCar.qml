import QtQuick
import QtQuick3D

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
            if (val === 0) { target = 0.0; duration = 0; }
            else if (val >= 25 && val <= 26) { target = 0.0; duration = 500; }
            else if (val === 51) { target = 0.0; duration = 1000; }
            else if (val >= 76 && val <= 77) { target = 0.0; duration = 2000; }
            else if (val >= 178 && val <= 179) { target = 1.0; duration = 500; }
            else if (val === 204) { target = 1.0; duration = 1000; }
            else if (val >= 229 && val <= 230) { target = 1.0; duration = 2000; }
            else if (val === 255) { target = 1.0; duration = 0; }
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

    PrincipledMaterial { id: mat_Body; baseColor: "#888888"; metalness: 0.9; roughness: 0.1 }
    PrincipledMaterial { id: mat_Black; baseColor: "black"; metalness: 0.2; roughness: 0.8 }
    PrincipledMaterial { id: mat_Glass; baseColor: "#050505"; opacity: 0.9; metalness: 0.9; roughness: 0.1; alphaMode: PrincipledMaterial.Blend }
    PrincipledMaterial { id: mat_Wheel; baseColor: "#111111"; metalness: 0.5; roughness: 0.5 }

    PrincipledMaterial { id: mat_Front_Bar; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(0)>0?"white":"#222222"; emissiveFactor: Qt.vector3d(getVal(0)*5, getVal(0)*5, getVal(0)*5) }
    PrincipledMaterial { id: mat_Offroad_Bar; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(6)>0?"white":"#222222"; emissiveFactor: Qt.vector3d(getVal(6)*10, getVal(6)*10, getVal(6)*10) }
    PrincipledMaterial { id: mat_Rear_Bar; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(24)>0?"red":"#330000"; emissiveFactor: Qt.vector3d(getVal(24)*10, 0, 0) }

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
        id: modelContainer
        Model { source: "meshes/Cybertruck/body_mesh.mesh"; materials: [ mat_Body ] }
        Model { source: "meshes/Cybertruck/wheels_mesh.mesh"; materials: [ mat_Wheel ] }
        Model { source: "meshes/Cybertruck/windows_mesh.mesh"; materials: [ mat_Glass ] }
        Model { source: "meshes/Cybertruck/lights_mesh.mesh"; materials: [ mat_Black ] }
        
        Model { source: "meshes/Cybertruck/ct_Front_Bar_mesh.mesh"; materials: [ mat_Front_Bar ] }
        Model { source: "meshes/Cybertruck/ct_Offroad_Bar_mesh.mesh"; materials: [ mat_Offroad_Bar ] }
        Model { source: "meshes/Cybertruck/ct_Rear_Bar_mesh.mesh"; materials: [ mat_Rear_Bar ] }

        Loader { sourceComponent: beamComponent; x: 280; y: 100; z: 0; onLoaded: { item.intensity = Qt.binding(function(){ return getVal(0) }); item.length = 200 } } 
        Loader { sourceComponent: beamComponent; x: 100; y: 180; z: 0; onLoaded: { item.intensity = Qt.binding(function(){ return getVal(6) }); item.length = 250 } } 

        SpotLight { position: Qt.vector3d(280, 100, 0); eulerRotation: Qt.vector3d(0, -90, 0); brightness: getVal(0)*15000; coneAngle: 40; color: "white" }
        SpotLight { position: Qt.vector3d(100, 180, 0); eulerRotation: Qt.vector3d(0, -90, 0); brightness: getVal(6)*25000; coneAngle: 30; color: "white" }
        PointLight { position: Qt.vector3d(-265, 68, 0); brightness: getVal(24)*5000; color: "red" }
    }

    readonly property var markerModel: [
        { ch: 0, pos: Qt.vector3d(280, 100, 0), c: "white" },
        { ch: 6, pos: Qt.vector3d(100, 180, 0), c: "white" },
        { ch: 24, pos: Qt.vector3d(-265, 68, 0), c: "red" }
    ]

    Node {
        id: markers; visible: carRoot.showDebug
        Repeater3D {
            model: carRoot.markerModel
            Node {
                x: modelData.pos.x; y: modelData.pos.y; z: modelData.pos.z
                Model { source: "#Sphere"; scale: Qt.vector3d(0.1, 0.1, 0.1); materials: [ PrincipledMaterial { baseColor: getVal(modelData.ch) > 0 ? modelData.c : "gray"; emissiveFactor: getVal(modelData.ch) > 0 ? Qt.vector3d(2,2,2) : Qt.vector3d(0,0,0); lighting: PrincipledMaterial.NoLighting } ] }
                Model { source: "#Cube"; y: 40; scale: Qt.vector3d(0.05, 0.05, 0.05); materials: [ PrincipledMaterial { baseColor: "white"; lighting: PrincipledMaterial.NoLighting } ] }
            }
        }
    }
}
