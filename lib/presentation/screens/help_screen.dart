import 'package:flutter/material.dart';
import '../../core/constants/help_texts.dart';

/// 도움말 화면
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도움말'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 2025년 세법 기준
          _buildSection(
            context,
            icon: Icons.info_outline,
            title: '2025년 세법 기준',
            content: HelpTexts.taxLaw2025,
            color: Colors.blue,
          ),
          
          const SizedBox(height: 16),
          
          // 계산 결과 설명
          _buildExpandableSection(
            context,
            icon: Icons.calculate,
            title: '계산 결과 설명',
            items: HelpTexts.resultExplanation,
            color: Colors.green,
          ),
          
          const SizedBox(height: 16),
          
          // 계산 공식
          _buildExpandableSection(
            context,
            icon: Icons.functions,
            title: '계산 공식',
            items: HelpTexts.formulas,
            color: Colors.purple,
          ),
          
          const SizedBox(height: 16),
          
          // FAQ
          _buildExpandableSection(
            context,
            icon: Icons.help_outline,
            title: '자주 묻는 질문',
            items: HelpTexts.faq,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Map<String, String> items,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: ExpansionTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        children: items.entries.map((entry) {
          return ExpansionTile(
            title: Text(
              entry.key,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  entry.value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                      ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
