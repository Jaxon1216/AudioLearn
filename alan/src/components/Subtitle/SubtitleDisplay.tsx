import React, { useEffect, useRef } from 'react';
import { Card } from 'antd';
import { useAudioContext } from '../../contexts/AudioContext';
import { useSubtitleSync } from '../../hooks/useSubtitleSync';
import SubtitleLine from './SubtitleLine';

const SubtitleDisplay: React.FC = () => {
  const { subtitles, currentTime, currentAudio } = useAudioContext();
  const currentIndex = useSubtitleSync(currentTime, subtitles);
  const containerRef = useRef<HTMLDivElement>(null);
  const activeLineRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (activeLineRef.current && containerRef.current) {
      const container = containerRef.current;
      const activeLine = activeLineRef.current;
      const containerHeight = container.clientHeight;
      const lineTop = activeLine.offsetTop;
      const lineHeight = activeLine.clientHeight;
      
      const scrollTo = lineTop - containerHeight / 2 + lineHeight / 2;
      container.scrollTo({ top: scrollTo, behavior: 'smooth' });
    }
  }, [currentIndex]);

  if (!currentAudio) {
    return (
      <Card title="字幕" style={{ margin: '16px', height: '400px' }}>
        <div style={{ textAlign: 'center', padding: '40px', color: '#999' }}>
          暂无字幕
        </div>
      </Card>
    );
  }

  return (
    <Card title="字幕" style={{ margin: '16px' }}>
      <div
        ref={containerRef}
        style={{
          height: '400px',
          overflowY: 'auto',
          padding: '16px',
        }}
      >
        {subtitles.map((subtitle, index) => (
          <SubtitleLine
            key={subtitle.index}
            subtitle={subtitle}
            isActive={index === currentIndex}
            ref={index === currentIndex ? activeLineRef : null}
          />
        ))}
      </div>
    </Card>
  );
};

export default SubtitleDisplay;
