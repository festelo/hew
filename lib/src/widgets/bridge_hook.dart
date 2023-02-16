import 'package:flutter/widgets.dart';

import 'package:hew/src/core/presenter.dart';
import 'package:hew/src/widgets/hew_configuration.dart';

class BridgeHook<T extends Presenter> extends StatelessWidget {
  const BridgeHook({
    Key? key,
    required this.presenter,
    required this.child,
  }) : super(key: key);

  final T presenter;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final configuration = HewConfiguration.of(context);
    var child = this.child;
    final bridges = configuration.bridges.getFor(presenter);
    for (final bridge in bridges) {
      child = bridge(context, presenter, child);
    }
    return child;
  }
}
