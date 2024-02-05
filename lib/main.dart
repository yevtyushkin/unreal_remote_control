import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unreal_remote_control/projects/domain/project.dart';
import 'package:unreal_remote_control/remote_control_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initHive();

  runApp(const RemoteControlApp());
}

/// Initialises [Hive] and registers all type adapters.
Future<void> _initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ProjectAdapter());
}
