import 'package:hew/hew.dart';
import 'package:hew/rx.dart';

class CompletePresenter<T> extends Presenter<T>
    with MountedExpansion, ReactiveExpansion, TextEditingExpansion {
  CompletePresenter(super.state);
}
