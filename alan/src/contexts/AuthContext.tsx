import React, { createContext, useContext, useEffect, useState } from 'react';
import { supabase, isLocalMode } from '../lib/supabase';
import { User } from '../types';

interface AuthContextType {
  user: User | null;
  loading: boolean;
  signIn: (email: string, password: string) => Promise<void>;
  signUp: (email: string, password: string) => Promise<void>;
  signOut: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

const LOCAL_USER_KEY = 'EastonJiang_local_user';

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (isLocalMode) {
      const storedUser = localStorage.getItem(LOCAL_USER_KEY);
      if (storedUser) {
        setUser(JSON.parse(storedUser));
      } else {
        const localUser = { id: 'local-user', email: 'test@local.com' };
        localStorage.setItem(LOCAL_USER_KEY, JSON.stringify(localUser));
        setUser(localUser);
      }
      setLoading(false);
    } else {
      supabase.auth.getSession().then(({ data: { session } }) => {
        setUser(session?.user ? { id: session.user.id, email: session.user.email || '' } : null);
        setLoading(false);
      });

      const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
        setUser(session?.user ? { id: session.user.id, email: session.user.email || '' } : null);
      });

      return () => subscription.unsubscribe();
    }
  }, []);

  const signIn = async (email: string, password: string) => {
    if (isLocalMode) {
      const localUser = { id: 'local-user', email };
      localStorage.setItem(LOCAL_USER_KEY, JSON.stringify(localUser));
      setUser(localUser);
      return;
    }
    const { error } = await supabase.auth.signInWithPassword({ email, password });
    if (error) throw error;
  };

  const signUp = async (email: string, password: string) => {
    if (isLocalMode) {
      const localUser = { id: 'local-user', email };
      localStorage.setItem(LOCAL_USER_KEY, JSON.stringify(localUser));
      setUser(localUser);
      return;
    }
    const { error } = await supabase.auth.signUp({ email, password });
    if (error) throw error;
  };

  const signOut = async () => {
    if (isLocalMode) {
      localStorage.removeItem(LOCAL_USER_KEY);
      setUser(null);
      return;
    }
    const { error } = await supabase.auth.signOut();
    if (error) throw error;
  };

  return (
    <AuthContext.Provider value={{ user, loading, signIn, signUp, signOut }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
