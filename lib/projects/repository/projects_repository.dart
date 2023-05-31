import 'package:hive_flutter/hive_flutter.dart';
import 'package:unreal_remote_control/projects/model/project.dart';

class ProjectsRepository {
  ProjectsRepository();

  final _projectsBox = Hive.openBox<Project>('projects', compactionStrategy: _immediateCompaction);

  static bool _immediateCompaction(int entries, int deleted) => deleted >= 1;

  Future<List<Project>> allProjects() async {
    final box = await _projectsBox;
    return box.values.toList();
  }

  Future<void> addProject(Project project) async {
    final box = await _projectsBox;
    await box.put(project.id, project);
  }

  Future<void> deleteProject(Project project) async {
    final box = await _projectsBox;
    await box.delete(project.id);
  }
}
