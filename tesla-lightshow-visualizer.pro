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
    qml/main.qml \
    qml/CarModel.qml

target.path = $$[QT_INSTALL_BINS]
INSTALLS += target
