import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/question.dart';

class StorageService {
  static const String _wrongQuestionsKey = 'wrong_questions';
  static const String _stageProgressKey = 'stage_progress';
  static const String _dailyQuestionsKey = 'daily_questions';

  // 保存错题
  static Future<void> saveWrongQuestion(Question question) async {
    final prefs = await SharedPreferences.getInstance();
    final wrongQuestionsJson = prefs.getStringList(_wrongQuestionsKey) ?? [];
    
    // 检查是否已存在
    final questionJson = jsonEncode(question.toJson());
    if (!wrongQuestionsJson.contains(questionJson)) {
      wrongQuestionsJson.add(questionJson);
      await prefs.setStringList(_wrongQuestionsKey, wrongQuestionsJson);
    }
  }

  // 获取所有错题
  static Future<List<Question>> getWrongQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final wrongQuestionsJson = prefs.getStringList(_wrongQuestionsKey) ?? [];
    
    return wrongQuestionsJson.map((json) {
      return Question.fromJson(jsonDecode(json));
    }).toList();
  }

  // 删除错题
  static Future<void> removeWrongQuestion(int questionId) async {
    final prefs = await SharedPreferences.getInstance();
    final wrongQuestionsJson = prefs.getStringList(_wrongQuestionsKey) ?? [];
    
    wrongQuestionsJson.removeWhere((json) {
      final question = Question.fromJson(jsonDecode(json));
      return question.id == questionId;
    });
    
    await prefs.setStringList(_wrongQuestionsKey, wrongQuestionsJson);
  }

  // 保存阶段进度
  static Future<void> saveStageProgress(String stage, int completed, int total) async {
    final prefs = await SharedPreferences.getInstance();
    final progressJson = prefs.getString(_stageProgressKey) ?? '{}';
    final progress = jsonDecode(progressJson) as Map<String, dynamic>;
    
    progress[stage] = {
      'completed': completed,
      'total': total,
    };
    
    await prefs.setString(_stageProgressKey, jsonEncode(progress));
  }

  // 获取阶段进度
  static Future<Map<String, Map<String, int>>> getStageProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progressJson = prefs.getString(_stageProgressKey) ?? '{}';
    final progress = jsonDecode(progressJson) as Map<String, dynamic>;
    
    return progress.map((key, value) {
      final v = value as Map<String, dynamic>;
      return MapEntry(key, {
        'completed': v['completed'] as int? ?? 0,
        'total': v['total'] as int? ?? 0,
      });
    });
  }

  // 记录每日答题数量
  static Future<void> recordDailyQuestions(int count) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    final dailyJson = prefs.getString(_dailyQuestionsKey) ?? '{}';
    final daily = jsonDecode(dailyJson) as Map<String, dynamic>;
    
    daily[today] = (daily[today] as int? ?? 0) + count;
    
    await prefs.setString(_dailyQuestionsKey, jsonEncode(daily));
  }

  // 获取今日答题数量
  static Future<int> getTodayQuestionsCount() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    final dailyJson = prefs.getString(_dailyQuestionsKey) ?? '{}';
    final daily = jsonDecode(dailyJson) as Map<String, dynamic>;
    
    return daily[today] as int? ?? 0;
  }

  // 一键清除本地数据（进度、错题、每日做题数）
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_wrongQuestionsKey);
    await prefs.remove(_stageProgressKey);
    await prefs.remove(_dailyQuestionsKey);
  }
}

