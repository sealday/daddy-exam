class Stage {
  final String name;
  final String description;
  final String ageRange;
  final String color; // 用于UI显示的颜色代码

  Stage({
    required this.name,
    required this.description,
    required this.ageRange,
    required this.color,
  });

  static List<Stage> getStages() {
    return [
      Stage(
        name: '小月龄',
        description: '0-6个月宝宝的育儿知识',
        ageRange: '0-6个月',
        color: '#FFB6C1', // 浅粉色
      ),
      Stage(
        name: '6个月-1岁',
        description: '6个月到1岁宝宝的成长要点',
        ageRange: '6个月-1岁',
        color: '#87CEEB', // 天蓝色
      ),
      Stage(
        name: '1-3岁',
        description: '1到3岁幼儿的发展与教育',
        ageRange: '1-3岁',
        color: '#98D8C8', // 薄荷绿
      ),
    ];
  }
}

