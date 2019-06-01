#include "context.h"


int Context::mouseX()
{   
    QPoint Mouse = QCursor::pos(this->screen);
    return Mouse.x();
}

int Context::mouseY()
{
    QPoint Mouse = QCursor::pos(this->screen);
    return Mouse.y();
}

QString Context::uri()
{
    return media;
}

QString Context::detailColor()
{
    QDir dir;
    QSettings panel(dir.homePath() + "/.config/Synth/panel/settings.txt", QSettings::NativeFormat);
    QString color = panel.value("color").toString();
    if (color.isEmpty()) color = "#007fff";
    return color;
}

int Context::volume()
{
    QDir dir;
    QSettings video(dir.homePath() + "/.config/Synth/monikplayer/settings.txt", QSettings::NativeFormat);
    return video.value("volume").toInt();
}

void Context::volume(int value)
{
    QDir dir;
    QSettings video(dir.homePath() + "/.config/Synth/monikplayer/settings.txt", QSettings::NativeFormat);
    video.setValue("volume", value);
}

int Context::loop()
{
    QDir dir;
    QSettings video(dir.homePath() + "/.config/Synth/monikplayer/settings.txt", QSettings::NativeFormat);
    return video.value("loop").toInt();
}

void Context::loop(int value)
{
    QDir dir;
    QSettings video(dir.homePath() + "/.config/Synth/monikplayer/settings.txt", QSettings::NativeFormat);
    video.setValue("loop", value);
}
