import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/v7.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
abstract class Project with _$Project {
  const factory Project({
    required String id,
    required String name,

    /// URL that is used as base in the [RemoteControlApiClient].
    required String url,
  }) = _Project;

  factory Project.empty() => Project(
    id: const UuidV7().generate(),
    name: 'New project',
    url: 'http://localhost:30010/',
  );

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}
