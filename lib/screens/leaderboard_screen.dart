import 'package:flutter/material.dart';
import '../database_helper.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Map<String, dynamic>> _topScores = [];

  @override
  void initState() {
    super.initState();
    _loadTopScores();
  }

  Future<void> _loadTopScores() async {
    final scores = await DatabaseHelper.instance.getTopScores();
    setState(() {
      _topScores = scores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Top 5 Scores")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _topScores.isEmpty
            ? Center(child: Text("No scores yet."))
            : ListView.builder(
                itemCount: _topScores.length,
                itemBuilder: (context, index) {
                  final score = _topScores[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text("#${index + 1}")),
                    title: Text(score['username']),
                    trailing: Text("${score['score']} pts"),
                  );
                },
              ),
      ),
    );
  }
}