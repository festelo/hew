import 'dart:async';

import 'package:hew/rx.dart';
import 'package:hew/hew.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

class ReactivePresenter extends Presenter<void> with ReactiveExpansion {
  ReactivePresenter() : super(null);

  void subscribe(
    Stream<int> stream,
    void Function(int) onData, {
    String? subscriptionName,
    void Function(dynamic, StackTrace)? onError,
  }) {
    listen(
      stream,
      onData,
      onError: onError,
      subscriptionName: subscriptionName,
    );
  }
}

void main() {
  test('ReactiveExpansion can subscribe and unsubscribe on dispose', () async {
    final presenter = ReactivePresenter();
    final subject = PublishSubject<int>();
    const expectedValue = 10;
    int callbackValue = -1;
    int callbackExecutedCount = 0;

    presenter.subscribe(
      subject,
      (v) {
        callbackValue = v;
        callbackExecutedCount++;
      },
    );
    await Future<void>.delayed(Duration.zero);
    expect(callbackExecutedCount, 0);

    subject.add(expectedValue);
    await Future<void>.delayed(Duration.zero);
    expect(callbackValue, expectedValue);
    expect(callbackExecutedCount, 1);

    presenter.dispose();
    subject.add(expectedValue);
    await Future<void>.delayed(Duration.zero);
    expect(callbackValue, expectedValue);
    expect(callbackExecutedCount, 1);
  });

  test('ReactiveExpansion emits value synchronous when ValueStream is used',
      () async {
    const expectedValue = 10;
    final presenter = ReactivePresenter();
    final subject = BehaviorSubject<int>.seeded(expectedValue);
    int callbackValue = -1;
    int callbackExecutedCount = 0;

    presenter.subscribe(
      subject,
      (v) {
        callbackValue = v;
        callbackExecutedCount++;
      },
    );
    expect(callbackExecutedCount, 1);
    expect(callbackValue, expectedValue);

    subject.add(expectedValue);
    await Future<void>.delayed(Duration.zero);
    expect(callbackValue, expectedValue);
    expect(callbackExecutedCount, 2);

    presenter.dispose();
  });

  test(
      'ReactiveExpansion replaces subscription when same `subscriptionName` is used',
      () async {
    final presenter = ReactivePresenter();
    final subjectA = PublishSubject<int>();
    final subjectB = PublishSubject<int>();
    const expectedValue = 10;
    const subscriptionName = 'name';

    int callbackValue = -1;
    int callbackAExecutedCount = 0;
    int callbackBExecutedCount = 0;

    presenter.subscribe(subjectA, (v) {
      callbackValue = v;
      callbackAExecutedCount++;
    }, subscriptionName: subscriptionName);
    subjectA.add(expectedValue);
    await Future<void>.delayed(Duration.zero);
    expect(callbackAExecutedCount, 1);
    expect(callbackBExecutedCount, 0);
    expect(callbackValue, expectedValue);

    presenter.subscribe(subjectB, (v) {
      callbackValue = v;
      callbackBExecutedCount++;
    }, subscriptionName: subscriptionName);

    subjectB.add(expectedValue);
    await Future<void>.delayed(Duration.zero);
    expect(callbackAExecutedCount, 1);
    expect(callbackBExecutedCount, 1);
    expect(callbackValue, expectedValue);

    presenter.dispose();
  });
}
