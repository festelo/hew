import 'package:flutter/widgets.dart';
import 'package:hew/src/core/presentation_model.dart';
import 'package:hew/src/core/presenter.dart';
import 'package:hew/src/widgets/model_listener.dart';

abstract class PresenterState< //
        TPresenter extends Presenter<TModel>, //
        TModel extends PresentationModel, //
        TWidget extends StatefulWidget> extends State<TWidget>
    with PresenterMixin<TPresenter, TModel, TWidget> {}

mixin PresenterMixin< //
    TPresenter extends Presenter<TModel>,
    TModel extends PresentationModel, //
    TWidget extends StatefulWidget //
    > on State<TWidget> {
  TPresenter createPresenter();

  late final TPresenter presenter = createPresenter();

  TModel get model => presenter.model;

  bool get rebuildOnChanges => true;

  @override
  void initState() {
    super.initState();
    presenter.init();
    presenter.postInit();
    if (rebuildOnChanges) {
      presenter.addListener(_handleChange);
    }
  }

  @override
  void dispose() {
    if (rebuildOnChanges) {
      presenter.removeListener(_handleChange);
    }
    presenter.dispose();
    super.dispose();
  }

  void _handleChange() {
    setState(() {
      // The listenable's state is our build state, and it changed already.
    });
  }

  Widget stateObserver({
    required WidgetBuilder builder,
    ModelListenerWhen<TModel>? when,
  }) {
    return ModelListener<TModel>(
      presenter: presenter,
      when: when,
      builder: builder,
    );
  }
}
