import { useEffect, useRef } from 'react';
import { supabase, isLocalMode } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';

const LOCAL_PROGRESS_KEY = 'EastonJiang_local_progress';

export const usePlaybackProgress = (
  audioId: string | null,
  currentTime: number,
  seek: (time: number) => void
) => {
  const { user } = useAuth();
  const saveTimeoutRef = useRef<NodeJS.Timeout | undefined>(undefined);
  const hasLoadedProgressRef = useRef<boolean>(false);

  useEffect(() => {
    if (!audioId || !user) {
      hasLoadedProgressRef.current = false;
      return;
    }

    const loadProgress = async () => {
      if (isLocalMode) {
        const stored = localStorage.getItem(LOCAL_PROGRESS_KEY);
        if (stored) {
          const progressMap = JSON.parse(stored);
          const position = progressMap[audioId];
          if (position > 0) {
            seek(position);
          }
        }
        hasLoadedProgressRef.current = true;
      } else {
        const { data, error } = await supabase
          .from('playback_progress')
          .select('position')
          .eq('audio_id', audioId)
          .eq('user_id', user.id)
          .single();

        if (!error && data && data.position > 0) {
          seek(data.position);
        }
        hasLoadedProgressRef.current = true;
      }
    };

    if (!hasLoadedProgressRef.current) {
      loadProgress();
    }
  }, [audioId, user, seek]);

  useEffect(() => {
    if (!audioId || !user || !hasLoadedProgressRef.current) return;

    if (saveTimeoutRef.current) {
      clearTimeout(saveTimeoutRef.current);
    }

    saveTimeoutRef.current = setTimeout(async () => {
      if (isLocalMode) {
        const stored = localStorage.getItem(LOCAL_PROGRESS_KEY);
        const progressMap = stored ? JSON.parse(stored) : {};
        progressMap[audioId] = currentTime;
        localStorage.setItem(LOCAL_PROGRESS_KEY, JSON.stringify(progressMap));
      } else {
        await supabase.from('playback_progress').upsert(
          {
            audio_id: audioId,
            user_id: user.id,
            position: currentTime,
          },
          {
            onConflict: 'audio_id,user_id',
          }
        );
      }
    }, 2000);

    return () => {
      if (saveTimeoutRef.current) {
        clearTimeout(saveTimeoutRef.current);
      }
    };
  }, [audioId, user, currentTime]);
};
