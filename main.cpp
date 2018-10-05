#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QMediaPlayer>
#include <QVideoWidget>
#include "context.h"


int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    Context context;
    //context.media = "/home/shenoisz/Videos/Eletro/Borgeous - Wildfire (Official Music Video) OUT NOW.mp4";

    if (argc >= 2)
    {
        context.media = argv[1];
    }
    else
    {
        context.media = "/opt/monikvideos/resources/app/app/media/default.mp4";
    }

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("Context", &context);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
