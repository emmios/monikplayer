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
