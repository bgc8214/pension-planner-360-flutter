import 'package:flutter/material.dart';

/// 인적공제 상세 설명 위젯
class PersonalDeductionHelp extends StatelessWidget {
  const PersonalDeductionHelp({super.key});

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
          const Icon(Icons.help_outline, color: Colors.purple, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '인적공제란?',
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
                const Text('👨\u200d👩\u200d👧\u200d👦', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '인적공제 개념',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '인적공제는 납세자 본인과 부양가족에 대해 일정 금액을 소득에서 빼주는 제도입니다. '
                        '기본적인 생활비는 과세하지 않겠다는 정부의 정책입니다.',
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

            // 인적공제 항목별 테이블
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('💰', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        '인적공제 항목별 금액',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.purple.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(Colors.purple.shade100),
                      columnSpacing: 12,
                      horizontalMargin: 0,
                      headingTextStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                      dataTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                          ),
                      border: TableBorder.all(color: Colors.purple.shade200),
                      columns: const [
                        DataColumn(label: Text('구분')),
                        DataColumn(label: Text('대상')),
                        DataColumn(label: Text('공제액')),
                        DataColumn(label: Text('조건')),
                      ],
                      rows: [
                        DataRow(cells: [
                          const DataCell(Text('기본공제', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                          const DataCell(Text('본인', style: TextStyle(fontSize: 11))),
                          const DataCell(Text('150만원', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                          const DataCell(Text('무조건 적용', style: TextStyle(fontSize: 11))),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('배우자', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                          const DataCell(Text('배우자', style: TextStyle(fontSize: 11))),
                          const DataCell(Text('150만원', style: TextStyle(fontSize: 11))),
                          const DataCell(Text('연소득 100만원 이하', style: TextStyle(fontSize: 11))),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('부양가족', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                          const DataCell(Text('직계존속', style: TextStyle(fontSize: 11))),
                          const DataCell(Text('150만원', style: TextStyle(fontSize: 11))),
                          const DataCell(Text('60세 이상, 연소득\n100만원 이하', style: TextStyle(fontSize: 11))),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('부양가족', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                          const DataCell(Text('직계비속', style: TextStyle(fontSize: 11))),
                          const DataCell(Text('150만원', style: TextStyle(fontSize: 11))),
                          const DataCell(Text('20세 이하, 연소득\n100만원 이하', style: TextStyle(fontSize: 11))),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 연금 수령자의 경우
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
                      const Text('📝', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        '연금 수령자의 경우',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.yellow.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '연금을 받는 은퇴자의 경우, 대부분 본인 기본공제 150만원만 적용됩니다. '
                    '배우자나 부양가족이 있다면 추가 공제가 가능하지만, '
                    '시뮬레이터에서는 기본적으로 150만원으로 계산합니다.',
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
}
