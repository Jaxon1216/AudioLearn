import React, { useState, useEffect } from 'react';
import { List, Card, Tabs } from 'antd';
import { Audio, Category } from '../../types';
import { supabase, isLocalMode } from '../../lib/supabase';
import { useAuth } from '../../contexts/AuthContext';
import AudioItem from './AudioItem';

const categories: Category[] = ['每日跟读', '造句公式', '口语听力', '美式口音', '访谈节目', '雅思'];
const LOCAL_AUDIOS_KEY = 'EastonJiang_local_audios';
const DATA_VERSION_KEY = 'EastonJiang_data_version';
const CURRENT_DATA_VERSION = '5'; // 增加版本号以强制重新加载

const AudioList: React.FC = () => {
  const { user } = useAuth();
  const [audios, setAudios] = useState<Audio[]>([]);
  const [filteredAudios, setFilteredAudios] = useState<Audio[]>([]);
  const [selectedCategory, setSelectedCategory] = useState<Category>('每日跟读');
  const [loading, setLoading] = useState(false);

  const fetchAudios = async () => {
    if (!user) return;

    setLoading(true);
    
    if (isLocalMode) {
      try {
        const storedVersion = localStorage.getItem(DATA_VERSION_KEY);
        const storedAudios = localStorage.getItem(LOCAL_AUDIOS_KEY);
        
        // 如果版本不匹配或没有缓存数据，重新加载
        if (storedVersion !== CURRENT_DATA_VERSION || !storedAudios) {
          // 添加时间戳防止浏览器缓存
          const response = await fetch(`/audios/mock-data.json?t=${Date.now()}`);
          const mockData: Audio[] = await response.json();
          localStorage.setItem(LOCAL_AUDIOS_KEY, JSON.stringify(mockData));
          localStorage.setItem(DATA_VERSION_KEY, CURRENT_DATA_VERSION);
          setAudios(mockData);
          console.log('✅ 已加载新数据，共', mockData.length, '个音频');
          console.log('✅ 造句公式前5个:', mockData.filter(a => a.category === '造句公式').slice(0, 5).map(a => a.title));
        } else {
          setAudios(JSON.parse(storedAudios));
          console.log('✅ 从缓存加载数据');
        }
      } catch (error) {
        console.error('Error loading local audios:', error);
      }
    } else {
      const { data, error } = await supabase
        .from('audios')
        .select('*')
        .eq('user_id', user.id)
        .order('created_at', { ascending: true });

      if (error) {
        console.error('Error fetching audios:', error);
      } else {
        setAudios(data || []);
      }
    }
    setLoading(false);
  };

  useEffect(() => {
    fetchAudios();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [user]);

  useEffect(() => {
    setFilteredAudios(audios.filter((audio) => audio.category === selectedCategory));
  }, [audios, selectedCategory]);

  const handleStatusUpdate = async (audioId: string, status: Audio['status']) => {
    if (isLocalMode) {
      const updatedAudios = audios.map((audio) =>
        audio.id === audioId ? { ...audio, status } : audio
      );
      setAudios(updatedAudios);
      localStorage.setItem(LOCAL_AUDIOS_KEY, JSON.stringify(updatedAudios));
    } else {
      const { error } = await supabase
        .from('audios')
        .update({ status })
        .eq('id', audioId);

      if (error) {
        console.error('Error updating status:', error);
      } else {
        setAudios((prev) =>
          prev.map((audio) => (audio.id === audioId ? { ...audio, status } : audio))
        );
      }
    }
  };

  const tabItems = categories.map((category) => ({
    key: category,
    label: category,
  }));

  return (
    <Card title="音频列表" style={{ margin: '16px', height: '600px' }}>
      <Tabs
        activeKey={selectedCategory}
        onChange={(key) => setSelectedCategory(key as Category)}
        items={tabItems}
      />
      <div style={{ height: '450px', overflowY: 'auto' }}>
        <List
          loading={loading}
          dataSource={filteredAudios}
          locale={{ emptyText: '暂无音频' }}
          renderItem={(audio) => (
            <AudioItem
              key={audio.id}
              audio={audio}
              onStatusUpdate={handleStatusUpdate}
            />
          )}
        />
      </div>
    </Card>
  );
};

export default AudioList;
