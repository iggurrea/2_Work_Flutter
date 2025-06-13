import 'package:flutter/material.dart';
import './screens/quiz_screen.dart';
import './screens/leaderboard_screen.dart';

class StaggerAnimation extends StatelessWidget {
  final AnimationController controller;

  StaggerAnimation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeIn),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "IPv4 Quiz Game",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(userId: 1, level: 1),
                    ),
                  );
                },
                child: Text("Start Level 1 Quiz"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LeaderboardScreen(),
                    ),
                  );
                },
                child: Text("View Leaderboard"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}