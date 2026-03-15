import React from 'react';
import { Button, Space } from 'antd';
import { Audio } from '../../types';

interface StatusTagsProps {
  currentStatus: Audio['status'];
  onStatusChange: (status: Audio['status']) => void;
}

const StatusTags: React.FC<StatusTagsProps> = ({ currentStatus, onStatusChange }) => {
  const handleClick = (e: React.MouseEvent, status: Audio['status']) => {
    e.stopPropagation();
    onStatusChange(currentStatus === status ? null : status);
  };

  return (
    <Space size="small" style={{ marginTop: '8px' }}>
      <Button
        size="small"
        type={currentStatus === 'raw' ? 'primary' : 'default'}
        onClick={(e) => handleClick(e, 'raw')}
      >
        生
      </Button>
      <Button
        size="small"
        type={currentStatus === 'familiar' ? 'primary' : 'default'}
        style={{
          backgroundColor: currentStatus === 'familiar' ? '#52c41a' : undefined,
          borderColor: currentStatus === 'familiar' ? '#52c41a' : undefined,
        }}
        onClick={(e) => handleClick(e, 'familiar')}
      >
        熟
      </Button>
      <Button
        size="small"
        type={currentStatus === 'mastered' ? 'primary' : 'default'}
        style={{
          backgroundColor: currentStatus === 'mastered' ? '#faad14' : undefined,
          borderColor: currentStatus === 'mastered' ? '#faad14' : undefined,
        }}
        onClick={(e) => handleClick(e, 'mastered')}
      >
        秒
      </Button>
    </Space>
  );
};

export default StatusTags;
