import 'package:hive_flutter/hive_flutter.dart';

/// A mixin
mixin HiveRepository<T> {
  /// A [Box] that stores values of the given type [T].
  Future<Box<T>> get box;

  /// Fetches all values the given [T] from the [box].
  Future<List<T>> fetchAll() async {
    final box_ = await box;

    return box_.values.toList();
  }

  /// Persists the given [value] with the given [id].
  Future<void> persist(String id, T value) async {
    final box_ = await box;

    await box_.put(id, value);
  }

  /// Deletes the value with the given [id].
  Future<void> delete(String id) async {
    final box_ = await box;

    await box_.delete(id);
  }
}
