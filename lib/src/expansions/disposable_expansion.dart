import 'dart:async';

import '../core/base_presenter.dart';

typedef DisposableCallback = FutureOr<void> Function();

mixin DisposableExpansion on BasePresenter {
  final List<DisposableCallback> _disposables = [];

  void registerDisposable(DisposableCallback disposable) {
    _disposables.add(disposable);
  }

  @override
  void dispose() {
    for (var disposable in _disposables) {
      disposable();
    }
    super.dispose();
  }
}
