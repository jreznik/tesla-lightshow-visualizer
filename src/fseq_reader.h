#ifndef FSEQ_READER_H
#define FSEQ_READER_H

#include <QObject>
#include <QString>
#include <QFile>
#include <QVector>
#include <QByteArray>

class FseqReader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int channelCount READ channelCount NOTIFY fileLoaded)
    Q_PROPERTY(int frameCount READ frameCount NOTIFY fileLoaded)
    Q_PROPERTY(int stepTimeMs READ stepTimeMs NOTIFY fileLoaded)

public:
    explicit FseqReader(QObject *parent = nullptr);

    bool loadFile(const QString &filePath);
    QByteArray getFrame(int frameIndex) const;

    int channelCount() const { return m_channelCount; }
    int frameCount() const { return m_frameCount; }
    int stepTimeMs() const { return m_stepTimeMs; }

signals:
    void fileLoaded();

private:
    int m_channelCount = 0;
    int m_frameCount = 0;
    int m_stepTimeMs = 0;
    int m_dataOffset = 0;
    QByteArray m_allFramesData;
};

#endif // FSEQ_READER_H
