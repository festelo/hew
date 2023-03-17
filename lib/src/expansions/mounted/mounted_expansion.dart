import 'package:flutter/widgets.dart';
import 'package:hew/src/core/base_presenter.dart';

// imports for documentation only
import 'package:hew/src/widgets/hew_configuration.dart';
import 'package:hew/src/widgets/presenter_builder.dart';
import 'package:hew/src/widgets/bridge_hook.dart';
import 'package:hew/src/widgets/presenter_widget.dart';
import 'package:hew/src/widgets/presenter_stateful_widget.dart';
import 'package:hew/src/core/presenter.dart';
// </>

part 'mounted_bridge.dart';

typedef _MountedResolver = bool Function();

/// Mixin that adds [mounted] field to [Presenter].
/// [mounted] field is `true` if this presenter is connected to the widget tree.
/// This expansion should be used with [MountedBridge] widget.
mixin MountedExpansion on BasePresenter {
  _MountedResolver? _mountedResolver;

  /// Returns `true` if this presenter is connected to the widget tree.
  @protected
  bool get mounted => _mountedResolver?.call() ?? false;

  void _setMountedResolver(_MountedResolver resolver) {
    _mountedResolver = resolver;
  }
}
