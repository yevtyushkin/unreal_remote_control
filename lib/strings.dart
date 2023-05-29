// TODO: localization
class Strings {
  const Strings._();

  static const remoteControl = 'Remote Control';
  static const projects = 'Projects';
  static const controls = 'Controls';
  static const selectProjectToUseControls = 'Select a project to use controls';
  static const selectProject = 'Select the project';
  static const createProject = 'Create new project';
  static const enterProjectName = 'Enter the project name';
  static const projectWithThisNameExists = 'A project with this name already exists';
  static const projectNameCantBeEmpty = "Project's name can't be empty";
  static const create = 'Create';
  static const delete = 'Delete';
  static const cancel = 'Cancel';

  static String deleteProject(String name) => 'Delete project $name?';

  static String deleteProjectDescription(String name) => 'Are you sure to delete project $name? This cannot be undone.';
}
