import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/project/domain/exposed_property.dart';

part 'project_page_selected_property.freezed.dart';

/// Represents a currently selected property on the project page.
@freezed
class ProjectPageSelectedProperty with _$ProjectPageSelectedProperty {
  /// Creates a new instance of the [ProjectPageSelectedProperty] with the given [property].
  const factory ProjectPageSelectedProperty({
    required ExposedProperty property,
  }) = _ProjectPageSelectedProperty;
}
