import 'package:hew/hew.dart';

class CompletePresenter<T extends PresentationModel> extends Presenter<T>
    with
        MountedExpansion,
        DisposableExpansion,
        ReactiveExpansion,
        TextEditingExpansion {
  CompletePresenter(super.state);
}
