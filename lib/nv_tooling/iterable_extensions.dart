/// Empty class that exists to make importing iterable extension easier.
class NvIterableExtensions {}

/// Selection of Iterable Extensions frequently used at NonVanilla.
extension IterableExtensions<T> on Iterable<T> {
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

  Iterable<R> mapIndexed<R>(R Function(int index, T element) f) sync* {
    final iter = iterator;
    int index = 0;
    while (iter.moveNext()) {
      yield f(index++, iter.current);
    }
  }

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
