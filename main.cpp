#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "quotegenerate.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QuoteGenerate quoteGen;

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("quoteGen", &quoteGen);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("QuoteMotive", "Main");

    return app.exec();
}
