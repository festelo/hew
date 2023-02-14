import 'package:flutter/widgets.dart';
import 'package:hew/src/core/presentation_state.dart';
import 'package:hew/src/core/presenter.dart';
import 'package:hew/src/mutable_equatable/mutable_equatable.dart';

typedef StateListenerBuildWhen<TState> = dynamic Function(TState state);

class StateListener<TState extends PresentationState> extends StatefulWidget {
  /// Creates a widget that rebuilds when the given listenable changes.
  ///
  /// The [listenable] argument is required.
  const StateListener({
    Key? key,
    required this.presenter,
    required this.build,
    this.buildWhen,
  }) : super(key: key);

  final Presenter<TState> presenter;
  final StateListenerBuildWhen<TState>? buildWhen;
  final WidgetBuilder build;

  @override
  State<StateListener> createState() => _StateListenerState();
}

class _StateListenerState extends State<StateListener> {
  int? _buildWhenPreviousHashCode;

  @override
  void initState() {
    super.initState();
    widget.presenter.addListener(_handleChange);
    _reinitBuildWhenHashCode();
  }

  @override
  void didUpdateWidget(StateListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.presenter != oldWidget.presenter) {
      oldWidget.presenter.removeListener(_handleChange);
      widget.presenter.addListener(_handleChange);
    }
    if (widget.buildWhen != oldWidget.buildWhen) {
      _reinitBuildWhenHashCode();
    }
  }

  @override
  void dispose() {
    widget.presenter.removeListener(_handleChange);
    super.dispose();
  }

  void _reinitBuildWhenHashCode() {
    _buildWhenPreviousHashCode = _getBuildWhenHashCode();
  }

  int? _getBuildWhenHashCode() {
    if (widget.buildWhen == null) {
      return null;
    }
    final buildWhen = widget.buildWhen!(widget.presenter.state);
    if (buildWhen is MutableEquatable) {
      return buildWhen.mutableHashCode;
    }
    return buildWhen.hashCode;
  }

  void _handleChange() {
    if (widget.buildWhen == null) {
      setState(() {
        // The listenable's state is our build state, and it changed already.
      });
    } else {
      final buildWhenHashCode = _getBuildWhenHashCode();
      if (buildWhenHashCode != _buildWhenPreviousHashCode) {
        _buildWhenPreviousHashCode = buildWhenHashCode;
        setState(() {
          // The listenable's state is our build state, and it changed already.
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.build(context);
}
