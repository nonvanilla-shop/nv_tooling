/// Empty class that exists to make importing iterable extension easier.
class NvIterableExtensions {}

/// Selection of Iterable Extensions frequently used at NonVanilla.
extension IterableExtensions<T> on Iterable<T> {
  /// Inserts a Type T in between every two elements in an iterable.
  Iterable<T> separatedBy(T separator) sync* {
    final iter = iterator;
    if (!iter.moveNext()) {
      return;
    }

    yield iter.current;
    while (iter.moveNext()) {
      yield separator;
      yield iter.current;
    }
  }

  /// Behaves like the map function but also exposes the index of the current element.
  Iterable<R> mapIndexed<R>(R Function(int index, T element) f) sync* {
    final iter = iterator;
    int index = 0;
    while (iter.moveNext()) {
      yield f(index++, iter.current);
    }
  }

  /// Behaves like the map function but iterates over n elements at a time.
  Iterable<R> mapN<R>(R Function(List<T> element) f, {required int n}) sync* {
    Iterable<T> ptr = this;
    while (ptr.isNotEmpty) {
      yield f(ptr.take(n).toList());
      ptr = ptr.skip(n);
    }
  }

  /// Group elements with the groupBy Function and map those groups with the groupBuilder.
  Iterable<G> mapGrouped<K, G>({
    required K? Function(T item) groupBy,
    required G Function(K? key, List<T> items) groupBuilder,
  }) {
    final grouped = <K?, List<T>>{};
    forEach((item) {
      final key = groupBy(item);
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(item);
    });
    return grouped.entries.map((entry) => groupBuilder(entry.key, entry.value));
  }
}
