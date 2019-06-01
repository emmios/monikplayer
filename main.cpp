#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QMediaPlayer>
#include <QVideoWidget>
#include <QWindow>
#include <QObject>
#include <QDebug>
#include <QMetaObject>
#include <QVariant>
#include <QProcess>
#include <QString>
#include <QStringList>

#include "context.h"
#include "singleapplication.h"


int main(int argc, char *argv[])
{
    //QApplication app(argc, argv);
    singleApplication app(argc, argv);

    QDir dir;
    QString path = dir.homePath() + "/.config/Synth/monikplayer/";
    QFile file(path + "settings.txt");

    if(!dir.exists(path))
    {
        dir.mkpath(path);
    }

    if(!file.exists())
    {
        file.open(QIODevice::ReadWrite);
        QSettings settings(path + "settings.txt", QSettings::NativeFormat);
        settings.setValue("volume", 0.5);
        file.close();
    }

    // Kill before instance
    if(app.lock())
    {
        QProcess process;
        QSettings settings(path + "settings.txt", QSettings::NativeFormat);
        QString pro = settings.value("process").toString();

        QStringList args;
        args << pro;
        process.start("kill", args);
        process.waitForFinished();

        settings.setValue("process", app.applicationPid());
    }

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

    app.setLock();
    QSettings settings(path + "settings.txt", QSettings::NativeFormat);
    settings.setValue("process", app.applicationPid());

    return app.exec();
}
