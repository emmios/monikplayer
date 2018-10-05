#ifndef CONTEXT_H
#define CONTEXT_H

#include <QObject>
#include <QScreen>
#include <QPoint>
#include <QApplication>
#include <QCursor>


class Context : public QObject
{

    Q_OBJECT

public:
    QString media;
    Q_INVOKABLE int mouseX();
    Q_INVOKABLE int mouseY();
    Q_INVOKABLE QString uri();

private:
    QScreen *screen = QApplication::screens().at(0);
};

#endif // CONTEXT_H
