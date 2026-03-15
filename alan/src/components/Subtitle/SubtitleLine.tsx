import React, { forwardRef } from 'react';
import { SubtitleLine as SubtitleLineType } from '../../types';
import { formatTime } from '../../lib/srtParser';
import { useVocabulary } from '../../hooks/useVocabulary';
import { useAudioContext } from '../../contexts/AudioContext';
import { message } from 'antd';

interface SubtitleLineProps {
  subtitle: SubtitleLineType;
  isActive: boolean;
}

const SubtitleLine = forwardRef<HTMLDivElement, SubtitleLineProps>(
  ({ subtitle, isActive }, ref) => {
    const { addWord } = useVocabulary();
    const { currentAudio } = useAudioContext();

    const handleWordClick = async (word: string) => {
      const cleanWord = word.trim().toLowerCase();
      
      if (cleanWord && /^[a-zA-Z]+$/.test(cleanWord)) {
        await addWord(cleanWord, currentAudio?.id);
        message.success(`已添加 "${cleanWord}" 到生词列表`);
      }
    };

    const renderTextWithClickableWords = (text: string) => {
      const words = text.split(/(\s+|[,.!?;:])/);
      return words.map((word, index) => {
        if (/^[a-zA-Z]+$/.test(word)) {
          return (
            <span
              key={index}
              onClick={() => handleWordClick(word)}
              style={{
                cursor: 'pointer',
                padding: '0 2px',
              }}
              onMouseEnter={(e) => {
                e.currentTarget.style.backgroundColor = '#e6f7ff';
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.backgroundColor = 'transparent';
              }}
            >
              {word}
            </span>
          );
        }
        return <span key={index}>{word}</span>;
      });
    };

    return (
      <div
        ref={ref}
        style={{
          padding: '12px',
          marginBottom: '8px',
          backgroundColor: isActive ? '#fff7e6' : '#fafafa',
          borderLeft: isActive ? '4px solid #faad14' : '4px solid transparent',
          borderRadius: '4px',
          transition: 'all 0.3s',
          fontWeight: isActive ? 'bold' : 'normal',
        }}
      >
        <div style={{ fontSize: '12px', color: '#999', marginBottom: '4px' }}>
          {formatTime(subtitle.start)}
        </div>
        <div style={{ fontSize: '16px', lineHeight: '1.6' }}>
          {renderTextWithClickableWords(subtitle.text)}
        </div>
      </div>
    );
  }
);

SubtitleLine.displayName = 'SubtitleLine';

export default SubtitleLine;
