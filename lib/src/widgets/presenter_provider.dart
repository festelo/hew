import 'package:flutter/widgets.dart';
import 'package:hew/hew.dart';

import 'package:hew/src/widgets/model_listener.dart';

typedef BuildPresenterCallback<TPresenter extends Presenter<TPresentationModel>,
        TPresentationModel extends PresentationModel>
    = TPresenter Function();

typedef PresenterProviderCallback<
        TPresenter extends Presenter<TPresentationModel>,
        TPresentationModel extends PresentationModel>
    = Widget Function(
  BuildContext context,
  TPresenter presenter,
  TPresentationModel state,
);

class PresenterProvider<TPresenter extends Presenter<TPresentationModel>,
    TPresentationModel extends PresentationModel> extends StatefulWidget {
  const PresenterProvider({
    Key? key,
    required this.presenter,
    required this.builder,
    this.rebuildOnChanges = true,
  }) : super(key: key);

  final BuildPresenterCallback<TPresenter, TPresentationModel> presenter;
  final PresenterProviderCallback<TPresenter, TPresentationModel> builder;

  final bool rebuildOnChanges;

  @override
  State<PresenterProvider> createState() =>
      _PresenterProviderState<TPresenter, TPresentationModel>();
}

class _PresenterProviderState<TPresenter extends Presenter<TPresentationModel>,
        TPresentationModel extends PresentationModel>
    extends State<PresenterProvider<TPresenter, TPresentationModel>> {
  late final TPresenter presenter = widget.presenter();

  @override
  Widget build(BuildContext context) {
    if (widget.rebuildOnChanges) {
      return BridgeHook(
        presenter: presenter,
        child: ModelListener(
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
    presenter.dispose();
    super.dispose();
  }
}
