import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unreal_remote_control/app.dart';
import 'package:unreal_remote_control/hive/hive_registrar.g.dart';

Future<void> main() async {
  // App uses https://pub.dev/packages/hive_ce for persisting data. See its
  // documentation for more details.
  await Hive.initFlutter();
  Hive.registerAdapters();

  runApp(
    // [ProviderScope] enables the Riverpod state management for the downstream
    // widgets.
    const ProviderScope(
      child: App(),
    ),
  );
}
