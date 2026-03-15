import React from 'react';
import { Button, Space, Select } from 'antd';
import { PlayCircleOutlined, PauseCircleOutlined } from '@ant-design/icons';
import { useAudioContext } from '../../contexts/AudioContext';

const PlaybackControls: React.FC = () => {
  const { isPlaying, togglePlay, playbackRate, setPlaybackRate } = useAudioContext();

  const playbackRates = [
    { label: '0.5x', value: 0.5 },
    { label: '0.75x', value: 0.75 },
    { label: '1.0x', value: 1.0 },
    { label: '1.25x', value: 1.25 },
    { label: '1.5x', value: 1.5 },
    { label: '2.0x', value: 2.0 },
  ];

  return (
    <Space style={{ marginBottom: '16px' }}>
      <Button
        type="primary"
        icon={isPlaying ? <PauseCircleOutlined /> : <PlayCircleOutlined />}
        size="large"
        onClick={togglePlay}
      >
        {isPlaying ? '暂停' : '播放'}
      </Button>
      <span style={{ marginLeft: '16px', marginRight: '8px' }}>播放速度:</span>
      <Select
        value={playbackRate}
        onChange={setPlaybackRate}
        options={playbackRates}
        style={{ width: 100 }}
      />
    </Space>
  );
};

export default PlaybackControls;
