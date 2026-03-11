import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';
import '../widgets/login_form.dart';

/// 登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<_LoginFormState>();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: 实现登录逻辑
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('登录成功')),
        );
        // TODO: 导航到首页
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('登录失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('忘记密码'),
        content: const Text('请联系网管会工作人员重置密码'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Icon(
                  Icons.school,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                
                const SizedBox(height: 24),
                
                // 标题
                Text(
                  '山大网管会',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'SDU Network Management Association',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 48),
                
                // 登录表单
                LoginForm(
                  key: _formKey,
                  isLoading: _isLoading,
                  onLogin: _handleLogin,
                  onForgotPassword: _handleForgotPassword,
                ),
                
                const SizedBox(height: 24),
                
                // 其他登录方式
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '其他登录方式',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // 统一身份认证按钮
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : () {
                    // TODO: 实现统一身份认证登录
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('统一身份认证功能开发中')),
                    );
                  },
                  icon: const Icon(Icons.verified_user),
                  label: const Text('统一身份认证登录'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // 注册提示
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('还没有账号？'),
                    TextButton(
                      onPressed: _isLoading ? null : () {
                        // TODO: 导航到注册页面
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('注册功能开发中')),
                        );
                      },
                      child: const Text('立即注册'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
