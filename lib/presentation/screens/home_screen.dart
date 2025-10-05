import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'input_screen.dart';
import 'result_screen.dart';
import 'scenario_list_screen.dart';
import 'settings_screen.dart';
import '../providers/pension_input_provider.dart';
import '../providers/scenario_provider.dart';

/// 홈 화면 (탭 네비게이션)
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  final GlobalKey<ResultScreenState> _resultScreenKey = GlobalKey<ResultScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('연금 플래너 360'),
        centerTitle: true,
        actions: [
          // 결과 탭일 때만 공유 버튼 표시
          if (_currentIndex == 1)
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () {
                _resultScreenKey.currentState?.showShareOptions();
              },
              tooltip: '결과 공유',
            ),
          // 불러오기 버튼
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScenarioListScreen(),
                ),
              );
            },
            tooltip: '시나리오 불러오기',
          ),
          // 저장 버튼
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _showSaveDialog(context),
            tooltip: '현재 시나리오 저장',
          ),
          // 설정 버튼
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            tooltip: '설정',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const InputScreen(),
          ResultScreen(key: _resultScreenKey),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.edit_outlined),
            selectedIcon: Icon(Icons.edit),
            label: '입력',
          ),
          NavigationDestination(
            icon: Icon(Icons.assessment_outlined),
            selectedIcon: Icon(Icons.assessment),
            label: '결과',
          ),
        ],
      ),
    );
  }

  void _showSaveDialog(BuildContext context) {
    final nameController = TextEditingController();
    final memoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('시나리오 저장'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '시나리오 이름',
                hintText: '예: 공격적 투자 플랜',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: memoController,
              decoration: const InputDecoration(
                labelText: '메모 (선택)',
                hintText: '시나리오에 대한 설명',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('시나리오 이름을 입력하세요')),
                );
                return;
              }

              final input = ref.read(pensionInputNotifierProvider);
              await ref.read(scenarioListNotifierProvider.notifier).saveScenario(
                    name: nameController.text.trim(),
                    input: input,
                    memo: memoController.text.trim(),
                  );

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${nameController.text} 저장 완료')),
                );
              }
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }
}
