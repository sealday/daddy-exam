import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/stage.dart';
import '../services/storage_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  Map<String, Map<String, int>> _progress = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await StorageService.getStageProgress();
    setState(() {
      _progress = progress;
      _isLoading = false;
    });
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.substring(1), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学习统计'),
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '阶段完成度',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...Stage.getStages().map((stage) {
                      final stageProgress = _progress[stage.ageRange] ?? {
                        'completed': 0,
                        'total': 0,
                      };
                      final completed = stageProgress['completed'] ?? 0;
                      final total = stageProgress['total'] ?? 0;
                      final percentage = total > 0 ? (completed / total * 100) : 0.0;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _hexToColor(stage.color).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.child_care,
                                    color: _hexToColor(stage.color),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        stage.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        stage.ageRange,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${percentage.toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: _hexToColor(stage.color),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: total > 0 ? completed / total : 0,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _hexToColor(stage.color),
                              ),
                              minHeight: 8,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '已完成: $completed / $total 题',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    // 饼状图
                    if (_hasAnyProgress())
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '整体掌握情况',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 200,
                              child: PieChart(
                                PieChartData(
                                  sections: _buildPieChartSections(),
                                  centerSpaceRadius: 60,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ..._buildLegend(),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  bool _hasAnyProgress() {
    return _progress.values.any((p) => (p['total'] ?? 0) > 0);
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final stages = Stage.getStages();
    final sections = <PieChartSectionData>[];

    int totalCorrect = 0;
    int totalWrong = 0;

    for (final stage in stages) {
      final progress = _progress[stage.ageRange] ?? {'completed': 0, 'total': 0};
      final completed = progress['completed'] ?? 0;
      final total = progress['total'] ?? 0;
      totalCorrect += completed;
      totalWrong += (total - completed);
    }

    final total = totalCorrect + totalWrong;
    if (total == 0) {
      return [
        PieChartSectionData(
          value: 100,
          color: Colors.grey.shade300,
          title: '暂无数据',
          radius: 60,
        ),
      ];
    }

    if (totalCorrect > 0) {
      sections.add(
        PieChartSectionData(
          value: totalCorrect / total * 100,
          color: Colors.green.shade400,
          title: '${((totalCorrect / total) * 100).toStringAsFixed(0)}%',
          radius: 60,
        ),
      );
    }

    if (totalWrong > 0) {
      sections.add(
        PieChartSectionData(
          value: totalWrong / total * 100,
          color: Colors.red.shade300,
          title: '${((totalWrong / total) * 100).toStringAsFixed(0)}%',
          radius: 60,
        ),
      );
    }

    return sections;
  }

  List<Widget> _buildLegend() {
    final stages = Stage.getStages();
    int totalCorrect = 0;
    int totalWrong = 0;

    for (final stage in stages) {
      final progress = _progress[stage.ageRange] ?? {'completed': 0, 'total': 0};
      final completed = progress['completed'] ?? 0;
      final total = progress['total'] ?? 0;
      totalCorrect += completed;
      totalWrong += (total - completed);
    }

    return [
      _buildLegendItem('正确', Colors.green.shade400, totalCorrect),
      const SizedBox(height: 8),
      _buildLegendItem('错误', Colors.red.shade300, totalWrong),
    ];
  }

  Widget _buildLegendItem(String label, Color color, int count) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        const Spacer(),
        Text(
          '$count 题',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

