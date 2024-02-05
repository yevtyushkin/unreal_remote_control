/// An extension on [Iterable] that provides the [updateWhere]
/// and [setWhere] method.
extension WhereExtension<T> on Iterable<T> {
  /// Returns an updated [Iterable] with the elements updated with the given
  /// [update] that satisfy the given [test].
  Iterable<T> updateWhere(
    bool Function(T element) test,
    T Function(T element) update,
  ) {
    return map(
      (element) {
        if (test(element)) {
          return update(element);
        }

        return element;
      },
    );
  }

  /// Returns an updated [Iterable] with the elements set to the given
  /// [newValue] that satisfy the given [test].
  Iterable<T> setWhere(
    bool Function(T element) test,
    T newValue,
  ) {
    return map(
      (element) {
        if (test(element)) {
          return newValue;
        }

        return element;
      },
    );
  }
}
