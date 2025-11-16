import 'package:flutter/material.dart';
import '../models/question.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  final int correctCount;
  final int totalCount;
  final List<Question> questions;
  final List<String> selectedAnswers;

  const ResultScreen({
    super.key,
    required this.correctCount,
    required this.totalCount,
    required this.questions,
    required this.selectedAnswers,
  });

  double get score => (correctCount / totalCount) * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('答题结果'),
        backgroundColor: Colors.pink.shade50,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pink.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 得分展示
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      score >= 80
                          ? Icons.celebration
                          : score >= 60
                              ? Icons.thumb_up
                              : Icons.favorite,
                      size: 64,
                      color: score >= 80
                          ? Colors.amber
                          : score >= 60
                              ? Colors.blue
                              : Colors.pink,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${score.toStringAsFixed(0)}分',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: score >= 80
                            ? Colors.amber.shade700
                            : score >= 60
                                ? Colors.blue.shade700
                                : Colors.pink.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '正确: $correctCount / $totalCount',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getScoreMessage(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 题目解析
              ...questions.asMap().entries.map((entry) {
                final index = entry.key;
                final question = entry.value;
                final userAnswer = selectedAnswers[index];
                final isCorrect = _isAnswerCorrect(question, userAnswer);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCorrect ? Colors.green.shade200 : Colors.red.shade200,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isCorrect ? Icons.check_circle : Icons.cancel,
                            color: isCorrect ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '第 ${index + 1} 题',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        question.question,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '你的答案: $userAnswer',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '正确答案: ${question.answer}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '解析:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              question.explanation,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (question.tip != null && question.tip!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.lightbulb,
                                size: 20,
                                color: Colors.amber.shade700,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  question.tip!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.amber.shade900,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),

              const SizedBox(height: 24),

              // 返回按钮
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade300,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '返回首页',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  bool _isAnswerCorrect(Question question, String userAnswer) {
    if (question.isMultipleChoice) {
      final userAnswers = userAnswer.split(',').map((e) => e.trim()).toList();
      final correctAnswers = question.correctAnswers;
      return userAnswers.length == correctAnswers.length &&
          userAnswers.every((ans) => correctAnswers.contains(ans));
    } else {
      return userAnswer == question.answer;
    }
  }

  String _getScoreMessage() {
    if (score >= 90) {
      return '太棒了！你对这个阶段的育儿知识掌握得很好！';
    } else if (score >= 80) {
      return '很好！继续加油，多学习多实践！';
    } else if (score >= 60) {
      return '不错！还有提升空间，多看看解析和错题本。';
    } else {
      return '没关系，学习是一个过程。多复习错题，相信你会越来越好！';
    }
  }
}

