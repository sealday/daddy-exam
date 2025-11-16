import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuestionService {
  static List<Question>? _questions;

  // 加载题库
  static Future<List<Question>> loadQuestions() async {
    if (_questions != null) {
      return _questions!;
    }

    try {
      final String jsonString = await rootBundle.loadString('assets/questions.json');
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      _questions = jsonList.map((json) => Question.fromJson(json as Map<String, dynamic>)).toList();
      return _questions!;
    } catch (e) {
      print('加载题库失败: $e');
      return [];
    }
  }

  // 根据阶段获取题目
  static Future<List<Question>> getQuestionsByStage(String stage) async {
    final allQuestions = await loadQuestions();
    return allQuestions.where((q) => q.stage == stage).toList();
  }

  // 随机获取题目
  static Future<List<Question>> getRandomQuestions(String stage, int count) async {
    final questions = await getQuestionsByStage(stage);
    questions.shuffle();
    return questions.take(count).toList();
  }

  // 根据ID获取题目
  static Future<Question?> getQuestionById(int id) async {
    final allQuestions = await loadQuestions();
    try {
      return allQuestions.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }
}

