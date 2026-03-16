import React, { useState } from 'react';
import { Layout, Button, Space } from 'antd';
import { LogoutOutlined, BookOutlined } from '@ant-design/icons';
import { useAuth } from '../contexts/AuthContext';
import AudioPlayer from '../components/AudioPlayer/AudioPlayer';
import SubtitleDisplay from '../components/Subtitle/SubtitleDisplay';
import AudioList from '../components/AudioList/AudioList';
import VocabularyDrawer from '../components/VocabularyDrawer';

const { Header, Content } = Layout;

const MainPage: React.FC = () => {
  const { user, signOut } = useAuth();
  const [vocabDrawerVisible, setVocabDrawerVisible] = useState(false);

  const handleLogout = async () => {
    await signOut();
  };

  return (
    <Layout style={{ minHeight: '100vh' }}>
      <Header style={{ 
        background: '#fff', 
        padding: '0 24px', 
        display: 'flex', 
        justifyContent: 'space-between', 
        alignItems: 'center',
        boxShadow: '0 2px 8px rgba(0,0,0,0.1)'
      }}>
        <h2 style={{ margin: 0 }}>EastonJiang 音频学习</h2>
        <Space>
          <span>{user?.email}</span>
          <Button icon={<BookOutlined />} onClick={() => setVocabDrawerVisible(true)}>
            生词列表
          </Button>
          <Button icon={<LogoutOutlined />} onClick={handleLogout}>
            登出
          </Button>
        </Space>
      </Header>
      <Content style={{ padding: '16px', background: '#f0f2f5' }}>
        <div style={{ display: 'flex', gap: '16px' }}>
          <div style={{ flex: '0 0 350px' }}>
            <AudioList />
          </div>
          <div style={{ flex: 1 }}>
            <AudioPlayer />
            <SubtitleDisplay />
          </div>
        </div>
      </Content>
      <VocabularyDrawer visible={vocabDrawerVisible} onClose={() => setVocabDrawerVisible(false)} />
    </Layout>
  );
};

export default MainPage;
