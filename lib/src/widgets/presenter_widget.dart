import 'package:flutter/widgets.dart';
import 'package:hew/hew.dart';
import 'package:hew/src/elements/presenter_element.dart';

abstract class PresenterWidget<TPresenter extends Presenter<TModel>, TModel> extends Widget {
  const PresenterWidget({Key? key}) : super(key: key);

  TPresenter createPresenter();

  bool get rebuildOnChanges => true;

  Widget build(BuildContext context, TPresenter presenter, TModel model);

  @override
  PresenterElement createElement() {
    return PresenterElement(this);
  }
}
