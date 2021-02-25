#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QWindow>
#include <QObject>
#include <QDebug>
#include <QMetaObject>
#include <QVariant>

#include "context.h"
#include "singleapplication.h"
#include "imedia.h"

void myMessageOutput(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    //https://doc.qt.io/qt-5/qtglobal.html#qInstallMessageHandler
}

int main(int argc, char *argv[])
{
    //qInstallMessageHandler(myMessageOutput);

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);

    //QApplication app(argc, argv);
    singleApplication app(argc, argv);
    //app.setAttribute(Qt::AA_UseHighDpiPixmaps);
    //app.setAttribute(Qt::AA_EnableHighDpiScaling, true);

    Context *context = new Context();

    // Kill instance
    if(app.lock())
    {
        QDBusInterface iface("emmios.interface.multimedia", "/emmios/interface/multimedia", "emmios.interface.multimedia", QDBusConnection::sessionBus());
        if (iface.isValid())
        {
            iface.call("media", context->url(argv[1]));
        }
        return -1;
    }
    else
    {
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
            settings.setValue("hq", 1);
            file.close();
        }

        if (argc >= 2)
        {
            context->media = argv[1];
        }
        else
        {
            //context->media = path + "media/default.mp4";
        }

        QQmlApplicationEngine engine;
        engine.rootContext()->setContextProperty("Context", context);
        engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

        app.setLock();

        QObject *main = engine.rootObjects().first();
        QWindow *window = qobject_cast<QWindow *>(main);
        context->window = window;

        Imedia imedia;
        imedia.main = window;
        QDBusConnection connection = QDBusConnection::sessionBus();
        connection.registerObject("/emmios/interface/multimedia", &imedia, QDBusConnection::ExportAllSlots);
        connection.connect("emmios.interface.multimedia", "/emmi/interface/multimedia", "emmi.interface.multimedia", "media", &imedia, SLOT(media()));
        connection.registerService("emmios.interface.multimedia");

        return app.exec();
    }
}
