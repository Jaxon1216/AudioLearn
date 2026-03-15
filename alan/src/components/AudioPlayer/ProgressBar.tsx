import React from 'react';
import { Slider } from 'antd';
import { useAudioContext } from '../../contexts/AudioContext';
import { formatTime } from '../../lib/srtParser';

const ProgressBar: React.FC = () => {
  const { currentTime, duration, seek } = useAudioContext();

  const handleChange = (value: number) => {
    seek(value);
  };

  return (
    <div>
      <Slider
        min={0}
        max={duration || 100}
        value={currentTime}
        onChange={handleChange}
        step={0.1}
        tooltip={{ formatter: (value) => formatTime(value || 0) }}
      />
      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '12px', color: '#666' }}>
        <span>{formatTime(currentTime)}</span>
        <span>{formatTime(duration)}</span>
      </div>
    </div>
  );
};

export default ProgressBar;
