import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pension_input_provider.dart';
import '../widgets/input/money_input_field.dart';
import '../widgets/input/number_input_field.dart';

/// 입력 화면
class InputScreen extends ConsumerWidget {
  const InputScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(pensionInputNotifierProvider);
    final notifier = ref.read(pensionInputNotifierProvider.notifier);

    return GestureDetector(
      // 화면 터치 시 키보드 닫기
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        // 스크롤 시 키보드 닫기
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(16.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 세액공제 관련 입력
          _buildSection(
            context,
            title: '세액공제 계산',
            icon: Icons.calculate,
            children: [
              MoneyInputField(
                label: '총급여액',
                value: input.totalSalary,
                onChanged: notifier.updateTotalSalary,
                helperText: '연간 총급여액 (세전)',
              ),
              const SizedBox(height: 16),
              MoneyInputField(
                label: '연금저축 납입액',
                value: input.pensionContribution,
                onChanged: notifier.updatePensionContribution,
                helperText: '연간 연금저축 납입액 (공제대상)',
              ),
              const SizedBox(height: 16),
              MoneyInputField(
                label: '연금저축 한도초과 납입액',
                value: input.pensionExcessContribution,
                onChanged: notifier.updatePensionExcessContribution,
                helperText: '600만원 초과 납입액',
              ),
              const SizedBox(height: 16),
              MoneyInputField(
                label: 'IRP 납입액',
                value: input.irpContribution,
                onChanged: notifier.updateIRPContribution,
                helperText: '연간 IRP 납입액 (공제대상)',
              ),
              const SizedBox(height: 16),
              MoneyInputField(
                label: 'IRP 한도초과 납입액',
                value: input.irpExcessContribution,
                onChanged: notifier.updateIRPExcessContribution,
                helperText: '전체 한도 900만원 초과 납입액',
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 나이 관련 입력
          _buildSection(
            context,
            title: '나이 설정',
            icon: Icons.person,
            children: [
              NumberInputField(
                label: '현재 나이',
                suffix: '세',
                value: input.currentAge,
                onChanged: notifier.updateCurrentAge,
                min: 20,
                max: 100,
              ),
              const SizedBox(height: 16),
              NumberInputField(
                label: '은퇴 나이',
                suffix: '세',
                value: input.retirementAge,
                onChanged: notifier.updateRetirementAge,
                min: 20,
                max: 100,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 연금 수령 설정
          _buildSection(
            context,
            title: '연금 수령 설정',
            icon: Icons.savings,
            children: [
              MoneyInputField(
                label: '연간 수령 희망액',
                value: input.annualPensionAmount,
                onChanged: notifier.updateAnnualPensionAmount,
                helperText: '연금으로 수령하고 싶은 연간 금액',
              ),
              const SizedBox(height: 16),
              MoneyInputField(
                label: '연금 외 소득',
                value: input.otherIncome,
                onChanged: notifier.updateOtherIncome,
                helperText: '연금 외 기타 소득 (연간)',
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 수익률 설정
          _buildSection(
            context,
            title: '수익률 설정',
            icon: Icons.trending_up,
            children: [
              DecimalInputField(
                label: '연평균 수익률',
                suffix: '%',
                value: input.averageReturnRate,
                onChanged: notifier.updateAverageReturnRate,
                min: 0,
                max: 50,
                decimals: 1,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 초기화 버튼
          OutlinedButton.icon(
            onPressed: () {
              notifier.reset();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('입력값이 초기화되었습니다')),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text('초기화'),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}
