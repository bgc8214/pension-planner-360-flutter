import 'package:flutter/material.dart';

/// 연금소득공제 상세 설명 위젯
/// 웹 버전의 PensionIncomeDeductionDetail 컴포넌트를 Flutter로 이식
class PensionIncomeDeductionHelp extends StatelessWidget {
  const PensionIncomeDeductionHelp({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDetailToggle(
      context,
      title: '연금소득공제란?',
      iconColor: Colors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 개념 설명
          _buildSection(
            context,
            icon: '📋',
            title: '연금소득공제 개념',
            child: Text(
              '연금소득공제는 연금 수령액에서 일정 금액을 공제해주는 제도입니다. '
              '연금은 노후 생활을 위한 소득이므로, 세금 부담을 덜어주기 위해 정부에서 마련한 혜택입니다.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
          ),
          const SizedBox(height: 16),

          // 공제 구간별 계산법 테이블
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
                    const Text('💰', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      '공제 구간별 계산법',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.green.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildDeductionTable(context),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 왜 이렇게 계산하나요?
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
                    const Text('💡', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      '왜 이렇게 계산하나요?',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildReasonList(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 공제 구간 테이블
  Widget _buildDeductionTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.green.shade100),
        dataRowColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.green.shade50;
            }
            return null;
          },
        ),
        columnSpacing: 12,
        horizontalMargin: 0,
        headingTextStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
        dataTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11,
            ),
        border: TableBorder.all(
          color: Colors.green.shade200,
          width: 1,
        ),
        columns: const [
          DataColumn(label: Text('연금 수령액')),
          DataColumn(label: Text('공제 계산법')),
          DataColumn(label: Text('예시')),
        ],
        rows: [
          _buildDataRow(
            '350만원 이하',
            '전액 공제',
            '300만원 → 300만원 공제',
            isBold: true,
          ),
          _buildDataRow(
            '350~700만원',
            '350만원 + (초과액 × 40%)',
            '500만원 → 350 + (150×0.4)\n= 410만원',
          ),
          _buildDataRow(
            '700~1,400만원',
            '490만원 + (초과액 × 20%)',
            '1,000만원 → 490 + (300×0.2)\n= 550만원',
          ),
          _buildDataRow(
            '1,400만원 초과',
            '630만원 + (초과액 × 10%)',
            '2,000만원 → 630 + (600×0.1)\n= 690만원',
          ),
          DataRow(
            cells: [
              const DataCell(Text(
                '최대 한도',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              const DataCell(Text(
                '900만원',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              )),
              const DataCell(Text(
                '5,000만원 → 900만원\n(한도 적용)',
                style: TextStyle(fontSize: 11),
              )),
            ],
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(String income, String calculation, String example,
      {bool isBold = false}) {
    return DataRow(
      cells: [
        DataCell(Text(
          income,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: 11,
          ),
        )),
        DataCell(Text(
          calculation,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: 11,
          ),
        )),
        DataCell(Text(
          example,
          style: const TextStyle(fontSize: 11),
        )),
      ],
    );
  }

  /// 이유 설명 리스트
  Widget _buildReasonList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReasonItem(
          context,
          '소액 연금 우대:',
          '적은 연금은 거의 세금을 내지 않도록 배려',
        ),
        const SizedBox(height: 4),
        _buildReasonItem(
          context,
          '점진적 부담:',
          '연금액이 많아질수록 점차 세금 부담 증가',
        ),
        const SizedBox(height: 4),
        _buildReasonItem(
          context,
          '노후 보장:',
          '기본 생활비는 세금 없이 보장',
        ),
      ],
    );
  }

  Widget _buildReasonItem(BuildContext context, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.blue.shade700,
              ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blue.shade700,
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

  /// 섹션 빌더
  Widget _buildSection(
    BuildContext context, {
    required String icon,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  /// 토글 가능한 상세 설명 컨테이너
  Widget _buildDetailToggle(
    BuildContext context, {
    required String title,
    required Color iconColor,
    required Widget child,
  }) {
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
          Icon(
            Icons.help_outline,
            color: iconColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
      children: [child],
    );
  }
}
