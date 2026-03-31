import QtQuick
import QtQuick3D

Node {
    id: node

    // Resources
    Texture {
        id: lights_Red_AO_png_texture
        objectName: "Lights_Red_AO.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Lights_Red_AO.png"
    }
    Texture {
        id: exterior_AO_Dark_png_texture
        objectName: "Exterior_AO_Dark.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Exterior_AO_Dark.png"
    }
    Texture {
        id: exterior_AO_png_texture
        objectName: "Exterior_AO.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Exterior_AO.png"
    }
    Texture {
        id: lights_AO_png_texture
        objectName: "Lights_AO.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Lights_AO.png"
    }
    Texture {
        id: arachnid_Wheel_AO_png_texture
        objectName: "Arachnid_Wheel_AO.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Arachnid_Wheel_AO.png"
    }
    PrincipledMaterial {
        id: bodySG4_material
        objectName: "BodySG4"
        baseColor: "#ff000000"
        baseColorMap: lights_Red_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: bodySG3_material
        objectName: "BodySG3"
        baseColor: "#ff000000"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: lightsSG_Front_Turn_L_material
        objectName: "LightsSG_Front_Turn_L"
        baseColor: "#ff000000"
        baseColorMap: lights_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: lightsSG_Front_Fog_L_material
        objectName: "LightsSG_Front_Fog_L"
        baseColor: "#ff000000"
        baseColorMap: lights_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: lightsSG_Front_Sig_L_material
        objectName: "LightsSG_Front_Sig_L"
        baseColor: "#ff000000"
        baseColorMap: lights_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: lightsSG_Front_Outer_L_material
        objectName: "LightsSG_Front_Outer_L"
        baseColor: "#ff000000"
        baseColorMap: lights_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: lightsSG_Front_Inner_L_material
        objectName: "LightsSG_Front_Inner_L"
        baseColor: "#ff000000"
        baseColorMap: lights_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: lightsSG_Rear_Other_L_material
        objectName: "LightsSG_Rear_Other_L"
        baseColor: "#ff000000"
        baseColorMap: lights_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: lightsSG_Rear_Tail_L_material
        objectName: "LightsSG_Rear_Tail_L"
        baseColor: "#ff000000"
        baseColorMap: lights_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: windows_TopSG_material
        objectName: "Windows_TopSG"
        baseColor: "#ff999999"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: bodySG2_material
        objectName: "BodySG2"
        baseColor: "#ff000000"
        baseColorMap: exterior_AO_Dark_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: bodySG1_material
        objectName: "BodySG1"
        baseColor: "#ff000000"
        baseColorMap: exterior_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: arachnid21_Wheel_LFSG_material
        objectName: "Arachnid21_Wheel_LFSG"
        baseColor: "#ff000000"
        baseColorMap: arachnid_Wheel_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: arachnid21_Wheel_LFSG1_material
        objectName: "Arachnid21_Wheel_LFSG1"
        baseColor: "#ff0f0f0f"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: bodySG_material
        objectName: "BodySG"
        baseColor: "#ff000000"
        baseColorMap: exterior_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: lightsSG_Rear_Tail_R_material
        objectName: "LightsSG_Rear_Tail_R"
        baseColor: "#ff000000"
        baseColorMap: lights_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: lightsSG_Rear_Brake_R_material
        objectName: "LightsSG_Rear_Brake_R"
        baseColor: "#ff000000"
        baseColorMap: lights_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: lightsSG_Rear_Brake_L_material
        objectName: "LightsSG_Rear_Brake_L"
        baseColor: "#ff000000"
        baseColorMap: lights_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: lightsSG_Rear_Other_R_material
        objectName: "LightsSG_Rear_Other_R"
        baseColor: "#ff000000"
        baseColorMap: lights_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: lightsSG_Front_Inner_R_material
        objectName: "LightsSG_Front_Inner_R"
        baseColor: "#ff000000"
        baseColorMap: lights_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: lightsSG_Front_Outer_R_material
        objectName: "LightsSG_Front_Outer_R"
        baseColor: "#ff000000"
        baseColorMap: lights_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: lightsSG_Front_Sig_R_material
        objectName: "LightsSG_Front_Sig_R"
        baseColor: "#ff000000"
        baseColorMap: lights_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: lightsSG_Front_Fog_R_material
        objectName: "LightsSG_Front_Fog_R"
        baseColor: "#ff000000"
        baseColorMap: lights_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: lightsSG_Front_Turn_R_material
        objectName: "LightsSG_Front_Turn_R"
        baseColor: "#ff000000"
        baseColorMap: lights_AO_png_texture
        indexOfRefraction: 1
    }

    // Nodes:
    Node {
        id: modelS_obj
        objectName: "ModelS.obj"
        Node {
            id: default_
            objectName: "default"
        }
        Model {
            id: spoiler
            objectName: "Spoiler"
            source: "meshes/spoiler_mesh.mesh"
            materials: [
                bodySG2_material
            ]
        }
        Node {
            id: default_7
            objectName: "default"
        }
        Model {
            id: hood_Hinge_1
            objectName: "Hood_Hinge_1"
            source: "meshes/hood_Hinge_1_mesh.mesh"
            materials: [
                bodySG1_material
            ]
        }
        Node {
            id: default_12
            objectName: "default"
        }
        Model {
            id: hood_Hinge_2
            objectName: "Hood_Hinge_2"
            source: "meshes/hood_Hinge_2_mesh.mesh"
            materials: [
                bodySG1_material
            ]
        }
        Node {
            id: default_15
            objectName: "default"
        }
        Model {
            id: wheels
            objectName: "Wheels"
            source: "meshes/wheels_mesh.mesh"
            materials: [
                arachnid21_Wheel_LFSG_material,
                arachnid21_Wheel_LFSG1_material,
                arachnid21_Wheel_LFSG_material,
                arachnid21_Wheel_LFSG1_material,
                arachnid21_Wheel_LFSG_material,
                arachnid21_Wheel_LFSG1_material,
                arachnid21_Wheel_LFSG_material,
                arachnid21_Wheel_LFSG1_material,
                arachnid21_Wheel_LFSG_material
            ]
        }
        Node {
            id: default_21
            objectName: "default"
        }
        Model {
            id: door_LF_Mirror
            objectName: "Door_LF_Mirror"
            source: "meshes/door_LF_Mirror_mesh.mesh"
            materials: [
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material,
                bodySG2_material,
                bodySG1_material
            ]
        }
        Node {
            id: default_25
            objectName: "default"
        }
        Model {
            id: hood
            objectName: "Hood"
            source: "meshes/hood_mesh.mesh"
            materials: [
                bodySG1_material
            ]
        }
        Node {
            id: default_28
            objectName: "default"
        }
        Node {
            id: lights
            objectName: "Lights"
        }
        Model {
            id: rear_Tail_R
            objectName: "Rear_Tail_R"
            source: "meshes/rear_Tail_R_mesh.mesh"
            materials: [
                lightsSG_Rear_Tail_R_material
            ]
        }
        Model {
            id: rear_Brake_R
            objectName: "Rear_Brake_R"
            source: "meshes/rear_Brake_R_mesh.mesh"
            materials: [
                lightsSG_Rear_Brake_R_material
            ]
        }
        Model {
            id: rear_Other_R
            objectName: "Rear_Other_R"
            source: "meshes/rear_Other_R_mesh.mesh"
            materials: [
                lightsSG_Rear_Other_R_material
            ]
        }
        Model {
            id: front_Inner_R
            objectName: "Front_Inner_R"
            source: "meshes/front_Inner_R_mesh.mesh"
            materials: [
                lightsSG_Front_Inner_R_material
            ]
        }
        Model {
            id: front_Outer_R
            objectName: "Front_Outer_R"
            source: "meshes/front_Outer_R_mesh.mesh"
            materials: [
                lightsSG_Front_Outer_R_material
            ]
        }
        Model {
            id: front_Sig_R
            objectName: "Front_Sig_R"
            source: "meshes/front_Sig_R_mesh.mesh"
            materials: [
                lightsSG_Front_Sig_R_material
            ]
        }
        Model {
            id: front_Fog_R
            objectName: "Front_Fog_R"
            source: "meshes/front_Fog_R_mesh.mesh"
            materials: [
                lightsSG_Front_Fog_R_material
            ]
        }
        Model {
            id: front_Turn_R
            objectName: "Front_Turn_R"
            source: "meshes/front_Turn_R_mesh.mesh"
            materials: [
                lightsSG_Front_Turn_R_material
            ]
        }
        Model {
            id: rear_Tail_L
            objectName: "Rear_Tail_L"
            source: "meshes/rear_Tail_L_mesh.mesh"
            materials: [
                lightsSG_Rear_Tail_L_material
            ]
        }
        Model {
            id: rear_Brake_L
            objectName: "Rear_Brake_L"
            source: "meshes/rear_Brake_L_mesh.mesh"
            materials: [
                lightsSG_Rear_Brake_L_material
            ]
        }
        Model {
            id: rear_Other_L
            objectName: "Rear_Other_L"
            source: "meshes/rear_Other_L_mesh.mesh"
            materials: [
                lightsSG_Rear_Other_L_material
            ]
        }
        Model {
            id: front_Inner_L
            objectName: "Front_Inner_L"
            source: "meshes/front_Inner_L_mesh.mesh"
            materials: [
                lightsSG_Front_Inner_L_material
            ]
        }
        Model {
            id: front_Outer_L
            objectName: "Front_Outer_L"
            source: "meshes/front_Outer_L_mesh.mesh"
            materials: [
                lightsSG_Front_Outer_L_material
            ]
        }
        Model {
            id: front_Sig_L
            objectName: "Front_Sig_L"
            source: "meshes/front_Sig_L_mesh.mesh"
            materials: [
                lightsSG_Front_Sig_L_material
            ]
        }
        Model {
            id: front_Fog_L
            objectName: "Front_Fog_L"
            source: "meshes/front_Fog_L_mesh.mesh"
            materials: [
                lightsSG_Front_Fog_L_material
            ]
        }
        Model {
            id: front_Turn_L
            objectName: "Front_Turn_L"
            source: "meshes/front_Turn_L_mesh.mesh"
            materials: [
                lightsSG_Front_Turn_L_material
            ]
        }
        Node {
            id: default_79
            objectName: "default"
        }
        Model {
            id: body
            objectName: "Body"
            source: "meshes/body_mesh.mesh"
            materials: [
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG2_material,
                bodySG_material,
                bodySG3_material,
                bodySG4_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG_material,
                bodySG3_material,
                bodySG2_material,
                bodySG_material,
                bodySG3_material,
                bodySG_material,
                bodySG3_material,
                bodySG2_material,
                bodySG3_material,
                bodySG2_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG3_material,
                bodySG_material,
                bodySG3_material,
                bodySG_material,
                bodySG3_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG3_material,
                bodySG_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG3_material,
                bodySG2_material,
                bodySG3_material,
                bodySG_material,
                bodySG3_material,
                bodySG_material,
                bodySG3_material,
                bodySG_material,
                bodySG3_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG_material,
                bodySG3_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG_material,
                bodySG2_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG3_material,
                bodySG2_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG3_material,
                bodySG_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG_material,
                bodySG3_material,
                bodySG2_material,
                bodySG_material,
                bodySG3_material,
                bodySG_material,
                bodySG3_material,
                bodySG2_material,
                bodySG3_material,
                bodySG2_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG3_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG3_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG3_material,
                bodySG2_material,
                bodySG3_material,
                bodySG_material,
                bodySG3_material,
                bodySG_material,
                bodySG3_material,
                bodySG_material,
                bodySG3_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG_material,
                bodySG3_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG3_material,
                bodySG2_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG3_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG3_material,
                bodySG_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG3_material,
                bodySG1_material,
                bodySG_material,
                bodySG3_material,
                bodySG1_material
            ]
        }
        Node {
            id: default_85
            objectName: "default"
        }
        Model {
            id: windows_Top
            objectName: "Windows_Top"
            source: "meshes/windows_Top_mesh.mesh"
            materials: [
                windows_TopSG_material
            ]
        }
        Node {
            id: default_89
            objectName: "default"
        }
        Model {
            id: door_LF
            objectName: "Door_LF"
            source: "meshes/door_LF_mesh.mesh"
            materials: [
                windows_TopSG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material,
                bodySG2_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material
            ]
        }
        Node {
            id: default_92
            objectName: "default"
        }
        Model {
            id: window_LF
            objectName: "Window_LF"
            source: "meshes/window_LF_mesh.mesh"
            materials: [
                windows_TopSG_material
            ]
        }
        Node {
            id: default_95
            objectName: "default"
        }
        Model {
            id: charge_Cap
            objectName: "Charge_Cap"
            source: "meshes/charge_Cap_mesh.mesh"
            materials: [
                bodySG4_material
            ]
        }
        Node {
            id: default_98
            objectName: "default"
        }
        Model {
            id: window_RF
            objectName: "Window_RF"
            source: "meshes/window_RF_mesh.mesh"
            materials: [
                windows_TopSG_material
            ]
        }
        Node {
            id: default_101
            objectName: "default"
        }
        Model {
            id: trunk
            objectName: "Trunk"
            source: "meshes/trunk_mesh.mesh"
            materials: [
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material,
                bodySG2_material,
                bodySG_material,
                bodySG2_material,
                bodySG_material,
                bodySG2_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material,
                bodySG2_material,
                bodySG_material,
                bodySG2_material,
                bodySG_material,
                bodySG2_material,
                bodySG_material,
                bodySG2_material,
                bodySG_material,
                bodySG2_material,
                bodySG_material,
                bodySG2_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG_material,
                windows_TopSG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material
            ]
        }
        Node {
            id: default_104
            objectName: "default"
        }
        Model {
            id: door_RF_Mirror
            objectName: "Door_RF_Mirror"
            source: "meshes/door_RF_Mirror_mesh.mesh"
            materials: [
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material,
                bodySG2_material,
                bodySG1_material
            ]
        }
        Node {
            id: default_107
            objectName: "default"
        }
        Model {
            id: door_RR
            objectName: "Door_RR"
            source: "meshes/door_RR_mesh.mesh"
            materials: [
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material
            ]
        }
        Node {
            id: default_110
            objectName: "default"
        }
        Model {
            id: door_RF
            objectName: "Door_RF"
            source: "meshes/door_RF_mesh.mesh"
            materials: [
                windows_TopSG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material,
                bodySG2_material,
                bodySG_material,
                bodySG1_material,
                bodySG_material
            ]
        }
        Node {
            id: default_113
            objectName: "default"
        }
        Model {
            id: window_LR
            objectName: "Window_LR"
            source: "meshes/window_LR_mesh.mesh"
            materials: [
                windows_TopSG_material
            ]
        }
        Node {
            id: default_116
            objectName: "default"
        }
        Model {
            id: window_RR
            objectName: "Window_RR"
            source: "meshes/window_RR_mesh.mesh"
            materials: [
                windows_TopSG_material
            ]
        }
        Node {
            id: default_119
            objectName: "default"
        }
        Model {
            id: door_LR
            objectName: "Door_LR"
            source: "meshes/door_LR_mesh.mesh"
            materials: [
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material,
                bodySG_material,
                bodySG1_material,
                bodySG2_material,
                bodySG1_material
            ]
        }
    }

    // Animations:
}
