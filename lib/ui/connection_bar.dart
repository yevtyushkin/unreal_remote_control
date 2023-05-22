import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/state/connection_status.dart';
import 'package:unreal_remote_control/state/remote_control.dart';

class ConnectionBar extends StatelessWidget {
  const ConnectionBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final connectionStatus = context.select<RemoteControl, ConnectionStatus>((rc) => rc.connectionStatus);

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(),
              ),
              hintText: 'WebSocket URL',
            ),
            onChanged: context.read<RemoteControl>().changeConnectionUrl,
          ),
        ),
        TextButton(
          onPressed:
              connectionStatus != ConnectionStatus.connecting ? context.read<RemoteControl>().toggleConnection : null,
          child: Text(
            switch (connectionStatus) {
              ConnectionStatus.connected => 'Disconnect',
              ConnectionStatus.connecting => 'Connecting',
              ConnectionStatus.disconnected => 'Connect'
            },
          ),
        )
      ],
    );
  }
}
