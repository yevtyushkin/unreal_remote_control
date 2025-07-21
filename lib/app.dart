import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:unreal_remote_control/router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp.router(
      title: 'Unreal Engine Remote Control',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorSchemes.darkGreen(),
        radius: 1,
      ),
    );
  }
}
