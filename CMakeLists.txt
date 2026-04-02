cmake_minimum_required(VERSION 3.16)

project(TeslaLightshowVisualizer VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS 
    Quick 
    Quick3D 
    Multimedia 
    ShaderTools
)

qt_standard_project_setup()

qt_add_executable(tesla-lightshow-visualizer
    src/main.cpp
    src/fseq_reader.h src/fseq_reader.cpp
    src/lightshow_sync.h src/lightshow_sync.cpp
)

# QML Module definition
# Matches the QRC prefix: /qt/qml/tesla-lightshow-visualizer
qt_add_qml_module(tesla-lightshow-visualizer
    URI Tesla.Lightshow
    VERSION 1.0
    RESOURCE_PREFIX /qt/qml/tesla-lightshow-visualizer
    QML_FILES 
        qml/main.qml
        qml/shaders/BrushedSteelMaterial.qml
        qml/cars/ModelS/ModelSCar.qml
        qml/cars/ModelS/ModelSCarInternal.qml
        qml/cars/Cybertruck/CybertruckCar.qml
    RESOURCES
        qml/shaders/brushed_steel.frag
        meshes/ModelS/body_mesh.mesh
        meshes/ModelS/charge_Cap_mesh.mesh
        meshes/ModelS/door_LF_mesh.mesh
        meshes/ModelS/door_LF_Mirror_mesh.mesh
        meshes/ModelS/door_LR_mesh.mesh
        meshes/ModelS/door_RF_mesh.mesh
        meshes/ModelS/door_RF_Mirror_mesh.mesh
        meshes/ModelS/door_RR_mesh.mesh
        meshes/ModelS/hood_Hinge_1_mesh.mesh
        meshes/ModelS/hood_Hinge_2_mesh.mesh
        meshes/ModelS/hood_mesh.mesh
        meshes/ModelS/spoiler_mesh.mesh
        meshes/ModelS/trunk_mesh.mesh
        meshes/ModelS/wheels_mesh.mesh
        meshes/ModelS/window_LF_mesh.mesh
        meshes/ModelS/window_LR_mesh.mesh
        meshes/ModelS/window_RF_mesh.mesh
        meshes/ModelS/window_RR_mesh.mesh
        meshes/ModelS/windows_Top_mesh.mesh
        meshes/ModelS/front_Inner_L_mesh.mesh
        meshes/ModelS/front_Inner_R_mesh.mesh
        meshes/ModelS/front_Outer_L_mesh.mesh
        meshes/ModelS/front_Outer_R_mesh.mesh
        meshes/ModelS/front_Sig_L_mesh.mesh
        meshes/ModelS/front_Sig_R_mesh.mesh
        meshes/ModelS/front_Turn_L_mesh.mesh
        meshes/ModelS/front_Turn_R_mesh.mesh
        meshes/ModelS/front_Fog_L_mesh.mesh
        meshes/ModelS/front_Fog_R_mesh.mesh
        meshes/ModelS/rear_Brake_L_mesh.mesh
        meshes/ModelS/rear_Brake_R_mesh.mesh
        meshes/ModelS/rear_Tail_L_mesh.mesh
        meshes/ModelS/rear_Tail_R_mesh.mesh
        meshes/ModelS/rear_Other_L_mesh.mesh
        meshes/ModelS/rear_Other_R_mesh.mesh
        meshes/ModelS/side_Repeater_L_mesh.mesh
        meshes/ModelS/side_Repeater_R_mesh.mesh
        meshes/Cybertruck/body_mesh.mesh
        meshes/Cybertruck/wheels_mesh.mesh
        meshes/Cybertruck/windows_mesh.mesh
        meshes/Cybertruck/lights_mesh.mesh
        meshes/Cybertruck/ct_Mirror_L_mesh.mesh
        meshes/Cybertruck/ct_Mirror_R_mesh.mesh
        meshes/Cybertruck/ct_Front_Bar_mesh.mesh
        meshes/Cybertruck/ct_Main_Beams_mesh.mesh
        meshes/Cybertruck/ct_Offroad_Bar_mesh.mesh
        meshes/Cybertruck/ct_Rear_Bar_mesh.mesh
)

# Set base directories for QML files to strip the 'qml/' prefix in resources
# This ensures qml/main.qml is accessible as qrc:/qt/qml/tesla-lightshow-visualizer/main.qml
set_target_properties(tesla-lightshow-visualizer PROPERTIES
    QT_QML_MODULE_RESOURCE_PATH "/qt/qml/tesla-lightshow-visualizer"
)

# Target links
target_link_libraries(tesla-lightshow-visualizer PRIVATE 
    Qt6::Quick 
    Qt6::Quick3D 
    Qt6::Multimedia 
    Qt6::ShaderTools
)

if(WIN32)
    set_target_properties(tesla-lightshow-visualizer PROPERTIES
        WIN32_EXECUTABLE ON
    )
    set(app_icon_resource "${CMAKE_CURRENT_SOURCE_DIR}/assets/icon.ico")
    target_sources(tesla-lightshow-visualizer PRIVATE "${app_icon_resource}")
elseif(APPLE)
    set_target_properties(tesla-lightshow-visualizer PROPERTIES
        MACOSX_BUNDLE ON
        MACOSX_BUNDLE_BUNDLE_NAME "Tesla Visualizer"
        MACOSX_BUNDLE_ICON_FILE "icon.svg"
    )
    set(app_icon_resource "${CMAKE_CURRENT_SOURCE_DIR}/assets/icon.svg")
    set_source_files_properties(${app_icon_resource} PROPERTIES MACOSX_BUNDLE_LOCATION "Resources")
    target_sources(tesla-lightshow-visualizer PRIVATE "${app_icon_resource}")
endif()

include(GNUInstallDirs)

# Install executable
install(TARGETS tesla-lightshow-visualizer
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# Install Linux desktop files
if(UNIX AND NOT APPLE)
    install(FILES org.jreznik.TeslaLightshowVisualizer.desktop
        DESTINATION ${CMAKE_INSTALL_DATADIR}/applications
    )
    install(FILES assets/org.jreznik.TeslaLightshowVisualizer.svg
        DESTINATION ${CMAKE_INSTALL_DATADIR}/icons/hicolor/scalable/apps
    )
    install(FILES org.jreznik.TeslaLightshowVisualizer.metainfo.xml
        DESTINATION ${CMAKE_INSTALL_DATADIR}/metainfo
    )
endif()
