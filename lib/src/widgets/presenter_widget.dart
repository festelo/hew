import 'package:flutter/material.dart';
import 'package:hew/src/core/presentation_state.dart';
import 'package:hew/src/core/presenter.dart';
import 'package:hew/src/widgets/state_listener.dart';

mixin PresenterWidgetMixin<TPresenter extends Presenter> on StatefulWidget {
  TPresenter createPresenter();

  bool get rebuildOnChanges => true;
}

abstract class PresenterState<
        TState extends PresentationState,
        TPresenter extends Presenter<TState>,
        T extends PresenterWidgetMixin<TPresenter>> extends State<T>
    with PresenterStateMixin<TState, TPresenter, T> {}

mixin PresenterStateMixin<
    TState extends PresentationState,
    TPresenter extends Presenter<TState>,
    T extends PresenterWidgetMixin<TPresenter>> on State<T> {
  late final TPresenter presenter = widget.createPresenter();
  TState get state => presenter.state;

  @override
  void initState() {
    super.initState();
    presenter.initState();
    presenter.postInitState();
    if (widget.rebuildOnChanges) {
      presenter.addListener(_handleChange);
    }
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rebuildOnChanges != oldWidget.rebuildOnChanges) {
      if (widget.rebuildOnChanges) {
        presenter.addListener(_handleChange);
      } else {
        presenter.removeListener(_handleChange);
      }
    }
  }

  @override
  void dispose() {
    if (widget.rebuildOnChanges) {
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
    StateListenerBuildWhen<TState>? buildWhen,
  }) {
    return StateListener<TState>(
      presenter: presenter,
      buildWhen: buildWhen,
      build: builder,
    );
  }
}
