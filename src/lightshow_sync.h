#ifndef LIGHTSHOW_SYNC_H
#define LIGHTSHOW_SYNC_H

#include <QObject>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QTimer>
#include <QVariantList>
#include "fseq_reader.h"

class LightshowSync : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int currentFrameIndex READ currentFrameIndex NOTIFY frameChanged)
    Q_PROPERTY(QVariantList currentFrameData READ currentFrameData NOTIFY frameChanged)
    Q_PROPERTY(qint64 duration READ duration NOTIFY durationChanged)
    Q_PROPERTY(qint64 position READ position WRITE setPosition NOTIFY positionChanged)
    Q_PROPERTY(bool playing READ isPlaying NOTIFY playingChanged)
    Q_PROPERTY(QString showName READ showName NOTIFY showNameChanged)

public:
    explicit LightshowSync(QObject *parent = nullptr);

    Q_INVOKABLE bool loadShow(const QString &fseqPath, const QString &audioPath);
    Q_INVOKABLE void play();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void stop();

    int currentFrameIndex() const { return m_currentFrameIndex; }
    QVariantList currentFrameData() const;
    qint64 duration() const { return m_mediaPlayer->duration(); }
    qint64 position() const { return m_mediaPlayer->position(); }
    void setPosition(qint64 pos) { m_mediaPlayer->setPosition(pos); }
    bool isPlaying() const { return m_mediaPlayer->playbackState() == QMediaPlayer::PlayingState; }
    QString showName() const { return m_showName; }

signals:
    void frameChanged();
    void durationChanged();
    void positionChanged();
    void playingChanged();
    void showNameChanged();

private slots:
    void updateFrame();

private:
    FseqReader *m_fseqReader;
    QMediaPlayer *m_mediaPlayer;
    QAudioOutput *m_audioOutput;
    QTimer *m_syncTimer;
    int m_currentFrameIndex = -1;
    QString m_showName;
};

#endif // LIGHTSHOW_SYNC_H
