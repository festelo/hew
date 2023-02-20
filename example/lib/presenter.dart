import 'package:hew/hew.dart';

class CompletePresenter<T> extends Presenter<T>
    with MountedExpansion, ReactiveExpansion, TextEditingExpansion {
  CompletePresenter(super.state);
}
