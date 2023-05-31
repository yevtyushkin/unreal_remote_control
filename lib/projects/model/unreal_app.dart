import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'unreal_app.freezed.dart';
part 'unreal_app.g.dart';

@HiveType(typeId: 1)
@freezed
class UnrealApp with _$UnrealApp {
  const factory UnrealApp({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String url,
  }) = _UnrealApp;
}
