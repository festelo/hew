import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hew/hew.dart';

import '../stubs.dart';

void main() {
  testWidgets('HewConfiguration builds child', (tester) async {
    const childKey = ValueKey('child');

    final bridgeHook = HewConfiguration(
      data: HewConfigurationData(bridges: BridgesConfigurationData()),
      child: const Placeholder(key: childKey),
    );

    await tester.pumpWidget(bridgeHook);
    expect(find.byKey(childKey), findsOneWidget);
  });

  testWidgets('HewConfiguration builds and resolves its state via `of` function', (tester) async {
    BuildContext? childContext;

    final data = HewConfigurationData(
      bridges: BridgesConfigurationData().add<MutableEquatableCounterPresenter>(
        (context, presenter, child) => Container(child: child),
      ),
    );

    final hewConfiguration = HewConfiguration(
      data: data,
      child: Builder(builder: (context) {
        childContext = context;
        return const Placeholder();
      }),
    );

    await tester.pumpWidget(hewConfiguration);

    expect(childContext, isNotNull);
    expect(HewConfiguration.of(childContext!), data);
  });

  testWidgets('HewConfiguration.of() returns default state when no HewConfiguration is in the tree',
      (tester) async {
    BuildContext? childContext;

    final anyWidget = Builder(builder: (context) {
      childContext = context;
      return const Placeholder();
    });

    await tester.pumpWidget(anyWidget);

    expect(childContext, isNotNull);
    expect(HewConfiguration.of(childContext!), HewConfigurationData.defaultConfiguration);
  });

  testWidgets('HewConfiguration.updateShouldNotify() returns true when we pass different data',
      (tester) async {
    final hewConfiguration = HewConfiguration(
      data: HewConfigurationData.defaultConfiguration,
      child: const Placeholder(),
    );
    final shouldNotify = hewConfiguration.updateShouldNotify(
      HewConfiguration(
        data: HewConfigurationData(bridges: BridgesConfigurationData()),
        child: const Placeholder(),
      ),
    );
    expect(shouldNotify, true);
  });
}
