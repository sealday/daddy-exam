import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/stage.dart';
import '../services/question_service.dart';
import '../services/storage_service.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final Stage stage;

  const QuizScreen({super.key, required this.stage});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  int _currentIndex = 0;
  List<String> _selectedAnswers = [];
  bool _isAnswered = false;
  bool _isLoading = true;
  int _correctCount = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      // 随机获取5-10道题
      final questions = await QuestionService.getRandomQuestions(
        widget.stage.ageRange,
        8,
      );
      setState(() {
        _questions = questions;
        _isLoading = false;
        _selectedAnswers = List.filled(questions.length, '');
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载题目失败: $e')),
        );
      }
    }
  }

  void _selectAnswer(String answer) {
    if (_isAnswered) return;

    setState(() {
      if (_questions[_currentIndex].isMultipleChoice) {
        // 多选题：切换选择
        if (_selectedAnswers[_currentIndex].contains(answer)) {
          _selectedAnswers[_currentIndex] = _selectedAnswers[_currentIndex]
              .replaceAll(answer, '')
              .replaceAll(',,', ',')
              .replaceAll(RegExp(r'^,|,$'), '');
        } else {
          if (_selectedAnswers[_currentIndex].isEmpty) {
            _selectedAnswers[_currentIndex] = answer;
          } else {
            _selectedAnswers[_currentIndex] = '${_selectedAnswers[_currentIndex]},$answer';
          }
        }
      } else {
        // 单选题：直接选择
        _selectedAnswers[_currentIndex] = answer;
      }
    });
  }

  void _submitAnswer() {
    if (_selectedAnswers[_currentIndex].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择一个答案')),
      );
      return;
    }

    setState(() {
      _isAnswered = true;
      final question = _questions[_currentIndex];
      final userAnswer = _selectedAnswers[_currentIndex];
      final correctAnswers = question.correctAnswers;

      // 判断是否正确（多选题需要完全匹配）
      bool isCorrect;
      if (question.isMultipleChoice) {
        final userAnswers = userAnswer.split(',').map((e) => e.trim()).toList();
        isCorrect = userAnswers.length == correctAnswers.length &&
            userAnswers.every((ans) => correctAnswers.contains(ans));
      } else {
        isCorrect = userAnswer == question.answer;
      }

      if (isCorrect) {
        _correctCount++;
      } else {
        // 保存错题
        StorageService.saveWrongQuestion(question);
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _isAnswered = false;
      });
    } else {
      // 完成所有题目，跳转到结果页
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    // 保存进度
    await StorageService.saveStageProgress(
      widget.stage.ageRange,
      _correctCount,
      _questions.length,
    );
    await StorageService.recordDailyQuestions(_questions.length);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            correctCount: _correctCount,
            totalCount: _questions.length,
            questions: _questions,
            selectedAnswers: _selectedAnswers,
          ),
        ),
      );
    }
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.substring(1), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.stage.name),
          backgroundColor: Colors.pink.shade50,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.stage.name),
          backgroundColor: Colors.pink.shade50,
        ),
        body: const Center(child: Text('暂无题目')),
      );
    }

    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stage.name),
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
        child: Column(
          children: [
            // 进度条
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '第 ${_currentIndex + 1} / ${_questions.length} 题',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        '正确: $_correctCount',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _hexToColor(widget.stage.color),
                    ),
                    minHeight: 8,
                  ),
                ],
              ),
            ),

            // 题目内容
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 题目类型标签
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _hexToColor(widget.stage.color).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        question.isMultipleChoice ? '多选题' : '单选题',
                        style: TextStyle(
                          fontSize: 12,
                          color: _hexToColor(widget.stage.color),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 题目
                    Text(
                      question.question,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 选项
                    ...question.options.map((option) {
                      final isSelected = _selectedAnswers[_currentIndex]
                          .split(',')
                          .map((e) => e.trim())
                          .contains(option);
                      final isCorrect = question.correctAnswers.contains(option);
                      final userAnswer = _selectedAnswers[_currentIndex]
                          .split(',')
                          .map((e) => e.trim())
                          .contains(option);

                      Color? optionColor;
                      if (_isAnswered) {
                        if (isCorrect) {
                          optionColor = Colors.green.shade100;
                        } else if (userAnswer && !isCorrect) {
                          optionColor = Colors.red.shade100;
                        }
                      } else if (isSelected) {
                        optionColor = Colors.blue.shade100;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _selectAnswer(option),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: optionColor ?? Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? _hexToColor(widget.stage.color)
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: question.isMultipleChoice
                                          ? BoxShape.rectangle
                                          : BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? _hexToColor(widget.stage.color)
                                            : Colors.grey.shade400,
                                        width: 2,
                                      ),
                                      color: isSelected
                                          ? _hexToColor(widget.stage.color)
                                          : Colors.transparent,
                                    ),
                                    child: isSelected
                                        ? Icon(
                                            question.isMultipleChoice
                                                ? Icons.check
                                                : Icons.circle,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  if (_isAnswered && isCorrect)
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green.shade600,
                                    ),
                                  if (_isAnswered && userAnswer && !isCorrect)
                                    Icon(
                                      Icons.cancel,
                                      color: Colors.red.shade600,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // 底部按钮
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: _isAnswered
                  ? Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _nextQuestion,
                            icon: const Icon(Icons.arrow_forward),
                            label: Text(
                              _currentIndex < _questions.length - 1
                                  ? '下一题'
                                  : '查看结果',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _hexToColor(widget.stage.color),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: _submitAnswer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _hexToColor(widget.stage.color),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '提交答案',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

