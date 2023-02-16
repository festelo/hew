import 'package:flutter/widgets.dart';
import 'package:hew/hew.dart';
import 'package:hew/src/elements/presenter_stateful_element.dart';

abstract class PresenterStatefulWidget<TPresenter extends Presenter> extends StatefulWidget {
  const PresenterStatefulWidget({Key? key}) : super(key: key);

  TPresenter createPresenter();

  bool get rebuildOnChanges => true;

  @override
  PresenterStatefulElement createElement() {
    return PresenterStatefulElement(this);
  }

  @override
  PresenterState createState();
}

abstract class PresenterState< //
    TPresenter extends Presenter<TModel>,
    TModel extends PresentationModel, //
    TWidget extends PresenterStatefulWidget<TPresenter> //
    > extends State<TWidget> {
  late final TPresenter presenter = widget.createPresenter();
  TModel get model => presenter.model;
}
