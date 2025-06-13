import 'package:flutter/material.dart';
import '../database_helper.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() => _message = 'Please enter both fields');
      return;
    }

    final users = await DatabaseHelper.instance.queryAllUsers();
    final user = users.firstWhere(
      (u) => u['username'] == username && u['password'] == password,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      final userId = user['id'] as int;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(userId: userId, username: username),
        ),
      );
    } else {
      setState(() => _message = 'Invalid username or password');
    }
  }

  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() => _message = 'Please enter both fields');
      return;
    }

    final result = await DatabaseHelper.instance.insertUser(username, password);
    if (result == -1) {
      setState(() => _message = 'User already exists');
    } else {
      setState(() => _message = 'User registered! You can now log in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
            TextButton(onPressed: _register, child: const Text('Register')),
            const SizedBox(height: 10),
            Text(
              _message,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}