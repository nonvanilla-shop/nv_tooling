import 'package:collection/collection.dart';

abstract class _Selection<T> {
  final List<T> _options;
  final T? _selected;

  _Selection(this._options, this._selected)
      : assert((_selected != null) == _options.contains(_selected));

  @override
  bool operator ==(Object other) =>
      other is _Selection &&
      ListEquality().equals(_options, other._options) &&
      _selected == other._selected;

  @override
  int get hashCode => _options.hashCode + _selected.hashCode;

  /// Creates a copy with a different selection.
  _Selection copyWith(T selection);
}

class Selection<T> extends _Selection<T> {
  List<T> get options => _options;
  T get selected => _selected!;

  Selection({
    required List<T> options,
    required T selected,
  }) : super(options, selected);

  @override
  Selection<T> copyWith(T selection) => Selection(
        options: options,
        selected: selection,
      );
}

class OptionalSelection<T> extends _Selection<T> {
  List<T> get options => _options;
  T? get selected => _selected;

  OptionalSelection({
    required List<T> options,
    T? selected,
  }) : super(options, selected);

  @override
  OptionalSelection<T> copyWith(T? selection) => OptionalSelection(
        options: options,
        selected: selection,
      );

  bool get hasSelection => selected != null;
}
