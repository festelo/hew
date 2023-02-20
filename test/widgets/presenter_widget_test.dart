import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hew/hew.dart';

import '../stubs.dart';

class TestStore<TPresenter extends Presenter> {
  int buildCount = 0;
  TPresenter? presenter;
  dynamic model;
}

class SimplePresenterWidgetWithoutRebuildOnChanges extends PresenterWidget<CounterPresenter, int> {
  SimplePresenterWidgetWithoutRebuildOnChanges({
    required this.testStore,
  });

  final TestStore<CounterPresenter> testStore;

  @override
  CounterPresenter createPresenter() => CounterPresenter();

  @override
  Widget build(BuildContext context, CounterPresenter presenter, int model) {
    testStore.buildCount++;
    testStore.presenter = presenter;
    testStore.model = model;
    return Placeholder();
  }
}

class SimplePresenterWidget extends PresenterWidget<CounterPresenter, int> {
  SimplePresenterWidget({
    required this.testStore,
    this.rebuildOnChanges = true,
  });

  final TestStore<CounterPresenter> testStore;

  @override
  final bool rebuildOnChanges;

  @override
  CounterPresenter createPresenter() => CounterPresenter();

  @override
  Widget build(BuildContext context, CounterPresenter presenter, int model) {
    testStore.buildCount++;
    testStore.presenter = presenter;
    testStore.model = model;
    return Placeholder();
  }
}

void main() {
  testWidgets('PresenterWidget builds content', (tester) async {
    final testStore = TestStore<CounterPresenter>();
    final presenterWidget = SimplePresenterWidget(testStore: testStore);

    await tester.pumpWidget(presenterWidget);

    expect(testStore.buildCount, 1);
  });

  testWidgets('PresenterWidget rebuilds child whenever Model changes', (tester) async {
    final testStore = TestStore<CounterPresenter>();
    final presenterWidget = SimplePresenterWidget(testStore: testStore);

    await tester.pumpWidget(presenterWidget);

    await tester.pumpWidget(presenterWidget);
    expect(testStore.buildCount, 1);
    expect(testStore.presenter, isNotNull);

    testStore.presenter!.increment();
    await tester.pumpWidget(presenterWidget);
    expect(testStore.buildCount, 2);

    testStore.presenter!.increment();
    await tester.pumpWidget(presenterWidget);
    expect(testStore.buildCount, 3);

    await tester.pumpWidget(presenterWidget);
    expect(testStore.buildCount, 3);
  });

  testWidgets('PresenterWidget rebuildOnChanges is true by default', (tester) async {
    final testStore = TestStore<CounterPresenter>();
    final presenterWidget = SimplePresenterWidgetWithoutRebuildOnChanges(testStore: testStore);
    expect(presenterWidget.rebuildOnChanges, true);
  });

  testWidgets('PresenterWidget don\'t rebuild child when Model changes if rebuildOnChanges = false',
      (tester) async {
    final testStore = TestStore<CounterPresenter>();
    final presenterWidget = SimplePresenterWidget(
      testStore: testStore,
      rebuildOnChanges: false,
    );

    await tester.pumpWidget(presenterWidget);
    expect(testStore.presenter, isNotNull);
    expect(testStore.buildCount, 1);

    testStore.presenter!.increment();
    await tester.pumpWidget(presenterWidget);
    expect(testStore.buildCount, 1);
  });

  testWidgets('PresenterWidget maintains presenter\'s lifecycle', (tester) async {
    final testStore = TestStore<CounterPresenter>();
    final presenterWidget = SimplePresenterWidget(testStore: testStore);

    final testWidget = RootRestorationScope(
      restorationId: 'root',
      child: presenterWidget,
    );

    await tester.pumpWidget(testWidget);
    expect(testStore.presenter, isNotNull);
    expect(testStore.presenter!.initialized, 1);

    expect(testStore.presenter!.disposed, 0);
    await tester.pumpWidget(const Placeholder());
    expect(testStore.presenter!.disposed, 1);
  });

  testWidgets('PresenterWidget\'s model points to presenter\'s model', (tester) async {
    final testStore = TestStore<CounterPresenter>();
    final presenterWidget = SimplePresenterWidget(testStore: testStore);

    final testWidget = RootRestorationScope(
      restorationId: 'root',
      child: presenterWidget,
    );

    await tester.pumpWidget(testWidget);
    expect(testStore.model, testStore.presenter?.model);
  });
}
