import 'package:hive_flutter/hive_flutter.dart';
import 'package:unreal_remote_control/common/repository/hive_repository.dart';
import 'package:unreal_remote_control/common/repository/immediate_hive_box_compaction.dart';
import 'package:unreal_remote_control/projects/domain/project.dart';

/// A repository that provides an ability to add, delete, edit projects.
class ProjectsRepository with HiveRepository<Project> {
  @override
  final Future<Box<Project>> box = Hive.openBox<Project>(
    'projects',
    compactionStrategy: immediateHiveBoxCompaction,
  );

  /// Returns a new instance of the [ProjectsRepository].
  ProjectsRepository();
}
