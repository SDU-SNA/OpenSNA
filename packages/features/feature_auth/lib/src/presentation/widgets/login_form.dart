import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';
import 'package:core_utils/core_utils.dart';

/// 登录表单组件
class LoginForm extends StatefulWidget {
  final VoidCallback? onLogin;
  final VoidCallback? onForgotPassword;
  final bool isLoading;
  final void Function(String username, String password, bool rememberMe)?
      onChanged;

  const LoginForm({
    super.key,
    this.onLogin,
    this.onForgotPassword,
    this.isLoading = false,
    this.onChanged,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onChanged?.call(
        _usernameController.text.trim(),
        _passwordController.text,
        _rememberMe,
      );
      widget.onLogin?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 用户名输入框
          TextFormField(
            controller: _usernameController,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: '学号/工号',
              hintText: '请输入学号或工号',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (Validator.isRequired(value)) {
                return null;
              }
              return '请输入学号或工号';
            },
          ),

          const SizedBox(height: 16),

          // 密码输入框
          TextFormField(
            controller: _passwordController,
            enabled: !widget.isLoading,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: '密码',
              hintText: '请输入密码',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (Validator.isRequired(value)) {
                return null;
              }
              return '请输入密码';
            },
          ),

          const SizedBox(height: 12),

          // 记住密码和忘记密码
          Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: widget.isLoading
                    ? null
                    : (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
              ),
              const Text('记住密码'),
              const Spacer(),
              TextButton(
                onPressed: widget.isLoading ? null : widget.onForgotPassword,
                child: const Text('忘记密码？'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 登录按钮
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      '登录',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String get username => _usernameController.text.trim();
  String get password => _passwordController.text;
  bool get rememberMe => _rememberMe;
}
