import 'package:flutter/material.dart';
import '../questionGenerator.dart';
import '../database_helper.dart';

class QuizScreen extends StatefulWidget {
  final int userId;
  final int level;

  const QuizScreen({super.key, required this.userId, required this.level});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Question _currentQuestion;
  final TextEditingController _answerController = TextEditingController();
  String _feedback = '';
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _loadNewQuestion();
  }

  void _loadNewQuestion() {
    setState(() {
      _currentQuestion = QuestionGenerator.generate(widget.level);
      _feedback = '';
      _answerController.clear();
    });
  }

  void _checkAnswer() async {
    final input = _answerController.text.trim();
    final correct = _currentQuestion.correctAnswer.toLowerCase();
    final isCorrect = input.toLowerCase() == correct;

    int change = 0;
    if (widget.level == 1) change = isCorrect ? 10 : -5;
    if (widget.level == 2) change = isCorrect ? 20 : -10;
    if (widget.level == 3) change = isCorrect ? 30 : -15;

    setState(() {
      _score += change;
      _feedback = isCorrect
          ? "✅ Correct! +$change"
          : "❌ Incorrect. Correct answer: $correct ($change)";
    });

    await DatabaseHelper.instance.updateOrInsertScore(widget.userId, change);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Level ${widget.level} Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Score: $_score", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text(
              _currentQuestion.questionText,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: "Your Answer"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _checkAnswer, child: Text("Submit")),
            const SizedBox(height: 10),
            if (_feedback.isNotEmpty)
              Text(
                _feedback,
                style: TextStyle(
                    color: _feedback.startsWith('✅') ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            const Spacer(),
            ElevatedButton(onPressed: _loadNewQuestion, child: Text("Next Question"))
          ],
        ),
      ),
    );
  }
}