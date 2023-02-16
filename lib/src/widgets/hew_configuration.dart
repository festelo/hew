import 'package:flutter/widgets.dart';
import 'package:hew/src/core/base_presenter.dart';
import 'package:hew/src/expansions/mounted/mounted_expansion.dart';

typedef BridgeHookBuilder<TPresenter extends BasePresenter> = Widget Function(
  BuildContext context,
  TPresenter presenter,
  Widget child,
);

class HewConfiguration extends InheritedWidget {
  const HewConfiguration({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  static HewConfigurationData of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<HewConfiguration>()
            ?.data ??
        HewConfigurationData.defaultConfiguration;
  }

  final HewConfigurationData data;

  @override
  bool updateShouldNotify(HewConfiguration oldWidget) => oldWidget.data != data;
}

class HewConfigurationData {
  HewConfigurationData({
    required this.bridges,
  });

  static final defaultConfiguration = HewConfigurationData(
    bridges: BridgesConfigurationData().add<MountedExpansion>(
      (_, presenter, child) => MountedBridge(
        presenter: presenter,
        child: child,
      ),
    ),
  );

  final BridgesConfigurationData bridges;
}

class BridgesConfigurationData {
  BridgesConfigurationData();

  final List<_BridgeInfo> _bridges = [];

  BridgesConfigurationData add<T extends BasePresenter>(
      BridgeHookBuilder<T> bridge) {
    _bridges.add(_BridgeInfo<T>(bridge));
    return this;
  }

  List<BridgeHookBuilder> getFor(BasePresenter presenter) {
    return _bridges
        .where((bridge) => bridge.usableFor(presenter))
        .map((bridge) => bridge.castedBuilder)
        .toList();
  }
}

class _BridgeInfo<T extends BasePresenter> {
  _BridgeInfo(this.builder);

  final BridgeHookBuilder<T> builder;

  BridgeHookBuilder<BasePresenter> get castedBuilder =>
      (context, presenter, child) => builder(context, presenter as T, child);

  bool usableFor(BasePresenter presenter) {
    return presenter is T;
  }
}
