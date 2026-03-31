QT += quick quick3d multimedia

CONFIG += c++17

SOURCES += \
    src/main.cpp \
    src/fseq_reader.cpp \
    src/lightshow_sync.cpp

HEADERS += \
    src/fseq_reader.h \
    src/lightshow_sync.h

RESOURCES += \
    qml.qrc

win32: RC_ICONS = assets/icon.ico
macx: ICON = assets/icon.svg

# Vulkan support
linux: LIBS += -lvulkan

DISTFILES += \
    qml/main.qml

target.path = /usr/bin
!isEmpty(PREFIX) {
    target.path = $$PREFIX/bin
}

desktop.path = $$PREFIX/share/applications
desktop.files = org.jreznik.TeslaLightshowVisualizer.desktop

icon.path = $$PREFIX/share/icons/hicolor/scalable/apps
icon.files = assets/org.jreznik.TeslaLightshowVisualizer.svg

metainfo.path = $$PREFIX/share/metainfo
metainfo.files = org.jreznik.TeslaLightshowVisualizer.metainfo.xml

INSTALLS += target desktop icon metainfo
