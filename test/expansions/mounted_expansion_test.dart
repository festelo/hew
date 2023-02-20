import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hew/hew.dart';
import 'package:mockito/mockito.dart';

class MountedPresenter extends Presenter<void> with MountedExpansion {
  MountedPresenter() : super(null);

  bool get publicMounted => mounted;
}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  testWidgets('MountedPresenter retrieves mounted status from MountedPresenter', (tester) async {
    final presenter = MountedPresenter();

    expect(presenter.publicMounted, isFalse);

    final bridgeWidget = MountedBridge(
      presenter: presenter,
      child: const Placeholder(),
    );

    await tester.pumpWidget(bridgeWidget);
    expect(presenter.publicMounted, isTrue);

    await tester.pumpWidget(const Placeholder());
    expect(presenter.publicMounted, isFalse);

    await tester.pumpWidget(bridgeWidget);
    expect(presenter.publicMounted, isTrue);
  });

  testWidgets('MountedBridge is part of default Hew configuration', (tester) async {
    final presenter = MountedPresenter();
    final bridges = HewConfigurationData.defaultConfiguration.bridges.getFor(presenter);

    Widget child = const Placeholder();
    bool mountedBridgeFound = false;
    for (final bridgeBuilder in bridges) {
      child = bridgeBuilder(MockBuildContext(), presenter, child);
      if (child is MountedBridge) {
        mountedBridgeFound = true;
      }
    }
    expect(mountedBridgeFound, true);
  });
}
