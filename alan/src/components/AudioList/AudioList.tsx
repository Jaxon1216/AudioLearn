import React, { useState, useEffect } from 'react';
import { List, Card, Tabs } from 'antd';
import { Audio, Category } from '../../types';
import { supabase, isLocalMode } from '../../lib/supabase';
import { useAuth } from '../../contexts/AuthContext';
import AudioItem from './AudioItem';

const categories: Category[] = ['每日跟读', '造句公式', '口语听力', '美式口音', '访谈节目', '雅思'];
const LOCAL_AUDIOS_KEY = 'alan_local_audios';

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
        const storedAudios = localStorage.getItem(LOCAL_AUDIOS_KEY);
        if (storedAudios) {
          setAudios(JSON.parse(storedAudios));
        } else {
          const response = await fetch('/audios/mock-data.json');
          const mockData: Audio[] = await response.json();
          localStorage.setItem(LOCAL_AUDIOS_KEY, JSON.stringify(mockData));
          setAudios(mockData);
        }
      } catch (error) {
        console.error('Error loading local audios:', error);
      }
    } else {
      const { data, error } = await supabase
        .from('audios')
        .select('*')
        .eq('user_id', user.id)
        .order('created_at', { ascending: false });

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
