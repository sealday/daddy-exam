import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/storage_service.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String appNameCn = '宝爸题库';
  static const String version = 'v1.0.0';
  static const String copyright = '© 2025 sealday';
  static const String supportEmail = 'sealday@gmail.com';

  // TODO: 将该链接替换为你启用 GitHub Pages 后的实际地址
  static const String privacyUrl =
      'https://<your-username>.github.io/<your-repo>/privacy-policy.zh';

  Future<void> _openPrivacy() async {
    final uri = Uri.parse(privacyUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _clearData(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('清除本地数据'),
        content: const Text('将删除错题、阶段进度与每日做题数据，确认继续？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('清除'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await StorageService.clearAll();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已清除本地数据')),
        );
      }
    }
  }

  void _showDisclaimer(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('免责声明'),
        content: const Text(
          '本应用提供的内容仅用于家庭育儿科普学习参考，不构成医疗建议或诊断。'
          '如遇到特殊情况，请咨询专业儿科医生或相关专业人士。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('我知道了'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置与关于'),
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
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
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
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.child_care,
                      color: Colors.pink.shade600,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          appNameCn,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '育儿知识·阶段化学习',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    version,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildActionCard(
              context: context,
              title: '隐私政策',
              subtitle: '查看应用的隐私与数据处理说明',
              icon: Icons.privacy_tip_outlined,
              onTap: _openPrivacy,
            ),
            _buildActionCard(
              context: context,
              title: '免责声明',
              subtitle: '内容仅供科普参考，非医疗建议',
              icon: Icons.info_outline,
              onTap: () => _showDisclaimer(context),
            ),
            _buildActionCard(
              context: context,
              title: '清除本地数据',
              subtitle: '删除错题、进度与每日做题记录',
              icon: Icons.delete_forever_outlined,
              iconColor: Colors.red.shade400,
              onTap: () => _clearData(context),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                '$copyright · $supportEmail',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: iconColor ?? Colors.pink.shade400),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

