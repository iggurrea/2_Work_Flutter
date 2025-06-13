import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../home_widgets.dart';
import 'quiz_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  final String username;

  const HomeScreen({
    super.key,
    required this.userId,
    required this.username,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  List<Map<String, dynamic>> _topScores = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _controller!.forward();

    _loadUserScores();
  }

  Future<void> _loadUserScores() async {
    final scores =
        await DatabaseHelper.instance.getTopScores();
    setState(() {
      _topScores = scores;
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void _goToQuiz(int level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScreen(userId: widget.userId, level: level),
      ),
    ).then((_) => _loadUserScores()); // Recarga las puntuaciones al volver
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.username}"),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Column(
        children: [
          StaggerAnimation(controller: _controller!),
          const SizedBox(height: 20),
          const Text(
            "Your 5 best scores:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _topScores.isEmpty
              ? const Text("Your don't have points yet")
              : Expanded(
                  child: ListView.builder(
                    itemCount: _topScores.length,
                    itemBuilder: (context, index) {
                      final score = _topScores[index]['score'];
                      return ListTile(
                        leading: Text("#${index + 1}"),
                        title: Text("Points: $score"),
                      );
                    },
                  ),
                ),
          const SizedBox(height: 10),
          const Text("Play:", style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _goToQuiz(1),
                child: const Text("Level 1"),
              ),
              ElevatedButton(
                onPressed: () => _goToQuiz(2),
                child: const Text("Level 2"),
              ),
              ElevatedButton(
                onPressed: () => _goToQuiz(3),
                child: const Text("Level 3"),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
