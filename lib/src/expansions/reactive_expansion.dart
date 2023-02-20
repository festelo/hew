import 'dart:async';

import 'package:hew/src/core/base_presenter.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

mixin ReactiveExpansion on BasePresenter {
  final List<StreamSubscription> _subscriptions = [];
  final Map<String, StreamSubscription> _namedSubscriptions = {};

  @protected
  StreamSubscription listen<T>(
    Stream<T> stream,
    void Function(T) onData, {
    String? subscriptionName,
    void Function(dynamic, StackTrace)? onError,
  }) {
    StreamSubscription sub;
    if (stream is ValueStream<T> && stream.hasValue) {
      onData(stream.value);
      sub = stream.skip(1).listen(
            onData,
            onError: onError,
          );
    } else {
      sub = stream.listen(
        onData,
        onError: onError,
      );
    }
    _subscriptions.add(sub);
    if (subscriptionName != null) {
      _namedSubscriptions[subscriptionName]?.cancel();
      _namedSubscriptions[subscriptionName] = sub;
    }
    return sub;
  }

  @override
  void dispose() {
    for (final l in _subscriptions) {
      l.cancel();
    }
    super.dispose();
  }
}
