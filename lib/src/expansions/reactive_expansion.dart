import 'dart:async';

import 'package:hew/src/core/base_presenter.dart';
import 'package:rxdart/rxdart.dart';

mixin ReactiveExpansion on BasePresenter {
  final List<StreamSubscription> _listenables = [];
  final Map<String, StreamSubscription> _namedListenables = {};

  StreamSubscription listen<T>(
    Stream<T> stream,
    void Function(T) onData, {
    String? name,
    void Function(dynamic, StackTrace)? onError,
    bool autoNotify = true,
  }) {
    StreamSubscription sub;
    final callback = autoNotify
        ? (T data) {
            onData(data);
            notify();
          }
        : onData;
    if (stream is ValueStream<T> && stream.hasValue) {
      onData(stream.value);
      sub = stream.skip(1).listen(
            callback,
            onError: onError,
          );
    } else {
      sub = stream.listen(
        callback,
        onError: onError,
      );
    }
    _listenables.add(sub);
    if (name != null) {
      _namedListenables[name]?.cancel();
      _namedListenables[name] = sub;
    }
    return sub;
  }

  @override
  void dispose() {
    for (final l in _listenables) {
      l.cancel();
    }
    super.dispose();
  }
}
