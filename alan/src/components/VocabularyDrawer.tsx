import React, { useMemo, useState } from 'react';
import { Drawer, List, Button, Empty, Popconfirm, message, Alert, Typography, Collapse, Space } from 'antd';
import { DeleteOutlined, CopyOutlined, DeleteFilled } from '@ant-design/icons';
import { useVocabulary } from '../hooks/useVocabulary';
import { Vocabulary } from '../types';

const { Link, Title } = Typography;
const { Panel } = Collapse;

interface VocabularyDrawerProps {
  visible: boolean;
  onClose: () => void;
}

interface GroupedVocabulary {
  [key: string]: Vocabulary[];
}

const VocabularyDrawer: React.FC<VocabularyDrawerProps> = ({ visible, onClose }) => {
  const { vocabulary, loading, removeWord } = useVocabulary();
  const [activeKeys, setActiveKeys] = useState<string[]>([]);

  const handleCopy = async (word: string) => {
    try {
      await navigator.clipboard.writeText(word);
      message.success(`已复制 "${word}"`);
    } catch (error) {
      console.error('Copy failed:', error);
      message.error('复制失败');
    }
  };

  const handleDelete = async (id: string, word: string) => {
    await removeWord(id);
    message.success(`已删除 "${word}"`);
  };

  const handleDeleteMonth = async (monthKey: string, words: Vocabulary[]) => {
    const deletePromises = words.map(word => removeWord(word.id));
    await Promise.all(deletePromises);
    message.success(`已删除 ${monthKey} 的所有单词 (${words.length}个)`);
  };

  // 按月份分组
  const groupedByMonth = useMemo(() => {
    const groups: GroupedVocabulary = {};
    
    vocabulary.forEach((item) => {
      const date = new Date(item.added_at);
      const monthKey = `${date.getFullYear()}年${(date.getMonth() + 1).toString().padStart(2, '0')}月`;
      
      if (!groups[monthKey]) {
        groups[monthKey] = [];
      }
      groups[monthKey].push(item);
    });
    
    // 按月份倒序排序
    return Object.keys(groups)
      .sort((a, b) => b.localeCompare(a))
      .reduce((acc, key) => {
        acc[key] = groups[key];
        return acc;
      }, {} as GroupedVocabulary);
  }, [vocabulary]);

  return (
    <Drawer
      title="生词列表"
      placement="right"
      width={window.innerWidth > 768 ? 400 : '85%'}
      onClose={onClose}
      open={visible}
    >
      <Alert
        message={
          <span>
            由于本项目属于玩具项目阶段，建议前往{' '}
            <Link href="https://www.vocabmap.com/" target="_blank" rel="noopener noreferrer">
              VocabMap
            </Link>{' '}
            进行生词查阅
          </span>
        }
        type="info"
        showIcon
        style={{ marginBottom: 16 }}
      />
      {vocabulary.length === 0 ? (
        <Empty description="暂无生词" />
      ) : (
        <Collapse 
          activeKey={activeKeys} 
          onChange={(keys) => setActiveKeys(keys as string[])}
          style={{ background: 'transparent', border: 'none' }}
        >
          {Object.entries(groupedByMonth).map(([month, words]) => (
            <Panel
              key={month}
              header={
                <Space>
                  <Title level={5} style={{ margin: 0, color: '#1890ff' }}>
                    {month}
                  </Title>
                  <span style={{ color: '#999', fontSize: '14px' }}>
                    ({words.length}个单词)
                  </span>
                </Space>
              }
              extra={
                <Popconfirm
                  title={`确定要删除 ${month} 的所有单词吗？`}
                  description={`将删除 ${words.length} 个单词，此操作不可恢复`}
                  onConfirm={(e) => {
                    e?.stopPropagation();
                    handleDeleteMonth(month, words);
                  }}
                  onCancel={(e) => e?.stopPropagation()}
                  okText="确定删除"
                  cancelText="取消"
                  okButtonProps={{ danger: true }}
                >
                  <Button
                    type="text"
                    danger
                    icon={<DeleteFilled />}
                    size="small"
                    onClick={(e) => e.stopPropagation()}
                    title="删除本月所有单词"
                  />
                </Popconfirm>
              }
            >
              <List
                loading={loading}
                dataSource={words}
                renderItem={(item) => (
                  <List.Item
                    actions={[
                      <Button
                        key="copy"
                        type="text"
                        icon={<CopyOutlined />}
                        onClick={() => handleCopy(item.word)}
                        title="复制单词"
                      />,
                      <Popconfirm
                        key="delete"
                        title="确定要删除这个单词吗？"
                        onConfirm={() => handleDelete(item.id, item.word)}
                        okText="确定"
                        cancelText="取消"
                      >
                        <Button type="text" danger icon={<DeleteOutlined />} title="删除单词" />
                      </Popconfirm>,
                    ]}
                  >
                    <List.Item.Meta
                      title={<span style={{ fontSize: '16px', fontWeight: 'bold' }}>{item.word}</span>}
                      description={
                        <span style={{ fontSize: '12px', color: '#999' }}>
                          {new Date(item.added_at).toLocaleDateString('zh-CN', { 
                            month: 'long', 
                            day: 'numeric' 
                          })}
                        </span>
                      }
                    />
                  </List.Item>
                )}
              />
            </Panel>
          ))}
        </Collapse>
      )}
    </Drawer>
  );
};

export default VocabularyDrawer;
