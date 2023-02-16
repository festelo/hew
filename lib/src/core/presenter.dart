import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:hew/src/core/base_presenter.dart';
import 'package:hew/src/core/presentation_model.dart';

typedef Listener = void Function();

abstract class Presenter<TModel extends PresentationModel> extends ChangeNotifier
    implements BasePresenter {
  Presenter(this.model);

  final TModel model;

  int? _previousMutableHashCode;

  @override
  @mustCallSuper
  void init() {}

  @override
  @internal
  void postInit() {
    _previousMutableHashCode = model.mutableHashCode;
  }

  @override
  @protected
  @internal
  void notifyListeners() {
    final currentMutableHashCode = model.mutableHashCode;
    if (_previousMutableHashCode == currentMutableHashCode) {
      return;
    }
    super.notifyListeners();
    _previousMutableHashCode = currentMutableHashCode;
  }

  @override
  @protected
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
