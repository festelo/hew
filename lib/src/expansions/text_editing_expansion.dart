import 'package:hew/src/core/base_presenter.dart';

import 'package:flutter/widgets.dart';

mixin TextEditingExpansion on BasePresenter {
  final List<TextEditingController> _controllers = [];

  @protected
  TextEditingController useTextEditingController() {
    final controller = TextEditingController();
    _controllers.add(controller);
    return controller;
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }
}
