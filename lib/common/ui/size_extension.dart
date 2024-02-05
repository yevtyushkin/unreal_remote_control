import 'package:flutter/material.dart';

/// An extension on [BuildContext] that provides a [screenSize] method on the
/// [BuildContext].
extension SizeExtension on BuildContext {
  /// Returns the [Size] that corresponds to this [BuildContext].
  Size get screenSize => MediaQuery.sizeOf(this);
}
