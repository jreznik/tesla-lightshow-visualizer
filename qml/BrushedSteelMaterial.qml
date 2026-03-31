import QtQuick
import QtQuick3D

CustomMaterial {
    property color baseColor: "#d1d1d1"
    property real roughness: 0.2
    property real metalness: 1.0
    property real brushScale: 500.0
    property real brushStrength: 0.1
    property real brushFlow: 0.005
    property real reflectivity: 0.5

    shadingMode: CustomMaterial.Shaded
    fragmentShader: "brushed_steel.frag"
}
