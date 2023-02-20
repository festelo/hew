import 'package:flutter/widgets.dart';
import 'package:hew/hew.dart';
import 'package:test/test.dart';

class TextEditingPresenter extends Presenter<void> with TextEditingExpansion {
  TextEditingPresenter() : super(null);

  TextEditingController? controller;

  void createController() {
    controller = useTextEditingController();
  }
}

void main() {
  test('TextEditingExpansion can create and dispose controller', () {
    final presenter = TextEditingPresenter();
    expect(presenter.controller, isNull);
    presenter.createController();
    expect(presenter.controller, isNotNull);
    presenter.controller!.addListener(() {});
    // ignore: invalid_use_of_protected_member
    expect(presenter.controller!.hasListeners, true);
    presenter.dispose();
    // ignore: invalid_use_of_protected_member
    expect(presenter.controller!.hasListeners, false);
  });
}
