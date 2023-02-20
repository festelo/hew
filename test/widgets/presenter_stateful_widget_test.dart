import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hew/hew.dart';

import '../stubs.dart';

class SimplePresenterStatefulWidgetWithoutRebuildOnChanges
    extends PresenterStatefulWidget<CounterPresenter> {
  SimplePresenterStatefulWidgetWithoutRebuildOnChanges();

  @override
  CounterPresenter createPresenter() => CounterPresenter();
  @override
  PresenterState createState() => SimplePresenterState();
}

class SimplePresenterStatefulWidget extends PresenterStatefulWidget<CounterPresenter> {
  SimplePresenterStatefulWidget({this.rebuildOnChanges = true});

  @override
  final bool rebuildOnChanges;

  @override
  CounterPresenter createPresenter() => CounterPresenter();
  @override
  PresenterState createState() => SimplePresenterState();
}

class SimplePresenterState
    extends PresenterState<CounterPresenter, int, SimplePresenterStatefulWidget> {
  int buildCount = 0;

  @override
  Widget build(BuildContext context) {
    buildCount++;
    return Placeholder();
  }
}

void main() {
  testWidgets('PresenterStatefulWidget builds content', (tester) async {
    final presenterWidget = SimplePresenterStatefulWidget();

    await tester.pumpWidget(presenterWidget);

    final state = tester.state<SimplePresenterState>(find.byType(SimplePresenterStatefulWidget));
    expect(state.buildCount, 1);
  });

  testWidgets('PresenterStatefulWidget rebuilds child whenever Model changes', (tester) async {
    final presenterWidget = SimplePresenterStatefulWidget();

    await tester.pumpWidget(presenterWidget);
    final state = tester.state<SimplePresenterState>(find.byType(SimplePresenterStatefulWidget));

    await tester.pumpWidget(presenterWidget);
    expect(state.buildCount, 1);

    state.presenter.increment();
    await tester.pumpWidget(presenterWidget);
    expect(state.buildCount, 2);

    state.presenter.increment();
    await tester.pumpWidget(presenterWidget);
    expect(state.buildCount, 3);

    await tester.pumpWidget(presenterWidget);
    expect(state.buildCount, 3);
  });

  testWidgets('PresenterStatefulWidget rebuildOnChanges is true by default', (tester) async {
    final presenterWidget = SimplePresenterStatefulWidgetWithoutRebuildOnChanges();
    expect(presenterWidget.rebuildOnChanges, true);
  });

  testWidgets(
      'PresenterStatefulWidget don\'t rebuild child when Model changes if rebuildOnChanges = false',
      (tester) async {
    final presenterWidget = SimplePresenterStatefulWidget(rebuildOnChanges: false);

    await tester.pumpWidget(presenterWidget);
    final state = tester.state<SimplePresenterState>(find.byType(SimplePresenterStatefulWidget));
    expect(state.buildCount, 1);

    state.presenter.increment();
    await tester.pumpWidget(presenterWidget);
    expect(state.buildCount, 1);
  });

  testWidgets('PresenterStatefulWidget maintains presenter\'s lifecycle', (tester) async {
    final presenterWidget = SimplePresenterStatefulWidget();

    final testWidget = RootRestorationScope(
      restorationId: 'root',
      child: presenterWidget,
    );

    await tester.pumpWidget(testWidget);
    final state = tester.state<SimplePresenterState>(find.byType(SimplePresenterStatefulWidget));
    expect(state.presenter.initialized, 1);

    expect(state.presenter.disposed, 0);
    await tester.pumpWidget(const Placeholder());
    expect(state.presenter.disposed, 1);
  });

  testWidgets('PresenterStatefulWidget\'s model points to presenter\'s model', (tester) async {
    final presenterWidget = SimplePresenterStatefulWidget();

    final testWidget = RootRestorationScope(
      restorationId: 'root',
      child: presenterWidget,
    );

    await tester.pumpWidget(testWidget);
    final state = tester.state<SimplePresenterState>(find.byType(SimplePresenterStatefulWidget));
    expect(state.model, state.presenter.model);
  });
}
