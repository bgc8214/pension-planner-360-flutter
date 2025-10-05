import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/scenario.dart';
import '../models/pension_input.dart';

/// 시나리오 저장소
class ScenarioRepository {
  static const String _boxName = 'scenarios';
  final _uuid = const Uuid();

  /// Box 가져오기 (main.dart에서 이미 열었음)
  Box<Scenario> get _box => Hive.box<Scenario>(_boxName);

  /// 모든 시나리오 조회
  List<Scenario> getAllScenarios() {
    return _box.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  /// 즐겨찾기 시나리오 조회
  List<Scenario> getFavoriteScenarios() {
    return _box.values
        .where((s) => s.isFavorite)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  /// ID로 시나리오 조회
  Scenario? getScenario(String id) {
    return _box.get(id);
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
    final scenarioId = id ?? _uuid.v4();
    final now = DateTime.now();

    final scenario = Scenario(
      id: scenarioId,
      name: name,
      input: input,
      createdAt: id == null ? now : (getScenario(id)?.createdAt ?? now),
      updatedAt: now,
      isFavorite: isFavorite,
      memo: memo,
      tags: tags,
    );

    await _box.put(scenarioId, scenario);
    return scenario;
  }

  /// 시나리오 업데이트
  Future<Scenario> updateScenario(Scenario scenario) async {
    final updated = scenario.copyWith(updatedAt: DateTime.now());
    await _box.put(scenario.id, updated);
    return updated;
  }

  /// 시나리오 삭제
  Future<void> deleteScenario(String id) async {
    await _box.delete(id);
  }

  /// 모든 시나리오 삭제
  Future<void> deleteAllScenarios() async {
    await _box.clear();
  }

  /// 즐겨찾기 토글
  Future<Scenario> toggleFavorite(String id) async {
    final scenario = getScenario(id);
    if (scenario == null) {
      throw Exception('Scenario not found: $id');
    }

    final updated = scenario.copyWith(
      isFavorite: !scenario.isFavorite,
      updatedAt: DateTime.now(),
    );

    await _box.put(id, updated);
    return updated;
  }

  /// 시나리오 복제
  Future<Scenario> duplicateScenario(String id) async {
    final scenario = getScenario(id);
    if (scenario == null) {
      throw Exception('Scenario not found: $id');
    }

    return await saveScenario(
      name: '${scenario.name} (복사본)',
      input: scenario.input,
      memo: scenario.memo,
      tags: scenario.tags,
    );
  }

  /// 스트림으로 시나리오 변경 감지
  Stream<List<Scenario>> watchScenarios() {
    return _box.watch().map((_) => getAllScenarios());
  }

  /// 검색
  List<Scenario> searchScenarios(String query) {
    if (query.isEmpty) return getAllScenarios();

    final lowerQuery = query.toLowerCase();
    return _box.values.where((scenario) {
      return scenario.name.toLowerCase().contains(lowerQuery) ||
          scenario.memo.toLowerCase().contains(lowerQuery) ||
          scenario.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }
}
