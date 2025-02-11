#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "quotegenerate.h"
#include "user.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QuoteGenerate quoteGen;
    User user;

    app.setOrganizationName("YourOrganization");
    app.setOrganizationDomain("yourdomain.com");
    app.setApplicationName("QuoteMotive");

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("quoteGen", &quoteGen);
    engine.rootContext()->setContextProperty("user", &user);

    // qmlRegisterType<User>("com.example", 1, 0, "user");

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("QuoteMotive", "Main");

    return app.exec();
}
