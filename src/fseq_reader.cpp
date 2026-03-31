#include "fseq_reader.h"
#include <QDataStream>
#include <QDebug>

FseqReader::FseqReader(QObject *parent) : QObject(parent) {}

bool FseqReader::loadFile(const QString &filePath)
{
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Failed to open FSEQ file:" << filePath;
        return false;
    }

    QDataStream in(&file);
    in.setByteOrder(QDataStream::LittleEndian);

    char magic[4];
    if (file.read(magic, 4) != 4 || qstrncmp(magic, "PSEQ", 4) != 0) {
        qWarning() << "Not a valid FSEQ file:" << filePath;
        return false;
    }

    quint16 dataOffset;
    quint8 minor, major;
    in >> dataOffset >> minor >> major;

    file.seek(10);
    quint32 channelCount, frameCount;
    quint8 stepTimeMs;
    in >> channelCount >> frameCount >> stepTimeMs;

    file.seek(20);
    quint8 compression;
    in >> compression;

    if (compression != 0) {
        qWarning() << "Compressed FSEQ is not supported.";
        return false;
    }

    m_channelCount = static_cast<int>(channelCount);
    m_frameCount = static_cast<int>(frameCount);
    m_stepTimeMs = static_cast<int>(stepTimeMs);
    m_dataOffset = static_cast<int>(dataOffset);

    file.seek(m_dataOffset);
    m_allFramesData = file.readAll();

    file.close();
    emit fileLoaded();
    return true;
}

QByteArray FseqReader::getFrame(int frameIndex) const
{
    if (frameIndex < 0 || frameIndex >= m_frameCount)
        return QByteArray();

    int start = frameIndex * m_channelCount;
    return m_allFramesData.mid(start, m_channelCount);
}
