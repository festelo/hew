import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hew/hew.dart';

import '../stubs.dart';

void main() {
  testWidgets('PresenterBuilder builds child and presenter', (tester) async {
    const childKey = ValueKey('child');
    final presenter = CounterPresenter();
    int presenterResolved = 0;

    final presenterBuilder = PresenterBuilder<CounterPresenter, int>(
      resolver: () {
        presenterResolved++;
        return presenter;
      },
      builder: (context, presenter, state) => const Placeholder(key: childKey),
    );

    await tester.pumpWidget(presenterBuilder);
    expect(find.byKey(childKey), findsOneWidget);
    expect(presenterResolved, 1);
  });

  testWidgets('PresenterBuilder rebuilds child whenever Model changes', (tester) async {
    final presenter = CounterPresenter();
    var buildCalled = 0;

    final presenterBuilder = PresenterBuilder<CounterPresenter, int>(
      resolver: () => presenter,
      builder: (context, presenter, state) {
        buildCalled++;
        return const Placeholder();
      },
    );

    await tester.pumpWidget(presenterBuilder);
    expect(buildCalled, 1);

    presenter.increment();
    await tester.pumpWidget(presenterBuilder);
    expect(buildCalled, 2);

    presenter.increment();
    await tester.pumpWidget(presenterBuilder);
    expect(buildCalled, 3);

    await tester.pumpWidget(presenterBuilder);
    expect(buildCalled, 3);
  });

  testWidgets(
      'PresenterBuilder don\'t rebuild child when Model changes if rebuildOnChanges = false',
      (tester) async {
    final presenter = CounterPresenter();
    var buildCalled = 0;

    final presenterBuilder = PresenterBuilder<CounterPresenter, int>(
      rebuildOnChanges: false,
      resolver: () => presenter,
      builder: (context, presenter, state) {
        buildCalled++;
        return const Placeholder();
      },
    );

    await tester.pumpWidget(presenterBuilder);
    expect(buildCalled, 1);

    presenter.increment();
    await tester.pumpWidget(presenterBuilder);
    expect(buildCalled, 1);
  });

  testWidgets('PresenterBuilder maintains presenter\'s lifecycle', (tester) async {
    final presenter = CounterPresenter();

    final presenterBuilder = PresenterBuilder<CounterPresenter, int>(
      resolver: () => presenter,
      builder: (context, presenter, state) => const Placeholder(),
    );

    final testWidget = RootRestorationScope(
      restorationId: 'root',
      child: presenterBuilder,
    );

    expect(presenter.initialized, 0);
    await tester.pumpWidget(testWidget);
    expect(presenter.initialized, 1);

    expect(presenter.disposed, 0);
    await tester.pumpWidget(const Placeholder());
    expect(presenter.disposed, 1);
  });

  testWidgets('PresenterBuilder don\'t maintain presenter\'s lifecycle when bindLifecycle: false',
      (tester) async {
    final presenter = CounterPresenter();

    final presenterBuilder = PresenterBuilder<CounterPresenter, int>(
      bindLifecycle: false,
      resolver: () => presenter,
      builder: (context, presenter, state) => const Placeholder(),
    );

    final testWidget = RootRestorationScope(
      restorationId: 'root',
      child: presenterBuilder,
    );

    expect(presenter.initialized, 0);
    await tester.pumpWidget(testWidget);
    expect(presenter.initialized, 0);

    expect(presenter.disposed, 0);
    await tester.pumpWidget(const Placeholder());
    expect(presenter.disposed, 0);
  });
}
