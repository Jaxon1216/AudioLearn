import { useState, useEffect } from 'react';
import { SubtitleLine } from '../types';

export const useSubtitleSync = (
  currentTime: number,
  subtitles: SubtitleLine[]
): number => {
  const [currentIndex, setCurrentIndex] = useState(-1);

  useEffect(() => {
    const index = subtitles.findIndex(
      (sub) => currentTime >= sub.start && currentTime <= sub.end
    );
    setCurrentIndex(index);
  }, [currentTime, subtitles]);

  return currentIndex;
};
