import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.REACT_APP_SUPABASE_URL || 'https://placeholder.supabase.co';
const supabaseAnonKey = process.env.REACT_APP_SUPABASE_ANON_KEY || 'placeholder-key';

const USE_LOCAL_MODE = !process.env.REACT_APP_SUPABASE_URL;

if (USE_LOCAL_MODE) {
  console.log('🏠 Running in LOCAL MODE - using localStorage instead of Supabase');
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
export const isLocalMode = USE_LOCAL_MODE;
