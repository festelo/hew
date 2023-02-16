import 'package:flutter/widgets.dart';
import 'package:hew/hew.dart';

typedef BuildPresenterCallback<TPresenter extends Presenter<TPresentationModel>,
        TPresentationModel extends PresentationModel>
    = TPresenter Function();

typedef PresenterBuilderCallback<TPresenter extends Presenter<TPresentationModel>,
        TPresentationModel extends PresentationModel>
    = Widget Function(
  BuildContext context,
  TPresenter presenter,
  TPresentationModel model,
);

class PresenterBuilder<TPresenter extends Presenter<TPresentationModel>,
    TPresentationModel extends PresentationModel> extends StatefulWidget {
  const PresenterBuilder({
    Key? key,
    required this.resolver,
    required this.builder,
    this.rebuildOnChanges = true,
    this.bindLifecycle = true,
  }) : super(key: key);

  final BuildPresenterCallback<TPresenter, TPresentationModel> resolver;
  final PresenterBuilderCallback<TPresenter, TPresentationModel> builder;

  final bool rebuildOnChanges;
  final bool bindLifecycle;

  @override
  State<PresenterBuilder> createState() => _PresenterBuilderState<TPresenter, TPresentationModel>();
}

class _PresenterBuilderState<TPresenter extends Presenter<TPresentationModel>,
        TPresentationModel extends PresentationModel>
    extends State<PresenterBuilder<TPresenter, TPresentationModel>> {
  late final TPresenter presenter = widget.resolver();

  @override
  void initState() {
    super.initState();
    if (widget.bindLifecycle) {
      presenter.init();
      presenter.postInit();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rebuildOnChanges) {
      return BridgeHook(
        presenter: presenter,
        child: ModelObserver(
          presenter: presenter,
          builder: (context) => widget.builder(
            context,
            presenter,
            presenter.model,
          ),
        ),
      );
    } else {
      return BridgeHook(
        presenter: presenter,
        child: widget.builder(
          context,
          presenter,
          presenter.model,
        ),
      );
    }
  }

  @override
  void dispose() {
    if (widget.bindLifecycle) {
      presenter.dispose();
    }
    super.dispose();
  }
}
