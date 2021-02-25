#include "imedia.h"

void Imedia::media(QString file)
{
    QMetaObject::invokeMethod(this->main, "imedia",
        Q_ARG(QVariant, file)
    );
}


