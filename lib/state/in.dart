import 'package:freezed_annotation/freezed_annotation.dart';

part 'in.freezed.dart'; // TODO:
part 'in.g.dart';

@freezed
class HttpResponseEnvelope with _$HttpResponseEnvelope {
  const HttpResponseEnvelope._();

  const factory HttpResponseEnvelope({
    required int requestId,
    required int responseCode,
    required Map<String, dynamic>? responseBody,
  }) = _HttpResponseEnvelope;

  HttpResponse? get response {
    final _responseBody = responseBody;

    if (_responseBody == null) return null;

    return HttpResponse.customFromJson(_responseBody);
  }

  factory HttpResponseEnvelope.fromJson(Map<String, dynamic> json) => _$HttpResponseEnvelopeFromJson(json);
}

@freezed
sealed class HttpResponse with _$HttpResponse {
  const factory HttpResponse.allPresets({
    required List<PresetEntry> presets,
  }) = AllPresets;

  const factory HttpResponse.getPreset({
    required PresetInfo preset,
  }) = GetPreset;

  const factory HttpResponse.getExposedProperty({
    required ExposedPropertyDescription exposedPropertyDescription,
    required List<PropertyValue> propertyValues,
  }) = GetExposedProperty;

  // TODO: metadata related

  factory HttpResponse.customFromJson(Map<String, dynamic> json) {
    if (json.containsKey('Presets')) return AllPresets.fromJson(json);
    if (json.containsKey('Preset')) return GetPreset.fromJson(json);
    if (json.containsKey('ExposedPropertyDescription')) return GetExposedProperty.fromJson(json);

    throw "Can't parse $json into HttpResponse";
  }

  factory HttpResponse.fromJson(Map<String, dynamic> json) => _$HttpResponseFromJson(json);
}

@freezed
class PresetEntry with _$PresetEntry {
  const factory PresetEntry({
    required String name,
    @JsonKey(defaultValue: '') required String path,
    @JsonKey(name: 'ID', defaultValue: '') required String id,
  }) = _PresetEntry;

  factory PresetEntry.fromJson(Map<String, dynamic> json) => _$PresetEntryFromJson(json);
}

@freezed
class PresetInfo with _$PresetInfo {
  const factory PresetInfo({
    required String name,
    @JsonKey(defaultValue: '') required String path,
    @JsonKey(name: 'ID', defaultValue: '') required String id,
    required List<PresetGroup> groups,
  }) = _PresetInfo;

  factory PresetInfo.fromJson(Map<String, dynamic> json) => _$PresetInfoFromJson(json);
}

@freezed
class ExposedPropertyDescription with _$ExposedPropertyDescription {
  const factory ExposedPropertyDescription({
    required String displayName,
    @JsonKey(name: 'ID', defaultValue: '') required String id,
    required UnderlyingProperty underlyingProperty,
  }) = _ExposedPropertyDescription;

  factory ExposedPropertyDescription.fromJson(Map<String, dynamic> json) => _$ExposedPropertyDescriptionFromJson(json);
}

@freezed
class PropertyValue with _$PropertyValue {
  const factory PropertyValue({
    required dynamic propertyValue,
  }) = _PropertyValue;

  factory PropertyValue.fromJson(Map<String, dynamic> json) => _$PropertyValueFromJson(json);
}

@freezed
class PresetEvent with _$PresetEvent {
  const factory PresetEvent.presetFieldsChanged({
    required String presetName,
    required List<ChangedField> changedFields,
  }) = PresetFieldsChanged;

  const factory PresetEvent.presetFieldsAdded({
    required String presetName,
    required PresetFieldsAddedDescription description,
  }) = PresetFieldsAdded;

  const factory PresetEvent.presetFieldsRemoved({
    required String presetName,
    required List<String> removedFields,
  }) = PresetFieldsRemoved;

  const factory PresetEvent.presetFieldsRenamed({
    required String presetName,
    required Map<String, String> renamedFields,
  }) = PresetFieldsRenamed;

  factory PresetEvent.fromJson(Map<String, dynamic> json) => _$PresetEventFromJson(json);
}

@freezed
class PresetFieldsAddedDescription with _$PresetFieldsAddedDescription {
  const factory PresetFieldsAddedDescription({
    required String name,
    required String path,
    required List<PresetGroup> groups,
  }) = _PresetFieldsAddedDescription;

  factory PresetFieldsAddedDescription.fromJson(Map<String, dynamic> json) =>
      _$PresetFieldsAddedDescriptionFromJson(json);
}

@freezed
class ChangedField with _$ChangedField {
  const factory ChangedField({
    required String propertyLabel,
    required String objectPath,
    required dynamic propertyValue,
  }) = _ChangedField;

  factory ChangedField.fromJson(Map<String, dynamic> json) => _$ChangedFieldFromJson(json);
}

@freezed
class PresetGroup with _$PresetGroup {
  const factory PresetGroup({
    required String name,
    required List<ExposedProperty> exposedProperties,
    // TODO: exposed functions, exposed actors
  }) = _PresetGroup;

  factory PresetGroup.fromJson(Map<String, dynamic> json) => _$PresetGroupFromJson(json);
}

@freezed
class ExposedProperty with _$ExposedProperty {
  const factory ExposedProperty({
    required String displayName,
    @JsonKey(name: 'ID', defaultValue: '') required String id,
    required UnderlyingProperty underlyingProperty,
    @JsonKey(defaultValue: {}) required Map<String, dynamic> metaData,
  }) = _ExposedProperty;

  factory ExposedProperty.fromJson(Map<String, dynamic> json) => _$ExposedPropertyFromJson(json);
}

@freezed
class UnderlyingProperty with _$UnderlyingProperty {
  const factory UnderlyingProperty({
    required String name,
    required String description,
    required String type, // TODO: enum?
    required String containerType,
    required String keyType,
    required Map<String, dynamic> metaData,
  }) = _UnderlyingProperty;

  factory UnderlyingProperty.fromJson(Map<String, dynamic> json) => _$UnderlyingPropertyFromJson(json);
}
