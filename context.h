#ifndef CONTEXT_H
#define CONTEXT_H

#include <QObject>
#include <QScreen>
#include <QWindow>
#include <QPoint>
#include <QApplication>
#include <QCursor>
#include <QSettings>
#include <QDir>

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xutil.h>
#include <X11/extensions/Xinerama.h>

class Context : public QObject
{

    Q_OBJECT

public:
    Context();
    QString path;
    QString media;
    QWindow *window;
    Q_INVOKABLE int mouseX();
    Q_INVOKABLE int mouseY();
    Q_INVOKABLE QString uri();
    Q_INVOKABLE QString detailColor();
    Q_INVOKABLE int volume();
    Q_INVOKABLE void volume(int value);
    Q_INVOKABLE int loop();
    Q_INVOKABLE void loop(int value);
    Q_INVOKABLE QString verify();
    Q_INVOKABLE void setMedia(QString media);
    Q_INVOKABLE int windowMove(int x, int y, int w, int h);

private:
    QScreen *screen = QApplication::screens().at(0);
};

#endif // CONTEXT_H
