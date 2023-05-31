import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unreal_remote_control/projects/model/unreal_app.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@HiveType(typeId: 0)
@freezed
class Project with _$Project {
  const factory Project({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required DateTime createdAt,
    @HiveField(3) required List<UnrealApp> apps,
  }) = _Project;
}
