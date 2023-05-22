import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/state/remote_control.dart';
import 'package:unreal_remote_control/ui/connection_bar.dart';
import 'package:unreal_remote_control/ui/preset_entry_selection_dropdown.dart';
import 'package:unreal_remote_control/ui/preset_overview.dart';
import 'package:unreal_remote_control/ui/refresh_presets_icon.dart';

class RemoteControlApp extends StatelessWidget {
  const RemoteControlApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider<RemoteControl>(
        lazy: false,
        create: (_) => RemoteControl(),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: const Text('Remote control'),
            actions: const [
              RefreshPresetsIcon(),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: PresetEntrySelectionDropdown(),
              ),
            ],
          ),
          body: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: PresetOverview(),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ConnectionBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
