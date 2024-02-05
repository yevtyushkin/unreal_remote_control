import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unreal_remote_control/router.dart';

/// The root widget of the application.
class RemoteControlApp extends StatelessWidget {
  /// Returns a new instance of the [RemoteControlApp].
  const RemoteControlApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
