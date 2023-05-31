import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/controls/state/remote_control.dart';
import 'package:unreal_remote_control/projects/repository/projects_repository.dart';
import 'package:unreal_remote_control/projects/state/projects_notifier.dart';
import 'package:unreal_remote_control/remote_control_app_body.dart';

class RemoteControlApp extends StatelessWidget {
  const RemoteControlApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => ProjectsNotifier(
            ProjectsRepository(),
          ),
        ),
        ChangeNotifierProxyProvider<ProjectsNotifier, RemoteControl>(
          lazy: false,
          create: (_) => RemoteControl(),
          update: (context, value, maybeRemoteControl) {
            if (maybeRemoteControl == null) return RemoteControl();

            return maybeRemoteControl;
          },
        )
      ],
      child: FluentApp(
        debugShowCheckedModeBanner: false,
        theme: FluentThemeData.dark(),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              lazy: false,
              create: (_) => ProjectsNotifier(
                ProjectsRepository(),
              ),
            ),
            ChangeNotifierProxyProvider<ProjectsNotifier, RemoteControl>(
              lazy: false,
              create: (_) => RemoteControl(),
              update: (context, value, maybeRemoteControl) {
                if (maybeRemoteControl == null) return RemoteControl();

                return maybeRemoteControl;
              },
            )
          ],
          child: const RemoteControlAppBody(),
        ),
      ),
    );
  }
}
