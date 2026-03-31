#include "lightshow_sync.h"
#include <QUrl>
#include <QDebug>

#include <QFileInfo>

LightshowSync::LightshowSync(QObject *parent) : QObject(parent)
{
    m_fseqReader = new FseqReader(this);
    m_mediaPlayer = new QMediaPlayer(this);
    m_audioOutput = new QAudioOutput(this);
    m_syncTimer = new QTimer(this);

    m_mediaPlayer->setAudioOutput(m_audioOutput);
    m_syncTimer->setInterval(15); 

    connect(m_syncTimer, &QTimer::timeout, this, &LightshowSync::updateFrame);
    connect(m_mediaPlayer, &QMediaPlayer::durationChanged, this, &LightshowSync::durationChanged);
    connect(m_mediaPlayer, &QMediaPlayer::positionChanged, this, &LightshowSync::positionChanged);
    connect(m_mediaPlayer, &QMediaPlayer::playbackStateChanged, this, &LightshowSync::playingChanged);
}

bool LightshowSync::loadShow(const QString &fseqPath, const QString &audioPath)
{
    stop(); // Reset current state before loading new show

    // Check if fseq exists and can be loaded
    if (!m_fseqReader->loadFile(fseqPath))
        return false;

    // Check if audio file exists
    QFileInfo audioInfo(audioPath);
    if (!audioInfo.exists())
        return false;

    m_mediaPlayer->setSource(QUrl::fromLocalFile(audioPath));
    m_currentFrameIndex = -1;
    
    m_showName = audioInfo.baseName();
    emit showNameChanged();
    
    return true;
}

void LightshowSync::play()
{
    m_mediaPlayer->play();
    m_syncTimer->start();
}

void LightshowSync::pause()
{
    m_mediaPlayer->pause();
    m_syncTimer->stop();
}

void LightshowSync::stop()
{
    m_mediaPlayer->stop();
    m_syncTimer->stop();
    m_currentFrameIndex = -1;
    emit frameChanged();
}

void LightshowSync::updateFrame()
{
    if (m_fseqReader->frameCount() == 0) return;

    qint64 pos = m_mediaPlayer->position();
    int stepTime = m_fseqReader->stepTimeMs();
    if (stepTime == 0) stepTime = 20;

    int frameIndex = static_cast<int>(pos / stepTime);
    if (frameIndex != m_currentFrameIndex) {
        m_currentFrameIndex = frameIndex;
        emit frameChanged();
    }
}

QVariantList LightshowSync::currentFrameData() const
{
    QByteArray frame = m_fseqReader->getFrame(m_currentFrameIndex);
    QVariantList list;
    for (int i = 0; i < frame.size(); ++i) {
        list.append(static_cast<int>(static_cast<unsigned char>(frame[i])));
    }
    return list;
}
