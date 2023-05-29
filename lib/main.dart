import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unreal_remote_control/projects/model/project.dart';
import 'package:unreal_remote_control/remote_control_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ProjectAdapter());

  runApp(
    const RemoteControlApp(),
  );
}
