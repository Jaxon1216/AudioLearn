import { useState, useEffect } from 'react';
import { supabase, isLocalMode } from '../lib/supabase';
import { Vocabulary } from '../types';
import { useAuth } from '../contexts/AuthContext';

const LOCAL_VOCABULARY_KEY = 'EastonJiang_local_vocabulary';

export const useVocabulary = () => {
  const { user } = useAuth();
  const [vocabulary, setVocabulary] = useState<Vocabulary[]>([]);
  const [loading, setLoading] = useState(false);

  const fetchVocabulary = async () => {
    if (!user) return;
    
    setLoading(true);
    if (isLocalMode) {
      const stored = localStorage.getItem(LOCAL_VOCABULARY_KEY);
      setVocabulary(stored ? JSON.parse(stored) : []);
    } else {
      const { data, error } = await supabase
        .from('vocabulary')
        .select('*')
        .eq('user_id', user.id)
        .order('added_at', { ascending: false });

      if (error) {
        console.error('Error fetching vocabulary:', error);
      } else {
        setVocabulary(data || []);
      }
    }
    setLoading(false);
  };

  useEffect(() => {
    fetchVocabulary();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [user]);

  const addWord = async (word: string, audioId?: string) => {
    if (!user) return;

    const existingWord = vocabulary.find((v) => v.word.toLowerCase() === word.toLowerCase());
    if (existingWord) return;

    if (isLocalMode) {
      const newWord: Vocabulary = {
        id: Date.now().toString(),
        word,
        audio_id: audioId || null,
        user_id: user.id,
        added_at: new Date().toISOString(),
      };
      const updated = [newWord, ...vocabulary];
      setVocabulary(updated);
      localStorage.setItem(LOCAL_VOCABULARY_KEY, JSON.stringify(updated));
    } else {
      const { error } = await supabase
        .from('vocabulary')
        .insert([
          {
            word,
            audio_id: audioId || null,
            user_id: user.id,
          },
        ]);

      if (error) {
        console.error('Error adding word:', error);
      } else {
        fetchVocabulary();
      }
    }
  };

  const removeWord = async (id: string) => {
    if (isLocalMode) {
      const updated = vocabulary.filter((v) => v.id !== id);
      setVocabulary(updated);
      localStorage.setItem(LOCAL_VOCABULARY_KEY, JSON.stringify(updated));
    } else {
      const { error } = await supabase.from('vocabulary').delete().eq('id', id);

      if (error) {
        console.error('Error removing word:', error);
      } else {
        fetchVocabulary();
      }
    }
  };

  return {
    vocabulary,
    loading,
    addWord,
    removeWord,
    refreshVocabulary: fetchVocabulary,
  };
};
