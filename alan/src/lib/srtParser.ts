import { SubtitleLine } from '../types';

export const parseSRT = (srtContent: string): SubtitleLine[] => {
  const lines = srtContent.trim().split('\n\n');
  const subtitles: SubtitleLine[] = [];

  lines.forEach((block) => {
    const parts = block.split('\n');
    if (parts.length >= 3) {
      const index = parseInt(parts[0], 10);
      const timeMatch = parts[1].match(/(\d{2}):(\d{2}):(\d{2}),(\d{3}) --> (\d{2}):(\d{2}):(\d{2}),(\d{3})/);
      
      if (timeMatch) {
        const startTime = 
          parseInt(timeMatch[1]) * 3600 +
          parseInt(timeMatch[2]) * 60 +
          parseInt(timeMatch[3]) +
          parseInt(timeMatch[4]) / 1000;
        
        const endTime = 
          parseInt(timeMatch[5]) * 3600 +
          parseInt(timeMatch[6]) * 60 +
          parseInt(timeMatch[7]) +
          parseInt(timeMatch[8]) / 1000;
        
        const text = parts.slice(2).join('\n');
        
        subtitles.push({
          index,
          start: startTime,
          end: endTime,
          text,
        });
      }
    }
  });

  return subtitles;
};

export const formatTime = (seconds: number): string => {
  const hrs = Math.floor(seconds / 3600);
  const mins = Math.floor((seconds % 3600) / 60);
  const secs = Math.floor(seconds % 60);
  
  if (hrs > 0) {
    return `${hrs.toString().padStart(2, '0')}:${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  }
  return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
};
