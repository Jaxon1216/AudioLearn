import React, { useState } from 'react';
import { Layout, Button, Space } from 'antd';
import { LogoutOutlined, BookOutlined } from '@ant-design/icons';
import { useAuth } from '../contexts/AuthContext';
import AudioPlayer from '../components/AudioPlayer/AudioPlayer';
import SubtitleDisplay from '../components/Subtitle/SubtitleDisplay';
import AudioList from '../components/AudioList/AudioList';
import VocabularyDrawer from '../components/VocabularyDrawer';
import './MainPage.css';

const { Header, Content } = Layout;

const MainPage: React.FC = () => {
  const { user, signOut } = useAuth();
  const [vocabDrawerVisible, setVocabDrawerVisible] = useState(false);

  const handleLogout = async () => {
    await signOut();
  };

  return (
    <Layout style={{ minHeight: '100vh' }}>
      <Header className="main-header">
        <h2 className="header-title">EastonJiang 音频学习</h2>
        <Space size="small" className="header-actions">
          <span className="user-email">{user?.email}</span>
          <Button 
            icon={<BookOutlined />} 
            onClick={() => setVocabDrawerVisible(true)}
            className="vocab-button"
          >
            <span className="button-text">生词列表</span>
            <span className="button-text-mobile">生词</span>
          </Button>
          <Button 
            icon={<LogoutOutlined />} 
            onClick={handleLogout}
            className="logout-button"
          >
            <span className="button-text">登出</span>
          </Button>
        </Space>
      </Header>
      <Content className="main-content">
        <div className="content-wrapper">
          <div className="audio-list-container">
            <AudioList />
          </div>
          <div className="player-container">
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
