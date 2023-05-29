import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@HiveType(typeId: 0)
@freezed
class Project with _$Project {
  const factory Project({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
}
