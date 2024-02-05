import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unreal_remote_control/common/repository/hive_type_ids.dart';

part 'project.freezed.dart';
part 'project.g.dart';

/// A model of the project displayed on the projects page.
@HiveType(typeId: projectTypeId)
@freezed
class Project with _$Project {
  /// Returns a new instance of the [Project].
  const factory Project({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String? connectionUrl,
  }) = _Project;

  /// Returns a new instance of the [Project] from the given [json].
  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}
