import 'package:flutter/widgets.dart';
import 'package:hew/src/core/base_presenter.dart';

part 'mounted_bridge.dart';

typedef _MountedResolver = bool Function();

mixin MountedExpansion on BasePresenter {
  _MountedResolver? _mountedResolver;
  bool get mounted => _mountedResolver?.call() ?? false;

  void _setMountedResolver(_MountedResolver resolver) {
    _mountedResolver = resolver;
  }
}
