import 'package:hive_flutter/hive_flutter.dart';
import 'package:unreal_remote_control/projects/model/project.dart';

class ProjectsRepository {
  const ProjectsRepository();

  Future<List<Project>> allProjects() async {
    final box = await Hive.openBox<Project>('projects');
    return box.values.toList();
  }

  Future<void> addProject(Project project) async {
    final box = await Hive.openBox<Project>('projects');
    await box.put(project.id, project);
  }
}
