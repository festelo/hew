import 'package:flutter/material.dart';
import 'package:hew/hew.dart';
import 'package:hew_example/presenter.dart';

class CounterStateless extends PresenterWidget<CounterStatelessPresenter, CounterStatelessModel> {
  const CounterStateless({Key? key}) : super(key: key);

  @override
  CounterStatelessPresenter createPresenter() => CounterStatelessPresenter();

  @override
  Widget build(context, presenter, model) {
    return TextButton(
      onPressed: presenter.onIncreaseCounterTap,
      child: Text('${model.counter}'),
    );
  }
}

class CounterStatelessPresenter extends CompletePresenter<CounterStatelessModel> {
  CounterStatelessPresenter() : super(CounterStatelessModel());

  void onIncreaseCounterTap() => notify(() => model.counter++);
}

class CounterStatelessModel with MutableEquatableMixin {
  int counter = 0;

  @override
  List<Object?> get mutableProps => [counter];
}
