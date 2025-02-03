#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "quotesloader.h"
#include <QResource>
#include <QDebug>
#include <QDir>

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // Debug: List all registered resources
    QDir resourceDir(":/json");
    qDebug() << "Registered resources:" << resourceDir.entryList();

    QuotesLoader quotesLoader;
    engine.rootContext()->setContextProperty("quotesLoader", &quotesLoader);

    engine.loadFromModule("RandomQuotes", "Main");
    return app.exec();
}
