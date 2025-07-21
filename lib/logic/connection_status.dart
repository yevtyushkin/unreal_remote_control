import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_status.freezed.dart';

/// Connection status between the app and the Unreal Engine instance.
@freezed
sealed class ConnectionStatus with _$ConnectionStatus {
  const factory ConnectionStatus.connecting() = Connecting;

  const factory ConnectionStatus.connected() = Connected;

  const factory ConnectionStatus.failed(String err) = Failed;
}
