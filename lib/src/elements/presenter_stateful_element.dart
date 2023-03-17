import 'package:flutter/widgets.dart';
import 'package:hew/src/widgets/presenter_builder.dart';
import 'package:hew/src/widgets/presenter_stateful_widget.dart';
import 'package:meta/meta.dart';

/// PresenterStatefulElement is an element that is used to build [PresenterStatefulWidget]s.
@internal
class PresenterStatefulElement extends StatefulElement {
  /// Creates a new [PresenterStatefulElement].
  PresenterStatefulElement(this._widget) : super(_widget);

  final PresenterStatefulWidget _widget;

  @override
  PresenterState get state => super.state as PresenterState;

  @override
  Widget build() {
    return PresenterBuilder(
      rebuildOnChanges: _widget.rebuildOnChanges,
      resolver: () => state.presenter,
      builder: (_, __, ___) => super.build(),
    );
  }
}
