import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/scenario_provider.dart';
import '../providers/pension_input_provider.dart';

/// 시나리오 목록 화면
class ScenarioListScreen extends ConsumerStatefulWidget {
  const ScenarioListScreen({super.key});

  @override
  ConsumerState<ScenarioListScreen> createState() => _ScenarioListScreenState();
}

class _ScenarioListScreenState extends ConsumerState<ScenarioListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final scenarios = ref.watch(scenarioListNotifierProvider);
    final filteredScenarios = _searchQuery.isEmpty
        ? scenarios
        : ref.read(scenarioListNotifierProvider.notifier).searchScenarios(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text('저장된 시나리오'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _showDeleteAllDialog(context),
            tooltip: '전체 삭제',
          ),
        ],
      ),
      body: Column(
        children: [
          // 검색 바
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '시나리오 검색...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // 시나리오 목록
          Expanded(
            child: filteredScenarios.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredScenarios.length,
                    itemBuilder: (context, index) {
                      final scenario = filteredScenarios[index];
                      return _buildScenarioCard(context, scenario);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? '저장된 시나리오가 없습니다' : '검색 결과가 없습니다',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '입력 화면에서 시나리오를 저장해보세요',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioCard(BuildContext context, scenario) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _loadScenario(context, scenario),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 즐겨찾기 아이콘
                  IconButton(
                    icon: Icon(
                      scenario.isFavorite ? Icons.star : Icons.star_border,
                      color: scenario.isFavorite ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () {
                      ref.read(scenarioListNotifierProvider.notifier).toggleFavorite(scenario.id);
                    },
                  ),
                  const SizedBox(width: 8),

                  // 이름
                  Expanded(
                    child: Text(
                      scenario.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),

                  // 더보기 메뉴
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.copy),
                            SizedBox(width: 8),
                            Text('복제'),
                          ],
                        ),
                        onTap: () {
                          Future.delayed(Duration.zero, () {
                            ref.read(scenarioListNotifierProvider.notifier).duplicateScenario(scenario.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('시나리오가 복제되었습니다')),
                            );
                          });
                        },
                      ),
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('삭제', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        onTap: () {
                          Future.delayed(Duration.zero, () {
                            _showDeleteDialog(context, scenario);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),

              if (scenario.memo.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  scenario.memo,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),

              // 태그
              if (scenario.tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: scenario.tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      labelStyle: const TextStyle(fontSize: 12),
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),

              const SizedBox(height: 8),

              // 날짜
              Text(
                '수정: ${dateFormat.format(scenario.updatedAt)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadScenario(BuildContext context, scenario) {
    // 시나리오 로드
    ref.read(pensionInputNotifierProvider.notifier).updateAll(scenario.input);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${scenario.name} 시나리오를 불러왔습니다')),
    );

    Navigator.pop(context);
  }

  void _showDeleteDialog(BuildContext context, scenario) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('시나리오 삭제'),
        content: Text('${scenario.name} 시나리오를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              ref.read(scenarioListNotifierProvider.notifier).deleteScenario(scenario.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('시나리오가 삭제되었습니다')),
              );
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('전체 삭제'),
        content: const Text('모든 시나리오를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              final repository = ref.read(scenarioRepositoryProvider);
              await repository.deleteAllScenarios();
              ref.invalidate(scenarioListNotifierProvider);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('모든 시나리오가 삭제되었습니다')),
                );
              }
            },
            child: const Text('전체 삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
