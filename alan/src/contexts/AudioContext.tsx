import React, { createContext, useContext, useState, useRef, ReactNode } from 'react';
import { Audio, SubtitleLine } from '../types';

interface AudioContextType {
  currentAudio: Audio | null;
  subtitles: SubtitleLine[];
  isPlaying: boolean;
  currentTime: number;
  duration: number;
  playbackRate: number;
  audioRef: React.RefObject<HTMLAudioElement | null>;
  setCurrentAudio: (audio: Audio | null) => void;
  setSubtitles: (subtitles: SubtitleLine[]) => void;
  togglePlay: () => void;
  setPlaybackRate: (rate: number) => void;
  seek: (time: number) => void;
  updateTime: (time: number) => void;
  updateDuration: (duration: number) => void;
}

const AudioContext = createContext<AudioContextType | undefined>(undefined);

export const AudioProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [currentAudio, setCurrentAudio] = useState<Audio | null>(null);
  const [subtitles, setSubtitles] = useState<SubtitleLine[]>([]);
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentTime, setCurrentTime] = useState(0);
  const [duration, setDuration] = useState(0);
  const [playbackRate, setPlaybackRateState] = useState(1.0);
  const audioRef = useRef<HTMLAudioElement | null>(null);

  const togglePlay = () => {
    if (!audioRef.current) return;
    if (isPlaying) {
      audioRef.current.pause();
    } else {
      audioRef.current.play();
    }
    setIsPlaying(!isPlaying);
  };

  const setPlaybackRate = (rate: number) => {
    setPlaybackRateState(rate);
    if (audioRef.current) {
      audioRef.current.playbackRate = rate;
    }
  };

  const seek = (time: number) => {
    if (audioRef.current) {
      audioRef.current.currentTime = time;
      setCurrentTime(time);
    }
  };

  const updateTime = (time: number) => {
    setCurrentTime(time);
  };

  const updateDuration = (dur: number) => {
    setDuration(dur);
  };

  return (
    <AudioContext.Provider
      value={{
        currentAudio,
        subtitles,
        isPlaying,
        currentTime,
        duration,
        playbackRate,
        audioRef,
        setCurrentAudio,
        setSubtitles,
        togglePlay,
        setPlaybackRate,
        seek,
        updateTime,
        updateDuration,
      }}
    >
      {children}
    </AudioContext.Provider>
  );
};

export const useAudioContext = () => {
  const context = useContext(AudioContext);
  if (context === undefined) {
    throw new Error('useAudioContext must be used within an AudioProvider');
  }
  return context;
};
