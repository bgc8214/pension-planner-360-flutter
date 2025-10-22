import 'package:flutter/material.dart';

/// 연금소득공제 상세 설명 다이얼로그
void showPensionIncomeDeductionDetail(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Row(
        children: [
          Text('❓', style: TextStyle(fontSize: 24)),
          SizedBox(width: 8),
          Expanded(child: Text('연금소득공제란?')),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 개념 설명
            const Text(
              '📋 연금소득공제 개념',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                children: [
                  TextSpan(text: '연금소득공제는 '),
                  TextSpan(
                    text: '연금 수령액에서 일정 금액을 공제',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '해주는 제도입니다. 연금은 노후 생활을 위한 소득이므로, 세금 부담을 덜어주기 위해 정부에서 마련한 혜택입니다.'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 공제 구간별 계산법 표
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💰 공제 구간별 계산법',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF065F46)),
                  ),
                  const SizedBox(height: 8),
                  Table(
                    border: TableBorder.all(color: const Color(0xFF10B981)),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(3),
                    },
                    children: const [
                      TableRow(
                        decoration: BoxDecoration(color: Color(0xFF6EE7B7)),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('연금 수령액', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('공제 계산법', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('350만원 이하', style: TextStyle(fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('전액 공제', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ),
                      TableRow(
                        decoration: BoxDecoration(color: Color(0xFFD1FAE5)),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('350 ~ 700만원', style: TextStyle(fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('350만원 + (초과액 × 40%)', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('700 ~ 1,400만원', style: TextStyle(fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('490만원 + (초과액 × 20%)', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                      TableRow(
                        decoration: BoxDecoration(color: Color(0xFFD1FAE5)),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('1,400만원 초과', style: TextStyle(fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('630만원 + (초과액 × 10%)', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('최대 한도', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('900만원', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFDC2626), fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 왜 이렇게 계산하나요?
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFDEEBFF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 왜 이렇게 계산하나요?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E3A8A)),
                  ),
                  SizedBox(height: 8),
                  Text('• 소액 연금 우대: 적은 연금은 거의 세금을 내지 않도록 배려', style: TextStyle(fontSize: 13, color: Color(0xFF1E40AF))),
                  SizedBox(height: 4),
                  Text('• 점진적 부담: 연금액이 많아질수록 점차 세금 부담 증가', style: TextStyle(fontSize: 13, color: Color(0xFF1E40AF))),
                  SizedBox(height: 4),
                  Text('• 노후 보장: 기본 생활비는 세금 없이 보장', style: TextStyle(fontSize: 13, color: Color(0xFF1E40AF))),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('닫기'),
        ),
      ],
    ),
  );
}

/// 인적공제 상세 설명 다이얼로그
void showPersonalDeductionDetail(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Row(
        children: [
          Text('❓', style: TextStyle(fontSize: 24)),
          SizedBox(width: 8),
          Expanded(child: Text('인적공제란?')),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 개념 설명
            const Text(
              '👨‍👩‍👧‍👦 인적공제 개념',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                children: [
                  TextSpan(text: '인적공제는 '),
                  TextSpan(
                    text: '납세자 본인과 부양가족에 대해 일정 금액을 소득에서 빼주는',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' 제도입니다. 기본적인 생활비는 과세하지 않겠다는 정부의 정책입니다.'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 인적공제 항목별 금액 표
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E8FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💰 인적공제 항목별 금액',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF6B21A8)),
                  ),
                  const SizedBox(height: 8),
                  Table(
                    border: TableBorder.all(color: const Color(0xFFA855F7)),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(3),
                    },
                    children: const [
                      TableRow(
                        decoration: BoxDecoration(color: Color(0xFFE9D5FF)),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('구분', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('공제액', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('조건', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('본인', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('150만원', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('무조건 적용', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                      TableRow(
                        decoration: BoxDecoration(color: Color(0xFFF3E8FF)),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('배우자', style: TextStyle(fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('150만원', style: TextStyle(fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('연소득 100만원 이하', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('직계존속', style: TextStyle(fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('150만원', style: TextStyle(fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('60세 이상, 연소득 100만원 이하', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                      TableRow(
                        decoration: BoxDecoration(color: Color(0xFFF3E8FF)),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('직계비속', style: TextStyle(fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('150만원', style: TextStyle(fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('20세 이하, 연소득 100만원 이하', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 연금 수령자의 경우
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📝 연금 수령자의 경우',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF92400E)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '연금을 받는 은퇴자의 경우, 대부분 본인 기본공제 150만원만 적용됩니다. 배우자나 부양가족이 있다면 추가 공제가 가능하지만, 시뮬레이터에서는 기본적으로 150만원으로 계산합니다.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF92400E), height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('닫기'),
        ),
      ],
    ),
  );
}

/// 누진세율표 상세 설명 다이얼로그
void showProgressiveTaxDetail(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Row(
        children: [
          Text('❓', style: TextStyle(fontSize: 24)),
          SizedBox(width: 8),
          Expanded(child: Text('누진세율표와 산출세액이란?')),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 개념 설명
            const Text(
              '📊 누진세율표 개념',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                children: [
                  TextSpan(text: '누진세율표는 '),
                  TextSpan(
                    text: '소득이 많을수록 더 높은 세율을 적용',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '하는 제도입니다. 소득 구간별로 다른 세율을 적용하여 '),
                  TextSpan(
                    text: '소득 재분배 효과',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '를 만듭니다.'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 누진세율표
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📋 2025년 소득세 누진세율표',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF991B1B)),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      border: TableBorder.all(color: const Color(0xFFEF4444)),
                      columnWidths: const {
                        0: FixedColumnWidth(120),
                        1: FixedColumnWidth(60),
                        2: FixedColumnWidth(80),
                      },
                      children: const [
                        TableRow(
                          decoration: BoxDecoration(color: Color(0xFFFECACA)),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(6),
                              child: Text('과세표준', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(6),
                              child: Text('세율', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(6),
                              child: Text('누진공제', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(padding: EdgeInsets.all(6), child: Text('1,400만원 이하', style: TextStyle(fontSize: 11))),
                            Padding(padding: EdgeInsets.all(6), child: Text('6%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                            Padding(padding: EdgeInsets.all(6), child: Text('0원', style: TextStyle(fontSize: 11))),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: Color(0xFFFEE2E2)),
                          children: [
                            Padding(padding: EdgeInsets.all(6), child: Text('1,400 ~ 5,000만원', style: TextStyle(fontSize: 11))),
                            Padding(padding: EdgeInsets.all(6), child: Text('15%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                            Padding(padding: EdgeInsets.all(6), child: Text('126만원', style: TextStyle(fontSize: 11))),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(padding: EdgeInsets.all(6), child: Text('5,000 ~ 8,800만원', style: TextStyle(fontSize: 11))),
                            Padding(padding: EdgeInsets.all(6), child: Text('24%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                            Padding(padding: EdgeInsets.all(6), child: Text('576만원', style: TextStyle(fontSize: 11))),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: Color(0xFFFEE2E2)),
                          children: [
                            Padding(padding: EdgeInsets.all(6), child: Text('8,800 ~ 1.5억원', style: TextStyle(fontSize: 11))),
                            Padding(padding: EdgeInsets.all(6), child: Text('35%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                            Padding(padding: EdgeInsets.all(6), child: Text('1,544만원', style: TextStyle(fontSize: 11))),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(padding: EdgeInsets.all(6), child: Text('1.5억 ~ 3억원', style: TextStyle(fontSize: 11))),
                            Padding(padding: EdgeInsets.all(6), child: Text('38%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                            Padding(padding: EdgeInsets.all(6), child: Text('1,994만원', style: TextStyle(fontSize: 11))),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: Color(0xFFFEE2E2)),
                          children: [
                            Padding(padding: EdgeInsets.all(6), child: Text('3억 ~ 5억원', style: TextStyle(fontSize: 11))),
                            Padding(padding: EdgeInsets.all(6), child: Text('40%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                            Padding(padding: EdgeInsets.all(6), child: Text('2,594만원', style: TextStyle(fontSize: 11))),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(padding: EdgeInsets.all(6), child: Text('5억 ~ 10억원', style: TextStyle(fontSize: 11))),
                            Padding(padding: EdgeInsets.all(6), child: Text('42%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                            Padding(padding: EdgeInsets.all(6), child: Text('3,594만원', style: TextStyle(fontSize: 11))),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: Color(0xFFFEE2E2)),
                          children: [
                            Padding(padding: EdgeInsets.all(6), child: Text('10억원 초과', style: TextStyle(fontSize: 11))),
                            Padding(padding: EdgeInsets.all(6), child: Text('45%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                            Padding(padding: EdgeInsets.all(6), child: Text('6,594만원', style: TextStyle(fontSize: 11))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 누진공제란?
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 누진공제란?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF065F46)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '누진공제는 계산을 간편하게 하기 위한 값입니다. 구간별로 나누어 계산하지 않고, 전체 금액에 해당 구간의 세율을 곱한 후 누진공제액을 빼면 같은 결과가 나옵니다.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF065F46), height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('닫기'),
        ),
      ],
    ),
  );
}

/// 16.5% 분리과세 상세 설명 다이얼로그
void showSeparateTaxDetail(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Row(
        children: [
          Text('❓', style: TextStyle(fontSize: 24)),
          SizedBox(width: 8),
          Expanded(child: Text('16.5% 분리과세란?')),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 개념 설명
            const Text(
              '🏦 분리과세 개념',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                children: [
                  TextSpan(text: '분리과세는 '),
                  TextSpan(
                    text: '다른 소득과 합산하지 않고 별도로 과세',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '하는 제도입니다. 연금소득의 경우 '),
                  TextSpan(
                    text: '16.5% 단일세율',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '을 적용하여 간단하게 계산합니다.'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 분리과세 vs 종합과세 비교표
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFED7AA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📊 분리과세 vs 종합과세',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF9A3412)),
                  ),
                  const SizedBox(height: 8),
                  Table(
                    border: TableBorder.all(color: const Color(0xFFF97316)),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(3),
                      2: FlexColumnWidth(3),
                    },
                    children: const [
                      TableRow(
                        decoration: BoxDecoration(color: Color(0xFFFEDFCA)),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('구분', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('종합과세', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('분리과세', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('세율', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('6% ~ 45% (누진)', style: TextStyle(fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('16.5% (단일)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ),
                      TableRow(
                        decoration: BoxDecoration(color: Color(0xFFFED7AA)),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('공제', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('연금소득공제 + 인적공제', style: TextStyle(fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('공제 없음', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('계산', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('복잡 (구간별 계산)', style: TextStyle(fontSize: 12)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('간단 (연금액 × 16.5%)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 언�� 분리과세가 유리한가요?
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFDEEBFF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🤔 언제 분리과세가 유리한가요?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E3A8A)),
                  ),
                  SizedBox(height: 8),
                  Text('• 연금액이 많은 경우: 누진세율이 16.5%보다 높을 때', style: TextStyle(fontSize: 13, color: Color(0xFF1E40AF))),
                  SizedBox(height: 4),
                  Text('• 다른 소득이 많은 경우: 합산시 높은 구간에 적용될 때', style: TextStyle(fontSize: 13, color: Color(0xFF1E40AF))),
                  SizedBox(height: 4),
                  Text('• 계산이 복잡한 경우: 간단한 계산을 원할 때', style: TextStyle(fontSize: 13, color: Color(0xFF1E40AF))),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 16.5% 구성
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 16.5% 구성',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF92400E)),
                  ),
                  SizedBox(height: 8),
                  Text('• 소득세: 15%', style: TextStyle(fontSize: 13, color: Color(0xFF92400E))),
                  SizedBox(height: 4),
                  Text('• 지방소득세: 1.5% (소득세의 10%)', style: TextStyle(fontSize: 13, color: Color(0xFF92400E))),
                  SizedBox(height: 4),
                  Text('• 합계: 16.5%', style: TextStyle(fontSize: 13, color: Color(0xFF92400E), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('닫기'),
        ),
      ],
    ),
  );
}
