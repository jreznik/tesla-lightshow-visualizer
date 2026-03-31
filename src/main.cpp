#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QQmlContext>
#include <QIcon>
#include "lightshow_sync.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon("assets/icon.png"));

    QQmlApplicationEngine engine;
    
    // Register types
    qmlRegisterType<LightshowSync>("Tesla.Lightshow", 1, 0, "LightshowSync");

    const QUrl url(QStringLiteral("qrc:/qt/qml/tesla-lightshow-visualizer/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    
    engine.load(url);

    return app.exec();
}
