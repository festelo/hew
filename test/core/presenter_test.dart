import 'package:test/test.dart';

import '../stubs.dart';

void main() {
  test('Presenter initilizes correctly and don\'t notifies listener on initialization', () {
    int listenerCalled = 0;
    final presenter = CounterPresenter();

    presenter.addListener(() {
      listenerCalled++;
    });

    presenter.init();
    presenter.postInit();

    expect(presenter.model, 0);
    expect(listenerCalled, 0);
  });

  test('Presenter don\'t notifies listeners when there\'s no changes in state', () {
    int listenerCalled = 0;
    final presenter = CounterPresenter();
    presenter.addListener(() {
      listenerCalled++;
    });

    presenter.init();
    presenter.postInit();

    expect(listenerCalled, 0);

    presenter.notify();

    expect(listenerCalled, 0);
  });

  test('Presenter notifies listeners when there\'re changes in state', () {
    int listenerCalled = 0;
    final presenter = CounterPresenter();
    presenter.addListener(() {
      listenerCalled++;
    });

    presenter.init();
    presenter.postInit();

    expect(listenerCalled, 0);
    expect(presenter.model, 0);

    presenter.increment();

    expect(listenerCalled, 1);
    expect(presenter.model, 1);
  });

  test('Presenter notifies all subscribed listeners and don\'t notifies unsubscribed', () {
    int listenerACalled = 0;
    int listenerBCalled = 0;
    int listenerCCalled = 0;
    final presenter = CounterPresenter();

    listenerA() => listenerACalled++;
    listenerB() => listenerBCalled++;
    listenerC() => listenerCCalled++;

    presenter.addListener(listenerA);
    presenter.addListener(listenerB);
    presenter.addListener(listenerC);

    presenter.init();
    presenter.postInit();

    presenter.increment();

    expect(listenerACalled, 1);
    expect(listenerBCalled, 1);
    expect(listenerCCalled, 1);

    presenter.removeListener(listenerC);
    presenter.increment();

    expect(listenerACalled, 2);
    expect(listenerBCalled, 2);
    expect(listenerCCalled, 1);
  });

  test('Presenter executes passed to `notify()` function', () {
    int listenerCalled = 0;
    int passedFunctionCalled = 0;
    final presenter = CounterPresenter();

    presenter.addListener(() => listenerCalled++);

    presenter.init();
    presenter.postInit();

    presenter.notify(() => passedFunctionCalled++);

    expect(listenerCalled, 0);
    expect(passedFunctionCalled, 1);
  });

  test('Presenter doesn\'t allow to pass `Future` as callback to notify', () {
    final presenter = CounterPresenter();
    expect(() => presenter.notify(() async {}), throwsA(anything));
  });
}
