import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 누진세율표 상세 설명 위젯
class ProgressiveTaxHelp extends StatelessWidget {
  const ProgressiveTaxHelp({super.key});

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');

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
          const Icon(Icons.help_outline, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '누진세율표와 산출세액이란?',
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
                const Text('📊', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '누진세율표 개념',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '누진세율표는 소득이 많을수록 더 높은 세율을 적용하는 제도입니다. '
                        '소득 구간별로 다른 세율을 적용하여 소득 재분배 효과를 만듭니다.',
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

            // 2025년 소득세 누진세율표
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('📋', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        '2025년 소득세 누진세율표',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.red.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(Colors.red.shade100),
                      columnSpacing: 8,
                      horizontalMargin: 0,
                      headingTextStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                      dataTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                          ),
                      border: TableBorder.all(color: Colors.red.shade200),
                      columns: const [
                        DataColumn(label: Text('과세표준')),
                        DataColumn(label: Text('세율')),
                        DataColumn(label: Text('누진공제')),
                        DataColumn(label: Text('계산 예시')),
                      ],
                      rows: [
                        _buildTaxRow('1,400만원 이하', '6%', '0원', '1,000만원 × 6%\n= 60만원'),
                        _buildTaxRow('1,400~5,000만원', '15%', '126만원', '3,000만원 × 15%\n- 126 = 324만원'),
                        _buildTaxRow('5,000~8,800만원', '24%', '576만원', '6,000만원 × 24%\n- 576 = 864만원'),
                        _buildTaxRow('8,800만원~1.5억', '35%', '1,544만원', '1억원 × 35%\n- 1,544 = 1,956만원'),
                        _buildTaxRow('1.5억~3억', '38%', '1,994만원', '2억원 × 38%\n- 1,994 = 5,606만원'),
                        _buildTaxRow('3억~5억', '40%', '2,594만원', '4억원 × 40%\n- 2,594 = 1.14억원'),
                        _buildTaxRow('5억~10억', '42%', '3,594만원', '7억원 × 42%\n- 3,594 = 2.58억원'),
                        _buildTaxRow('10억 초과', '45%', '6,594만원', '15억원 × 45%\n- 6,594 = 6.02억원'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 산출세액 계산 예시
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🧮', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        '산출세액 계산 예시',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '과세표준이 3,950만원인 경우:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• 해당 구간: 1,400만원 ~ 5,000만원 (15% 구간)',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.blue.shade700,
                                height: 1.5,
                              ),
                        ),
                        Text(
                          '• 계산: 3,950만원 × 15% - 126만원 = 466.5만원',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.blue.shade700,
                                height: 1.5,
                              ),
                        ),
                        Text(
                          '• 지방소득세: 466.5만원 × 10% = 46.65만원',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.blue.shade700,
                                height: 1.5,
                              ),
                        ),
                        Text(
                          '• 총 세액: 466.5 + 46.65 = 513.15만원',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 누진공제란?
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
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
                        '누진공제란?',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.green.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '누진공제는 계산을 간편하게 하기 위한 값입니다. '
                    '구간별로 나누어 계산하지 않고, 전체 금액에 해당 구간의 세율을 곱한 후 누진공제액을 빼면 같은 결과가 나옵니다.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.green.shade800,
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

  DataRow _buildTaxRow(String bracket, String rate, String deduction, String example) {
    return DataRow(
      cells: [
        DataCell(Text(bracket, style: const TextStyle(fontSize: 10))),
        DataCell(Text(rate, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
        DataCell(Text(deduction, style: const TextStyle(fontSize: 10))),
        DataCell(Text(example, style: const TextStyle(fontSize: 10))),
      ],
    );
  }
}
