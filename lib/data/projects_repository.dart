import 'package:hive_ce/hive.dart';
import 'package:unreal_remote_control/logic/project.dart';

/// Persists [Project]s.
class ProjectsRepository {
  const ProjectsRepository();

  static const String hiveBoxName = 'projects';

  Future<List<Project>> fetchAll() async {
    final box = await Hive.openBox<Project>(hiveBoxName);
    return box.values.toList();
  }

  Future<void> save(Project project) async {
    final box = await Hive.openBox<Project>(hiveBoxName);
    await box.put(project.id, project);
  }

  Future<void> delete(Project project) async {
    final box = await Hive.openBox<Project>(hiveBoxName);
    await box.delete(project.id);
  }
}
