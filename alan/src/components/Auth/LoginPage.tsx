import React, { useState } from 'react';
import { Form, Input, Button, Card, message, Tabs } from 'antd';
import { UserOutlined, LockOutlined } from '@ant-design/icons';
import { useAuth } from '../../contexts/AuthContext';
import { useNavigate } from 'react-router-dom';

const LoginPage: React.FC = () => {
  const [loading, setLoading] = useState(false);
  const { signIn, signUp } = useAuth();
  const navigate = useNavigate();

  const onFinishSignIn = async (values: { email: string; password: string }) => {
    setLoading(true);
    try {
      await signIn(values.email, values.password);
      message.success('登录成功！');
      navigate('/');
    } catch (error: any) {
      message.error(error.message || '登录失败');
    } finally {
      setLoading(false);
    }
  };

  const onFinishSignUp = async (values: { email: string; password: string }) => {
    setLoading(true);
    try {
      await signUp(values.email, values.password);
      message.success('注册成功！请查收邮箱验证邮件。');
    } catch (error: any) {
      message.error(error.message || '注册失败');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ 
      display: 'flex', 
      justifyContent: 'center', 
      alignItems: 'center', 
      minHeight: '100vh',
      background: '#f0f2f5',
      padding: '16px'
    }}>
      <Card style={{ width: '100%', maxWidth: 400 }} title="EastonJiang 音频学习">
        <Tabs
          items={[
            {
              key: 'signin',
              label: '登录',
              children: (
                <Form onFinish={onFinishSignIn}>
                  <Form.Item
                    name="email"
                    rules={[{ required: true, message: '请输入邮箱' }, { type: 'email', message: '请输入有效的邮箱' }]}
                  >
                    <Input prefix={<UserOutlined />} placeholder="邮箱" />
                  </Form.Item>
                  <Form.Item
                    name="password"
                    rules={[{ required: true, message: '请输入密码' }]}
                  >
                    <Input.Password prefix={<LockOutlined />} placeholder="密码" />
                  </Form.Item>
                  <Form.Item>
                    <Button type="primary" htmlType="submit" loading={loading} block>
                      登录
                    </Button>
                  </Form.Item>
                </Form>
              ),
            },
            {
              key: 'signup',
              label: '注册',
              children: (
                <Form onFinish={onFinishSignUp}>
                  <Form.Item
                    name="email"
                    rules={[{ required: true, message: '请输入邮箱' }, { type: 'email', message: '请输入有效的邮箱' }]}
                  >
                    <Input prefix={<UserOutlined />} placeholder="邮箱" />
                  </Form.Item>
                  <Form.Item
                    name="password"
                    rules={[{ required: true, message: '请输入密码' }, { min: 6, message: '密码至少6位' }]}
                  >
                    <Input.Password prefix={<LockOutlined />} placeholder="密码（至少6位）" />
                  </Form.Item>
                  <Form.Item>
                    <Button type="primary" htmlType="submit" loading={loading} block>
                      注册
                    </Button>
                  </Form.Item>
                </Form>
              ),
            },
          ]}
        />
      </Card>
    </div>
  );
};

export default LoginPage;
