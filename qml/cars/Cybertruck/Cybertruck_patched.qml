import QtQuick
import QtQuick3D

Node {
    id: node

    // Resources
    Texture {
        id: exterior_AO_Dark_png_texture
        objectName: "Exterior_AO_Dark.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        // Source texture path expected: maps/Exterior_AO_Dark.png
        // Skipped property: source, reason: Failed to find texture at /home/jreznik/gemini/tesla-lightshow-visualizer/assets/Exterior_AO_Dark.png
    }
    Texture {
        id: paint_Red_AO_png_texture
        objectName: "Paint_Red_AO.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        // Source texture path expected: maps/Paint_Red_AO.png
        // Skipped property: source, reason: Failed to find texture at /home/jreznik/gemini/tesla-lightshow-visualizer/assets/Paint_Red_AO.png
    }
    Texture {
        id: cybertruck_Premium_Wheel_AO_Dark_png_texture
        objectName: "Cybertruck_Premium_Wheel_AO_Dark.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        // Source texture path expected: maps/Cybertruck_Premium_Wheel_AO_Dark.png
        // Skipped property: source, reason: Failed to find texture at /home/jreznik/gemini/tesla-lightshow-visualizer/assets/Cybertruck_Premium_Wheel_AO_Dark.png
    }
    PrincipledMaterial {
        id: ct_Frunk_Mtl_material
        objectName: "CT_Frunk_Mtl"
        baseColor: "#ff999999"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: ct_Rear_Bar_Mtl_material
        objectName: "CT_Rear_Bar_Mtl"
        baseColor: "#ff999999"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: ct_Offroad_Bar_Mtl_material
        objectName: "CT_Offroad_Bar_Mtl"
        baseColor: "#ff999999"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: ct_Front_Bar_Mtl_material
        objectName: "CT_Front_Bar_Mtl"
        baseColor: "#ff999999"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: ct_Main_Beams_Mtl_material
        objectName: "CT_Main_Beams_Mtl"
        baseColor: "#ff999999"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: lambert4SG_material
        objectName: "lambert4SG"
        baseColor: "#ff000000"
        baseColorMap: cybertruck_Premium_Wheel_AO_Dark_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: blinn4SG_material
        objectName: "blinn4SG"
        baseColor: "#ff000000"
        baseColorMap: cybertruck_Premium_Wheel_AO_Dark_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: lambert3SG_material
        objectName: "lambert3SG"
        baseColor: "#ff000000"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: blinn3SG_material
        objectName: "blinn3SG"
        baseColor: "#ff000000"
        baseColorMap: paint_Red_AO_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: lambert2SG_material
        objectName: "lambert2SG"
        baseColor: "#ff000000"
        baseColorMap: exterior_AO_Dark_png_texture
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: phong1SG_material
        objectName: "phong1SG"
        baseColor: "#ff141414"
        indexOfRefraction: 1
    }

    // Nodes:
    Node {
        id: cybertruck_patched_obj
        objectName: "Cybertruck_patched.obj"
        Node {
            id: default_
            objectName: "default"
        }
        Node {
            id: lights
            objectName: "Lights"
        }
        Node {
            id: default_4
            objectName: "default"
        }
        Model {
            id: windows
            objectName: "Windows"
            source: "meshes/windows_mesh.mesh"
            materials: [
                phong1SG_material
            ]
        }
        Node {
            id: default_8
            objectName: "default"
        }
        Model {
            id: body
            objectName: "Body"
            source: "meshes/body_mesh.mesh"
            materials: [
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                lambert3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material,
                blinn3SG_material,
                lambert2SG_material
            ]
        }
        Node {
            id: default_16
            objectName: "default"
        }
        Model {
            id: wheels
            objectName: "Wheels"
            source: "meshes/wheels_mesh.mesh"
            materials: [
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material,
                blinn4SG_material,
                lambert4SG_material
            ]
        }
        Model {
            id: ct_Main_Beams
            objectName: "CT_Main_Beams"
            source: "meshes/ct_Main_Beams_mesh.mesh"
            materials: [
                ct_Main_Beams_Mtl_material
            ]
        }
        Model {
            id: ct_Front_Bar
            objectName: "CT_Front_Bar"
            source: "meshes/ct_Front_Bar_mesh.mesh"
            materials: [
                ct_Front_Bar_Mtl_material
            ]
        }
        Model {
            id: ct_Offroad_Bar
            objectName: "CT_Offroad_Bar"
            source: "meshes/ct_Offroad_Bar_mesh.mesh"
            materials: [
                ct_Offroad_Bar_Mtl_material
            ]
        }
        Model {
            id: ct_Rear_Bar
            objectName: "CT_Rear_Bar"
            source: "meshes/ct_Rear_Bar_mesh.mesh"
            materials: [
                ct_Rear_Bar_Mtl_material
            ]
        }
        Model {
            id: ct_Frunk
            objectName: "CT_Frunk"
            source: "meshes/ct_Frunk_mesh.mesh"
            materials: [
                ct_Frunk_Mtl_material
            ]
        }
    }

    // Animations:
}
