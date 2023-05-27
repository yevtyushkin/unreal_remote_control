import 'package:fluent_ui/fluent_ui.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: const EdgeInsets.only(top: 16.0),
      content: TabView(
        currentIndex: 0,
        onNewPressed: () {},
        onChanged: (_) {},
        onReorder: (_, __) {},
        tabWidthBehavior: TabWidthBehavior.equal,
        tabs: [
          Tab(text: const Text('Project1'), body: const Center(child: Text('Project1'))),
          Tab(text: const Text('Project2'), body: const Center(child: Text('Project2'))),
        ],
      ),
    );
  }
}
