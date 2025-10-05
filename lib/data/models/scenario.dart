import 'package:hive/hive.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'pension_input.dart';

part 'scenario.freezed.dart';
part 'scenario.g.dart';

/// 시나리오 모델
/// 사용자가 저장한 계산 시나리오
@freezed
class Scenario with _$Scenario {
  @HiveType(typeId: 0, adapterName: 'ScenarioAdapter')
  const factory Scenario({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required PensionInput input,
    @HiveField(3) required DateTime createdAt,
    @HiveField(4) required DateTime updatedAt,
    @HiveField(5) @Default(false) bool isFavorite,
    @HiveField(6) @Default('') String memo,
    @HiveField(7) @Default([]) List<String> tags,
  }) = _Scenario;

  factory Scenario.fromJson(Map<String, dynamic> json) =>
      _$ScenarioFromJson(json);
}
