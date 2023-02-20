import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hew/hew.dart';

import '../stubs.dart';

void main() {
  testWidgets('ModelObserver builds child', (tester) async {
    const childKey = ValueKey('child');
    final presenter = CounterPresenter();

    final modelObserver = ModelObserver<int>(
      presenter: presenter,
      builder: (context) => const Placeholder(key: childKey),
    );

    await tester.pumpWidget(modelObserver);
    expect(find.byKey(childKey), findsOneWidget);
  });

  testWidgets('ModelObserver rebuilds child whenever Model changes', (tester) async {
    final presenter = CounterPresenter();
    var buildCalled = 0;

    final modelObserver = ModelObserver(
      presenter: presenter,
      builder: (context) {
        buildCalled++;
        return const Placeholder();
      },
    );

    await tester.pumpWidget(modelObserver);
    expect(buildCalled, 1);

    presenter.increment();
    await tester.pumpWidget(modelObserver);
    expect(buildCalled, 2);

    presenter.increment();
    await tester.pumpWidget(modelObserver);
    expect(buildCalled, 3);

    await tester.pumpWidget(modelObserver);
    expect(buildCalled, 3);
  });

  testWidgets('ModelObserver rebuilds child whenever MutableEquatableModel changes',
      (tester) async {
    final presenter = MutableEquatableCounterPresenter();
    var buildCalled = 0;

    final modelObserver = ModelObserver(
      presenter: presenter,
      builder: (context) {
        buildCalled++;
        return const Placeholder();
      },
    );

    await tester.pumpWidget(modelObserver);
    expect(buildCalled, 1);

    presenter.increment();
    await tester.pumpWidget(modelObserver);
    expect(buildCalled, 2);

    presenter.increment();
    await tester.pumpWidget(modelObserver);
    expect(buildCalled, 3);

    await tester.pumpWidget(modelObserver);
    expect(buildCalled, 3);
  });

  testWidgets('ModelObserver rebuilds child only when field passed to `when` changes',
      (tester) async {
    final presenter = MutableEquatableCounterPresenter();
    var buildCalled = 0;

    final modelObserver = ModelObserver<MutableEquatableCounterModel>(
      presenter: presenter,
      when: (model) => model.internal?.count,
      builder: (context) {
        buildCalled++;
        return const Placeholder();
      },
    );

    await tester.pumpWidget(modelObserver);
    expect(buildCalled, 1);

    presenter.increment();
    await tester.pumpWidget(modelObserver);
    expect(buildCalled, 1);

    presenter.incrementInternal();
    await tester.pumpWidget(modelObserver);
    expect(buildCalled, 2);
  });

  testWidgets('ModelObserver resubscribes to new Presenter when it changes', (tester) async {
    final presenterA = CounterPresenter();
    final presenterB = CounterPresenter();

    await tester.pumpWidget(ModelObserver<int>(
      presenter: presenterA,
      builder: (context) => const Placeholder(),
    ));
    // ignore: invalid_use_of_protected_member
    expect(presenterA.hasListeners, true);
    // ignore: invalid_use_of_protected_member
    expect(presenterB.hasListeners, false);

    await tester.pumpWidget(ModelObserver<int>(
      presenter: presenterB,
      builder: (context) => const Placeholder(),
    ));
    // ignore: invalid_use_of_protected_member
    expect(presenterA.hasListeners, false);
    // ignore: invalid_use_of_protected_member
    expect(presenterB.hasListeners, true);
  });

  testWidgets(
      'ModelObserver resubscribes to new Presenter when it changes and doesn\'t rebuild'
      'child when it changes properties not specified in `when`', (tester) async {
    int buildCalled = 0;

    final presenterA = MutableEquatableCounterPresenter();
    final presenterB = MutableEquatableCounterPresenter();

    final widgetA = ModelObserver<MutableEquatableCounterModel>(
      when: (m) => m.internal?.count,
      presenter: presenterA,
      builder: (context) {
        buildCalled++;
        return const Placeholder();
      },
    );

    final widgetB = ModelObserver<MutableEquatableCounterModel>(
      when: (m) => m.internal?.count,
      presenter: presenterB,
      builder: (context) {
        buildCalled++;
        return const Placeholder();
      },
    );

    presenterA.model.internal = MutableEquatableCounterModel()..count = 10;
    await tester.pumpWidget(widgetA);
    expect(buildCalled, 1);

    await tester.pumpWidget(widgetB);
    expect(buildCalled, 2);

    presenterB.incrementInternal();
    await tester.pumpWidget(widgetB);
    expect(buildCalled, 3);

    presenterB.increment();
    await tester.pumpWidget(widgetB);
    expect(buildCalled, 3);
  });
}
