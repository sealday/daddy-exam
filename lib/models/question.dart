class Question {
  final int id;
  final String stage;
  final String question;
  final List<String> options;
  final String answer; // 单选时是单个答案，多选时是逗号分隔的答案
  final String explanation;
  final String? tip; // 实用小贴士
  final String category; // 营养、睡眠、认知、社交、疾病防护等

  Question({
    required this.id,
    required this.stage,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
    this.tip,
    required this.category,
  });

  // 判断是否为多选题
  bool get isMultipleChoice => answer.contains(',');

  // 获取正确答案列表
  List<String> get correctAnswers => answer.split(',').map((e) => e.trim()).toList();

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      stage: json['stage'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      answer: json['answer'] as String,
      explanation: json['explanation'] as String,
      tip: json['tip'] as String?,
      category: json['category'] as String? ?? '通用',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stage': stage,
      'question': question,
      'options': options,
      'answer': answer,
      'explanation': explanation,
      'tip': tip,
      'category': category,
    };
  }
}

