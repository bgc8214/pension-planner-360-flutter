import 'package:flutter/material.dart';

/// 분리과세 상세 설명 위젯
class SeparateTaxHelp extends StatelessWidget {
  const SeparateTaxHelp({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      childrenPadding: const EdgeInsets.all(16),
      backgroundColor: Theme.of(context).colorScheme.surface,
      collapsedBackgroundColor: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      title: Row(
        children: [
          const Icon(Icons.help_outline, color: Colors.orange, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '16.5% 분리과세란?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 개념 설명
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🏦', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '분리과세 개념',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '분리과세는 다른 소득과 합산하지 않고 별도로 과세하는 제도입니다. '
                        '연금소득의 경우 16.5% 단일세율을 적용하여 간단하게 계산합니다.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 분리과세 vs 종합과세 비교
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('📊', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        '분리과세 vs 종합과세',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.orange.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(Colors.orange.shade100),
                      columnSpacing: 12,
                      horizontalMargin: 0,
                      headingTextStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                      dataTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                          ),
                      border: TableBorder.all(color: Colors.orange.shade200),
                      columns: const [
                        DataColumn(label: Text('구분')),
                        DataColumn(label: Text('종합과세')),
                        DataColumn(label: Text('분리과세')),
                      ],
                      rows: [
                        DataRow(cells: [
                          const DataCell(Text('세율', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                          const DataCell(Text('6% ~ 45% (누진)', style: TextStyle(fontSize: 11))),
                          const DataCell(Text('16.5% (단일)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('공제', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                          const DataCell(Text('연금소득공제\n+ 인적공제', style: TextStyle(fontSize: 11))),
                          const DataCell(Text('공제 없음', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('계산', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                          const DataCell(Text('복잡\n(구간별 계산)', style: TextStyle(fontSize: 11))),
                          const DataCell(Text('간단\n(연금액 × 16.5%)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('다른 소득', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                          const DataCell(Text('합산하여 계산', style: TextStyle(fontSize: 11))),
                          const DataCell(Text('별도 계산', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 언제 분리과세가 유리한가요?
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🤔', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        '언제 분리과세가 유리한가요?',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildBulletPoint(
                    context,
                    '연금액이 많은 경우:',
                    '누진세율이 16.5%보다 높을 때',
                    Colors.blue.shade700,
                  ),
                  const SizedBox(height: 4),
                  _buildBulletPoint(
                    context,
                    '다른 소득이 많은 경우:',
                    '합산시 높은 구간에 적용될 때',
                    Colors.blue.shade700,
                  ),
                  const SizedBox(height: 4),
                  _buildBulletPoint(
                    context,
                    '계산이 복잡한 경우:',
                    '간단한 계산을 원할 때',
                    Colors.blue.shade700,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 16.5% 구성
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.yellow.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('💡', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        '16.5% 구성',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.yellow.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• 소득세: 15%\n'
                    '• 지방소득세: 1.5% (소득세의 10%)\n'
                    '• 합계: 16.5%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.yellow.shade800,
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBulletPoint(
    BuildContext context,
    String title,
    String description,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: TextStyle(color: color)),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    height: 1.4,
                  ),
              children: [
                TextSpan(
                  text: title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: ' '),
                TextSpan(text: description),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
