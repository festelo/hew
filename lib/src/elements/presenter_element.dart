import 'package:flutter/widgets.dart';
import 'package:hew/src/core/presenter.dart';
import 'package:hew/src/widgets/presenter_builder.dart';
import 'package:hew/src/widgets/presenter_widget.dart';
import 'package:meta/meta.dart';

/// PresenterElement is an element that is used to build [PresenterWidget]s.
@internal
class PresenterElement<TPresenter extends Presenter<TModel>, TModel> extends ComponentElement {
  /// Creates a new [PresenterElement].
  PresenterElement(this._widget) : super(_widget);

  final PresenterWidget<TPresenter, TModel> _widget;

  @override
  Widget build() {
    return PresenterBuilder<TPresenter, TModel>(
      rebuildOnChanges: _widget.rebuildOnChanges,
      resolver: _widget.createPresenter,
      builder: (_, presenter, model) {
        return (widget as PresenterWidget).build(this, presenter, model);
      },
    );
  }
}
