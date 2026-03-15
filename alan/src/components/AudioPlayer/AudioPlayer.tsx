import React, { useEffect } from 'react';
import { Card } from 'antd';
import { useAudioContext } from '../../contexts/AudioContext';
import { usePlaybackProgress } from '../../hooks/usePlaybackProgress';
import PlaybackControls from './PlaybackControls';
import ProgressBar from './ProgressBar';

const AudioPlayer: React.FC = () => {
  const {
    currentAudio,
    audioRef,
    updateTime,
    updateDuration,
    playbackRate,
    currentTime,
    seek,
  } = useAudioContext();

  usePlaybackProgress(currentAudio?.id || null, currentTime, seek);

  useEffect(() => {
    const audio = audioRef.current;
    if (!audio) return;

    const handleTimeUpdate = () => {
      updateTime(audio.currentTime);
    };

    const handleLoadedMetadata = () => {
      updateDuration(audio.duration);
    };

    audio.addEventListener('timeupdate', handleTimeUpdate);
    audio.addEventListener('loadedmetadata', handleLoadedMetadata);

    return () => {
      audio.removeEventListener('timeupdate', handleTimeUpdate);
      audio.removeEventListener('loadedmetadata', handleLoadedMetadata);
    };
  }, [audioRef, updateTime, updateDuration]);

  useEffect(() => {
    if (audioRef.current) {
      audioRef.current.playbackRate = playbackRate;
    }
  }, [playbackRate, audioRef]);

  if (!currentAudio) {
    return (
      <Card style={{ margin: '16px' }}>
        <div style={{ textAlign: 'center', padding: '40px', color: '#999' }}>
          请选择一个音频开始播放
        </div>
      </Card>
    );
  }

  return (
    <Card title={`正在播放: ${currentAudio.title}`} style={{ margin: '16px' }}>
      <audio ref={audioRef} src={currentAudio.audio_url} />
      <PlaybackControls />
      <ProgressBar />
    </Card>
  );
};

export default AudioPlayer;
