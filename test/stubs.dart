import 'package:hew/src/core/presenter.dart';
import 'package:hew/src/mutable_equatable/mutable_equatable.dart';

class CounterPresenter extends Presenter<int> {
  CounterPresenter() : super(0);

  int initialized = 0;
  int disposed = 0;

  @override
  void init() {
    super.init();
    initialized++;
  }

  @override
  void dispose() {
    disposed++;
    super.dispose();
  }

  void increment() {
    notify(() => model++);
  }

  void decrement() {
    notify(() => model--);
  }
}

class MutableEquatableCounterPresenter extends Presenter<MutableEquatableCounterModel> {
  MutableEquatableCounterPresenter() : super(MutableEquatableCounterModel());

  int initialized = 0;

  @override
  void init() {
    super.init();
    initialized++;
  }

  void increment() {
    notify(() => model.count++);
  }

  void incrementInternal() {
    model.internal ??= MutableEquatableCounterModel();
    model.internal!.count++;
    notify();
  }

  void decrement() {
    notify(() => model.count--);
  }
}

class MutableEquatableCounterModel with MutableEquatableMixin {
  int count = 1;
  MutableEquatableCounterModel? internal;

  @override
  List<Object?> get mutableProps => [count, internal];
}
