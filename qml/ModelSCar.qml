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

    PrincipledMaterial { id: mat_Red; baseColor: "red"; metalness: 0.8; roughness: 0.2 }
    PrincipledMaterial { id: mat_Black; baseColor: "black"; metalness: 0.2; roughness: 0.8 }
    // Non-transparent black tinted glass look
    PrincipledMaterial { id: mat_Glass; baseColor: "#050505"; roughness: 0.05; metalness: 0.0; specularAmount: 1.0; clearcoatAmount: 1.0; opacity: 1.0 }
    PrincipledMaterial { id: mat_Wheel; baseColor: "#111111"; metalness: 0.5; roughness: 0.5 }

    PrincipledMaterial { id: mat_L_Outer; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(0)>0?"white":"#222222"; emissiveFactor: Qt.vector3d(getVal(0)*2, getVal(0)*2, getVal(0)*2) }
    PrincipledMaterial { id: mat_R_Outer; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(1)>0?"white":"#222222"; emissiveFactor: Qt.vector3d(getVal(1)*2, getVal(1)*2, getVal(1)*2) }
    PrincipledMaterial { id: mat_L_Inner; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(2)>0?"white":"#222222"; emissiveFactor: Qt.vector3d(getVal(2)*2, getVal(2)*2, getVal(2)*2) }
    PrincipledMaterial { id: mat_R_Inner; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(3)>0?"white":"#222222"; emissiveFactor: Qt.vector3d(getVal(3)*2, getVal(3)*2, getVal(3)*2) }
    PrincipledMaterial { id: mat_L_Sig; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(4)>0?"white":"#222222"; emissiveFactor: Qt.vector3d(getVal(4)*0.5, getVal(4)*0.5, getVal(4)) }
    PrincipledMaterial { id: mat_R_Sig; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(5)>0?"white":"#222222"; emissiveFactor: Qt.vector3d(getVal(5)*0.5, getVal(5)*0.5, getVal(5)) }
    PrincipledMaterial { id: mat_L_Turn; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(12)>0?"orange":"#221100"; emissiveFactor: Qt.vector3d(getVal(12)*30, getVal(12)*12, 0) }
    PrincipledMaterial { id: mat_R_Turn; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(13)>0?"orange":"#221100"; emissiveFactor: Qt.vector3d(getVal(13)*30, getVal(13)*12, 0) }
    PrincipledMaterial { id: mat_L_Fog; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(14)>0?"white":"#222222"; emissiveFactor: Qt.vector3d(getVal(14)*10, getVal(14)*10, getVal(14)*10) }
    PrincipledMaterial { id: mat_R_Fog; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(15)>0?"white":"#222222"; emissiveFactor: Qt.vector3d(getVal(15)*10, getVal(15)*10, getVal(15)*10) }

    PrincipledMaterial { id: mat_Rear_Tail; lighting: PrincipledMaterial.NoLighting; baseColor: (getVal(25)>0||getVal(26)>0)?"red":"#330000"; emissiveFactor: Qt.vector3d(Math.max(getVal(25),getVal(26))*5, 0, 0) }
    PrincipledMaterial { id: mat_Rear_Brake; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(24)>0?"red":"#330000"; emissiveFactor: Qt.vector3d(getVal(24)*20, 0, 0) }
    PrincipledMaterial { id: mat_Rear_Turn; lighting: PrincipledMaterial.NoLighting; baseColor: (getVal(22)>0||getVal(23)>0)?"orange":"#221100"; emissiveFactor: Qt.vector3d(Math.max(getVal(22),getVal(23))*20, Math.max(getVal(22),getVal(23))*8, 0) }
    PrincipledMaterial { id: mat_Rear_Reverse; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(27)>0?"white":"#222222"; emissiveFactor: Qt.vector3d(getVal(27)*10, getVal(27)*10, getVal(27)*10) }
    PrincipledMaterial { id: mat_Rear_Fog; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(28)>0?"red":"#330000"; emissiveFactor: Qt.vector3d(getVal(28)*10, 0, 0) }

    PrincipledMaterial { id: mat_L_Repeat; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(20)>0?"orange":"black"; emissiveFactor: Qt.vector3d(getVal(20)*30, getVal(20)*12, 0) }
    PrincipledMaterial { id: mat_R_Repeat; lighting: PrincipledMaterial.NoLighting; baseColor: getVal(21)>0?"orange":"black"; emissiveFactor: Qt.vector3d(getVal(21)*30, getVal(21)*12, 0) }

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
        id: geometryCorrection
        position: Qt.vector3d(-10.7, 1.57, 0)

        Model { id: bodyModel; source: "meshes/ModelS/body_mesh.mesh"; materials: [ mat_Red, mat_Red, mat_Red, mat_Red, mat_Red, mat_Black, mat_Red, mat_Red, mat_Red, mat_Red, mat_Red, mat_Black, mat_Red, mat_Red, mat_Black, mat_Red ] }
        Model { id: wheelsModel; source: "meshes/ModelS/wheels_mesh.mesh"; materials: [ mat_Wheel, mat_Wheel, mat_Wheel, mat_Wheel, mat_Wheel, mat_Wheel, mat_Wheel, mat_Wheel, mat_Wheel ] }
        Model { id: topGlassModel; source: "meshes/ModelS/windows_Top_mesh.mesh"; materials: [ mat_Glass ] }
        
        Model { source: "meshes/ModelS/front_Outer_L_mesh.mesh"; materials: [ mat_L_Outer ] }
        Model { source: "meshes/ModelS/front_Outer_R_mesh.mesh"; materials: [ mat_R_Outer ] }
        Model { source: "meshes/ModelS/front_Inner_L_mesh.mesh"; materials: [ mat_L_Inner ] }
        Model { source: "meshes/ModelS/front_Inner_R_mesh.mesh"; materials: [ mat_R_Inner ] }
        Model { source: "meshes/ModelS/front_Sig_L_mesh.mesh"; materials: [ mat_L_Sig ] }
        Model { source: "meshes/ModelS/front_Sig_R_mesh.mesh"; materials: [ mat_R_Sig ] }
        Model { source: "meshes/ModelS/front_Turn_L_mesh.mesh"; materials: [ mat_L_Turn ] }
        Model { source: "meshes/ModelS/front_Turn_R_mesh.mesh"; materials: [ mat_R_Turn ] }
        Model { source: "meshes/ModelS/front_Fog_L_mesh.mesh"; materials: [ mat_L_Fog ] }
        Model { source: "meshes/ModelS/front_Fog_R_mesh.mesh"; materials: [ mat_R_Fog ] }
        Model { source: "meshes/ModelS/rear_Tail_L_mesh.mesh"; materials: [ mat_Rear_Tail ] }
        Model { source: "meshes/ModelS/rear_Tail_R_mesh.mesh"; materials: [ mat_Rear_Tail ] }
        Model { source: "meshes/ModelS/rear_Brake_L_mesh.mesh"; materials: [ mat_Rear_Brake ] }
        Model { source: "meshes/ModelS/rear_Brake_R_mesh.mesh"; materials: [ mat_Rear_Brake ] }
        Model { id: doorLFModel; source: "meshes/ModelS/door_LF_mesh.mesh"; materials: [ mat_Glass, mat_Red, mat_Black, mat_Red, mat_Black, mat_Red, mat_Black, mat_Red, mat_Black, mat_Red, mat_Red, mat_Red, mat_Black, mat_Red, mat_Red, mat_Black, mat_Red, mat_Red, mat_Red ] }
        Model { id: doorRFModel; source: "meshes/ModelS/door_RF_mesh.mesh"; materials: [ mat_Glass, mat_Red, mat_Black, mat_Red, mat_Red, mat_Black, mat_Red, mat_Black, mat_Red, mat_Black, mat_Red, mat_Red, mat_Red, mat_Black, mat_Red ] }
        Model { id: doorLRModel; source: "meshes/ModelS/door_LR_mesh.mesh"; materials: [ mat_Red, mat_Black, mat_Red, mat_Black, mat_Red, mat_Black, mat_Red, mat_Black, mat_Red, mat_Red, mat_Red, mat_Black, mat_Red, mat_Red, mat_Red ] }
        Model { id: doorRRModel; source: "meshes/ModelS/door_RR_mesh.mesh"; materials: [ mat_Red, mat_Black, mat_Red, Math.max(getVal(22),getVal(23))*10, mat_Black, mat_Red, mat_Black, mat_Red, mat_Black, mat_Red, mat_Red, mat_Red, mat_Black, mat_Red, mat_Red, mat_Red ] }
        Model { id: hoodModel; source: "meshes/ModelS/hood_mesh.mesh"; materials: [ mat_Red ] }
        Model { id: trunkModel; source: "meshes/ModelS/trunk_mesh.mesh"; materials: [ mat_Red, mat_Black, mat_Red, mat_Red, mat_Black, mat_Red, mat_Black, mat_Red, mat_Black, mat_Red, mat_Red, mat_Red, mat_Red, mat_Red, mat_Red, mat_Red, mat_Red, mat_Red, mat_Red, mat_Red, mat_Red, mat_Black, mat_Red, mat_Red, mat_Black, mat_Red, mat_Red, mat_Black, mat_Red, mat_Red, mat_Black, mat_Red, mat_Black, mat_Red, mat_Black, mat_Red, mat_Red, mat_Red, mat_Red, mat_Red, mat_Red, mat_Red, mat_Red, mat_Red, mat_Red, mat_Red, mat_Red, mat_Black, mat_Red, mat_Red, mat_Black, mat_Red ] }
        Model { id: spoilerModel; source: "meshes/ModelS/spoiler_mesh.mesh"; materials: [ mat_Black ] }
        Model { id: windowLFModel; source: "meshes/ModelS/window_LF_mesh.mesh"; materials: [ mat_Glass ] }
        Model { id: windowRFModel; source: "meshes/ModelS/window_RF_mesh.mesh"; materials: [ mat_Glass ] }
        Model { id: windowLRModel; source: "meshes/ModelS/window_LR_mesh.mesh"; materials: [ mat_Glass ] }
        Model { id: windowRRModel; source: "meshes/ModelS/window_RR_mesh.mesh"; materials: [ mat_Glass ] }
        Model { id: chargeCapModel; source: "meshes/ModelS/charge_Cap_mesh.mesh"; materials: [ mat_Red ] }
        
        Model { id: physicalRepeaterL; source: "meshes/ModelS/side_Repeater_L_mesh.mesh"; materials: [ mat_L_Repeat ] }
        Model { id: physicalRepeaterR; source: "meshes/ModelS/side_Repeater_R_mesh.mesh"; materials: [ mat_R_Repeat ] }

        Loader { sourceComponent: beamComponent; x: 482; y: 120; z: -180; onLoaded: { item.intensity = Qt.binding(function(){ return getVal(0) }); item.length = 150; item.col = "white" } } 
        Loader { sourceComponent: beamComponent; x: 482; y: 120; z: 180; onLoaded: { item.intensity = Qt.binding(function(){ return getVal(1) }); item.length = 150; item.col = "white" } } 
        Loader { sourceComponent: beamComponent; x: 472; y: 120; z: -140; onLoaded: { item.intensity = Qt.binding(function(){ return getVal(2) }); item.length = 300; item.col = "white" } } 
        Loader { sourceComponent: beamComponent; x: 472; y: 120; z: 140; onLoaded: { item.intensity = Qt.binding(function(){ return getVal(3) }); item.length = 300; item.col = "white" } } 

        Loader { sourceComponent: beamComponent; x: 255; y: 155; z: -195; onLoaded: { item.intensity = Qt.binding(function(){ return getVal(20) }); item.length = 20; item.col = "orange" } }
        Loader { sourceComponent: beamComponent; x: 255; y: 155; z: 195; onLoaded: { item.intensity = Qt.binding(function(){ return getVal(21) }); item.length = 20; item.col = "orange" } }

        SpotLight { position: Qt.vector3d(482, 120, -180); eulerRotation: Qt.vector3d(0, -90, 0); brightness: getVal(0)*10000; coneAngle: 30; color: "white" }
        SpotLight { position: Qt.vector3d(482, 120, 180); eulerRotation: Qt.vector3d(0, -90, 0); brightness: getVal(1)*10000; coneAngle: 30; color: "white" }
        SpotLight { position: Qt.vector3d(472, 120, -140); eulerRotation: Qt.vector3d(0, -90, 0); brightness: getVal(2)*20000; coneAngle: 15; color: "white" }
        SpotLight { position: Qt.vector3d(472, 120, 140); eulerRotation: Qt.vector3d(0, -90, 0); brightness: getVal(3)*20000; coneAngle: 15; color: "white" }
        
        PointLight { position: Qt.vector3d(480, 150, -210); brightness: getVal(12)*600; color: "orange" }
        PointLight { position: Qt.vector3d(480, 150, 210); brightness: getVal(13)*600; color: "orange" }
        PointLight { position: Qt.vector3d(-500, 150, 0); brightness: getVal(24)*3750; color: "red" }
    }

    readonly property var markerModel: [
        { ch: 0, pos: Qt.vector3d(500, 120, -180), c: "white" }, { ch: 1, pos: Qt.vector3d(500, 120, 180), c: "white" },
        { ch: 2, pos: Qt.vector3d(490, 120, -140), c: "white" }, { ch: 3, pos: Qt.vector3d(490, 120, 140), c: "white" },
        { ch: 12, pos: Qt.vector3d(480, 150, -210), c: "orange" }, { ch: 13, pos: Qt.vector3d(480, 150, 210), c: "orange" },
        { ch: 24, pos: Qt.vector3d(-500, 160, 0), c: "red" }
    ]

    Node {
        id: markers; visible: carRoot.showDebug
        Repeater3D {
            model: carRoot.markerModel
            Node {
                position: Qt.vector3d(modelData.pos.x - 10.7, modelData.pos.y + 1.57, modelData.pos.z)
                Model { source: "#Sphere"; scale: Qt.vector3d(0.1, 0.1, 0.1); materials: [ PrincipledMaterial { baseColor: getVal(modelData.ch) > 0 ? modelData.c : "gray"; emissiveFactor: getVal(modelData.ch) > 0 ? Qt.vector3d(2,2,2) : Qt.vector3d(0,0,0); lighting: PrincipledMaterial.NoLighting } ] }
                Model { source: "#Cube"; y: 40; scale: Qt.vector3d(0.05, 0.05, 0.05); materials: [ PrincipledMaterial { baseColor: "white"; lighting: PrincipledMaterial.NoLighting } ] }
            }
        }
    }
}
