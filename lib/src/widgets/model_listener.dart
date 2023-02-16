import 'package:flutter/widgets.dart';
import 'package:hew/src/core/presentation_model.dart';
import 'package:hew/src/core/presenter.dart';
import 'package:hew/src/mutable_equatable/mutable_equatable.dart';

typedef ModelListenerWhen<TModel> = dynamic Function(TModel state);

class ModelListener<TModel extends PresentationModel> extends StatefulWidget {
  /// Creates a widget that rebuilds when the given listenable changes.
  ///
  /// The [listenable] argument is required.
  const ModelListener({
    Key? key,
    required this.presenter,
    required this.builder,
    this.when,
  }) : super(key: key);

  final Presenter<TModel> presenter;
  final ModelListenerWhen<TModel>? when;
  final WidgetBuilder builder;

  @override
  State<ModelListener> createState() => _ModelListenerState();
}

class _ModelListenerState extends State<ModelListener> {
  int? _whenPreviousHashCode;

  @override
  void initState() {
    super.initState();
    widget.presenter.addListener(_handleChange);
    _reinitWhenHashCode();
  }

  @override
  void didUpdateWidget(ModelListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.presenter != oldWidget.presenter) {
      oldWidget.presenter.removeListener(_handleChange);
      widget.presenter.addListener(_handleChange);
    }
    if (widget.when != oldWidget.when) {
      _reinitWhenHashCode();
    }
  }

  @override
  void dispose() {
    widget.presenter.removeListener(_handleChange);
    super.dispose();
  }

  void _reinitWhenHashCode() {
    _whenPreviousHashCode = _getWhenHashCode();
  }

  int? _getWhenHashCode() {
    if (widget.when == null) {
      return null;
    }
    final when = widget.when!(widget.presenter.model);
    if (when is MutableEquatable) {
      return when.mutableHashCode;
    }
    return when.hashCode;
  }

  void _handleChange() {
    if (widget.when == null) {
      setState(() {
        // The listenable's state is our build state, and it changed already.
      });
    } else {
      final whenHashCode = _getWhenHashCode();
      if (whenHashCode != _whenPreviousHashCode) {
        _whenPreviousHashCode = whenHashCode;
        setState(() {
          // The listenable's state is our build state, and it changed already.
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);
}
