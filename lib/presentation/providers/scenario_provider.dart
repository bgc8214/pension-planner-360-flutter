import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/scenario.dart';
import '../../data/models/pension_input.dart';
import '../../data/repositories/scenario_repository.dart';

part 'scenario_provider.g.dart';

/// Scenario Repository Provider
@riverpod
ScenarioRepository scenarioRepository(ScenarioRepositoryRef ref) {
  return ScenarioRepository();
}

/// 모든 시나리오 Provider
@riverpod
class ScenarioListNotifier extends _$ScenarioListNotifier {
  @override
  List<Scenario> build() {
    final repository = ref.watch(scenarioRepositoryProvider);
    return repository.getAllScenarios();
  }

  /// 시나리오 저장
  Future<Scenario> saveScenario({
    required String name,
    required PensionInput input,
    String? id,
    String memo = '',
    List<String> tags = const [],
    bool isFavorite = false,
  }) async {
    final repository = ref.read(scenarioRepositoryProvider);
    final scenario = await repository.saveScenario(
      name: name,
      input: input,
      id: id,
      memo: memo,
      tags: tags,
      isFavorite: isFavorite,
    );

    // 상태 업데이트
    state = repository.getAllScenarios();
    return scenario;
  }

  /// 시나리오 삭제
  Future<void> deleteScenario(String id) async {
    final repository = ref.read(scenarioRepositoryProvider);
    await repository.deleteScenario(id);

    // 상태 업데이트
    state = repository.getAllScenarios();
  }

  /// 즐겨찾기 토글
  Future<void> toggleFavorite(String id) async {
    final repository = ref.read(scenarioRepositoryProvider);
    await repository.toggleFavorite(id);

    // 상태 업데이트
    state = repository.getAllScenarios();
  }

  /// 시나리오 복제
  Future<Scenario> duplicateScenario(String id) async {
    final repository = ref.read(scenarioRepositoryProvider);
    final scenario = await repository.duplicateScenario(id);

    // 상태 업데이트
    state = repository.getAllScenarios();
    return scenario;
  }

  /// 검색
  List<Scenario> searchScenarios(String query) {
    final repository = ref.read(scenarioRepositoryProvider);
    return repository.searchScenarios(query);
  }

  /// 즐겨찾기만 조회
  List<Scenario> getFavorites() {
    final repository = ref.read(scenarioRepositoryProvider);
    return repository.getFavoriteScenarios();
  }
}

/// 현재 선택된 시나리오 Provider
@riverpod
class CurrentScenario extends _$CurrentScenario {
  @override
  Scenario? build() {
    return null;
  }

  void selectScenario(Scenario? scenario) {
    state = scenario;
  }

  void clearSelection() {
    state = null;
  }
}
