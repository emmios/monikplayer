#ifndef CONTEXT_H
#define CONTEXT_H

#include <QObject>
#include <QScreen>
#include <QPoint>
#include <QApplication>
#include <QCursor>
#include <QSettings>
#include <QDir>


class Context : public QObject
{

    Q_OBJECT

public:
    QString media;
    Q_INVOKABLE int mouseX();
    Q_INVOKABLE int mouseY();
    Q_INVOKABLE QString uri();
    Q_INVOKABLE QString detailColor();
    Q_INVOKABLE int volume();
    Q_INVOKABLE void volume(int value);
    Q_INVOKABLE int loop();
    Q_INVOKABLE void loop(int value);

private:
    QScreen *screen = QApplication::screens().at(0);
};

#endif // CONTEXT_H
