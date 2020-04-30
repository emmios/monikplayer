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
    QString path = dir.homePath() + "/.config/synth/synth-player/";
    QFile file(path + "settings.conf");

    if(!dir.exists(path))
    {
        dir.mkpath(path);
    }

    if(!file.exists())
    {
        file.open(QIODevice::ReadWrite);
        QSettings settings(path + "settings.conf", QSettings::NativeFormat);
        settings.setValue("volume", 0.5);
        file.close();
    }

    // Kill instance
    if(app.lock())
    {
        QSettings settings(path + "settings.conf", QSettings::NativeFormat);
        settings.setValue("media", argv[1]);
        return -1;
    }
    else
    {
        Context *context = new Context();
        if (argc >= 2)
        {
            context->media = argv[1];
        }
        else
        {
            context->media = path + "media/default.mp4";
        }
        //context->media = "/home/shenoisz/Vídeos/Eletro/Caramella girls - Caramelldansen Japanese video version.mp4";

        QQmlApplicationEngine engine;
        engine.rootContext()->setContextProperty("Context", context);
        engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

        app.setLock();
        QSettings settings(path + "settings.conf", QSettings::NativeFormat);
        settings.setValue("media", context->media);

        QObject *main = engine.rootObjects().first();
        QWindow *window = qobject_cast<QWindow *>(main);
        context->window = window;

        return app.exec();
    }
}
