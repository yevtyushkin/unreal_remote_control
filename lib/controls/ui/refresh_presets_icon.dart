import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/controls/state/connection_status.dart';
import 'package:unreal_remote_control/controls/state/remote_control.dart';

class RefreshPresetsIcon extends StatelessWidget {
  const RefreshPresetsIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isConnected = context.select(
      (RemoteControl rc) => rc.state.connectionStatus == ConnectionStatus.connected,
    );

    return IconButton(
      onPressed: isConnected ? context.read<RemoteControl>().refreshTopLevelPresets : null,
      splashRadius: 0.1,
      icon: const Icon(Icons.refresh),
      tooltip: isConnected ? 'Refresh presets' : 'Not connected',
    );
  }
}
