import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hew/hew.dart';

import '../stubs.dart';

void main() {
  testWidgets('BridgeHook builds child when no HewConfiguration provided', (tester) async {
    final presenter = CounterPresenter();
    const childKey = ValueKey('child');

    final bridgeHook = BridgeHook(presenter: presenter, child: const Placeholder(key: childKey));

    await tester.pumpWidget(bridgeHook);

    expect(find.byKey(childKey), findsOneWidget);
  });

  testWidgets('BridgeHook builds child when empty HewConfiguration provided', (tester) async {
    final presenter = CounterPresenter();
    const childKey = ValueKey('child');

    final bridgeHook = HewConfiguration(
      data: HewConfigurationData(bridges: BridgesConfigurationData()),
      child: BridgeHook(presenter: presenter, child: const Placeholder(key: childKey)),
    );

    await tester.pumpWidget(bridgeHook);

    expect(find.byKey(childKey), findsOneWidget);
  });

  testWidgets('BridgeHook builds child when HewConfiguration with non-matched bridges provided',
      (tester) async {
    final presenter = CounterPresenter();
    const childKey = ValueKey('child');

    final bridgeHook = HewConfiguration(
      data: HewConfigurationData(
        bridges: BridgesConfigurationData().add<MutableEquatableCounterPresenter>(
          (context, presenter, child) => Container(child: child),
        ),
      ),
      child: BridgeHook(presenter: presenter, child: const Placeholder(key: childKey)),
    );

    await tester.pumpWidget(bridgeHook);

    expect(find.byKey(childKey), findsOneWidget);
  });

  testWidgets('BridgeHook builds child and all matched bridges from HewConfiguration',
      (tester) async {
    final presenter = CounterPresenter();
    const childKey = ValueKey('child');
    const bridgeAKey = ValueKey('bridgeA');
    const bridgeBKey = ValueKey('bridgeB');
    const bridgeCKey = ValueKey('bridgeC');

    final bridgeHook = HewConfiguration(
      data: HewConfigurationData(
        bridges: BridgesConfigurationData()
            .add<CounterPresenter>(
              (context, presenter, child) => Container(
                key: bridgeAKey,
                child: child,
              ),
            )
            .add<CounterPresenter>(
              (context, presenter, child) => Container(
                key: bridgeBKey,
                child: child,
              ),
            )
            .add<MutableEquatableCounterPresenter>(
              (context, presenter, child) => Container(
                key: bridgeCKey,
                child: child,
              ),
            ),
      ),
      child: BridgeHook(presenter: presenter, child: const Placeholder(key: childKey)),
    );

    await tester.pumpWidget(bridgeHook);

    expect(find.byKey(childKey), findsOneWidget);
    expect(find.byKey(bridgeAKey), findsOneWidget);
    expect(find.byKey(bridgeBKey), findsOneWidget);
    expect(find.byKey(bridgeCKey), findsNothing);
  });
}
