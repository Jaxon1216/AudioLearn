import React from 'react';
import { List, message } from 'antd';
import { SoundOutlined } from '@ant-design/icons';
import { Audio } from '../../types';
import { useAudioContext } from '../../contexts/AudioContext';
import { parseSRT } from '../../lib/srtParser';
import StatusTags from './StatusTags';

interface AudioItemProps {
  audio: Audio;
  onStatusUpdate: (audioId: string, status: Audio['status']) => void;
}

const AudioItem: React.FC<AudioItemProps> = ({ audio, onStatusUpdate }) => {
  const { setCurrentAudio, setSubtitles, currentAudio } = useAudioContext();

  const handleClick = async () => {
    setCurrentAudio(audio);

    try {
      const response = await fetch(audio.subtitle_url);
      const srtText = await response.text();
      const parsedSubtitles = parseSRT(srtText);
      setSubtitles(parsedSubtitles);
      message.success(`正在播放: ${audio.title}`);
    } catch (error) {
      console.error('Error loading subtitles:', error);
      message.error('字幕加载失败');
      setSubtitles([]);
    }
  };

  const isActive = currentAudio?.id === audio.id;

  return (
    <List.Item
      style={{
        cursor: 'pointer',
        backgroundColor: isActive ? '#e6f7ff' : 'transparent',
        padding: '12px',
        borderRadius: '4px',
        marginBottom: '8px',
      }}
      onClick={handleClick}
    >
      <List.Item.Meta
        avatar={<SoundOutlined style={{ fontSize: '24px', color: '#1890ff' }} />}
        title={<span style={{ fontWeight: isActive ? 'bold' : 'normal' }}>{audio.title}</span>}
        description={
          <StatusTags
            currentStatus={audio.status}
            onStatusChange={(status) => onStatusUpdate(audio.id, status)}
          />
        }
      />
    </List.Item>
  );
};

export default AudioItem;
