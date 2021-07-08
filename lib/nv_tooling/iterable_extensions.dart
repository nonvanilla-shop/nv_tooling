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
}
