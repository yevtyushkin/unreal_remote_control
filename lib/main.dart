import 'package:flutter/material.dart';
import 'package:system_theme/system_theme.dart';
import 'package:unreal_remote_control/remote_control_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemTheme.accentColor.load();

  runApp(
    const RemoteControlApp(),
  );
}
