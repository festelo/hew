import 'package:flutter/material.dart';
import 'package:hew/hew.dart';
import 'package:hew_example/presenter.dart';

class CounterStateful extends StatefulWidget {
  const CounterStateful({Key? key}) : super(key: key);

  @override
  State createState() => _CounterStatefulState();
}

class _CounterStatefulState
    extends PresenterState<CounterStatefulPresenter, CounterStatefulState, CounterStateful> {
  @override
  CounterStatefulPresenter createPresenter() => CounterStatefulPresenter();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: presenter.onIncreaseCounterTap,
      child: Text('${model.counter}'),
    );
  }
}

class CounterStatefulPresenter extends CompletePresenter<CounterStatefulState> {
  CounterStatefulPresenter() : super(CounterStatefulState());

  void onIncreaseCounterTap() => notify(() => model.counter++);
}

class CounterStatefulState with MutableEquatableMixin {
  int counter = 0;

  @override
  List<Object?> get mutableProps => [counter];
}
