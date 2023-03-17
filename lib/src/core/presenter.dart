import 'package:flutter/foundation.dart';
import 'package:hew/src/mutable_equatable/equatable_utils.dart';
import 'package:meta/meta.dart';
import 'package:hew/src/core/base_presenter.dart';

/// Base class for presenters, designed to be an ancestor of all presenters.
/// Should contain logic of your presentation layer.
abstract class Presenter<TModel> extends ChangeNotifier implements BasePresenter {
  /// Creates a presenter with the given [model].
  Presenter(TModel model) : _model = model;

  TModel _model;

  /// Current model of the presenter.
  TModel get model => _model;

  @protected
  set model(model) => _model = model;

  int? _previousMutableHashCode;

  @override
  @mustCallSuper
  void init() {}

  @override
  @internal
  void postInit() {
    _previousMutableHashCode = mapPropToHashCode(model);
  }

  @override
  @protected
  @internal
  void notifyListeners() {
    final currentMutableHashCode = mapPropToHashCode(model);
    if (_previousMutableHashCode == currentMutableHashCode) {
      return;
    }
    super.notifyListeners();
    _previousMutableHashCode = currentMutableHashCode;
  }

  @override
  @protected
  @visibleForTesting
  void notify([VoidCallback? fn]) {
    final Object? result = fn?.call() as dynamic;
    assert(() {
      if (result is Future) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('notify() callback argument returned a Future.'),
          ErrorDescription(
            'The notify() method on $this was called with a closure or method that '
            'returned a Future. Maybe it is marked as "async".',
          ),
          ErrorHint(
            'Instead of performing asynchronous work inside a call to notify(), first '
            'execute the work (without updating the widget model), and then synchronously '
            'update the model inside a call to seTModel().',
          ),
        ]);
      }
      return true;
    }());
    notifyListeners();
  }
}
