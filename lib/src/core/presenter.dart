import 'package:flutter/foundation.dart';
import 'package:hew/src/core/base_presenter.dart';
import 'package:hew/src/core/presentation_state.dart';

typedef Listener = void Function();

class Presenter<TState extends PresentationState> extends ChangeNotifier
    implements BasePresenter {
  Presenter(this.state);

  final TState state;

  int? _previousMutableHashCode;

  @override
  void initState() {}

  @override
  void postInitState() {
    _previousMutableHashCode = state.mutableHashCode;
  }

  @override
  @protected
  void notifyListeners() {
    final currentMutableHashCode = state.mutableHashCode;
    if (_previousMutableHashCode == currentMutableHashCode) {
      return;
    }
    super.notifyListeners();
    _previousMutableHashCode = currentMutableHashCode;
  }

  @override
  void notify() => notifyListeners();
}
