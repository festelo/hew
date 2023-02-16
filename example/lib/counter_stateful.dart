import 'package:flutter/material.dart';
import 'package:hew/hew.dart';
import 'package:hew_example/presenter.dart';

class CounterStateful extends PresenterStatefulWidget<CounterStatefulPresenter> {
  const CounterStateful({super.key});

  @override
  CounterStatefulPresenter createPresenter() => CounterStatefulPresenter();

  @override
  PresenterState createState() => _CounterStatefulState();
}

class _CounterStatefulState
    extends PresenterState<CounterStatefulPresenter, CounterStatefulModel, CounterStateful> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: presenter.onIncreaseCounterTap,
      child: Text('${model.counter}'),
    );
  }
}

class CounterStatefulPresenter extends CompletePresenter<CounterStatefulModel> {
  CounterStatefulPresenter() : super(CounterStatefulModel());

  void onIncreaseCounterTap() => notify(() => model.counter++);
}

class CounterStatefulModel with MutableEquatableMixin {
  int counter = 0;

  @override
  List<Object?> get mutableProps => [counter];
}
