import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './contexts/AuthContext';
import { AudioProvider } from './contexts/AudioContext';
import LoginPage from './components/Auth/LoginPage';
import PrivateRoute from './components/Auth/PrivateRoute';
import MainPage from './pages/MainPage';
import 'antd/dist/reset.css';
import './App.css';

function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <AudioProvider>
          <Routes>
            <Route path="/login" element={<LoginPage />} />
            <Route
              path="/"
              element={
                <PrivateRoute>
                  <MainPage />
                </PrivateRoute>
              }
            />
            <Route path="*" element={<Navigate to="/" />} />
          </Routes>
        </AudioProvider>
      </AuthProvider>
    </BrowserRouter>
  );
}

export default App;
