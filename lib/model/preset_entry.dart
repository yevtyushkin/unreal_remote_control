import 'package:freezed_annotation/freezed_annotation.dart';

part 'preset_entry.freezed.dart';
part 'preset_entry.g.dart';

@freezed
class PresetEntry with _$PresetEntry {
  const factory PresetEntry({
    required String name,
    @JsonKey(name: 'ID') @Default('') String id,
    @Default('') String path,
  }) = _PresetEntryEntry;

  factory PresetEntry.fromJson(Map<String, dynamic> json) =>
      _$PresetEntryFromJson(json);
}
