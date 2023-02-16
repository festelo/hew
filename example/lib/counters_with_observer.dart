import 'package:flutter/material.dart';
import 'package:hew/hew.dart';
import 'package:hew_example/presenter.dart';

class CountersWithObserver
    extends PresenterWidget<CountersWithObserverPresenter, CountersWithObserverModel> {
  const CountersWithObserver({Key? key}) : super(key: key);

  @override
  bool get rebuildOnChanges => false;

  @override
  CountersWithObserverPresenter createPresenter() => CountersWithObserverPresenter();

  @override
  Widget build(context, presenter, model) {
    return ModelObserver(
      presenter: presenter,
      when: (model) => model.counterB,
      builder: (context) => Row(
        children: [
          TextButton(
            onPressed: presenter.onIncreaseCounterATap,
            child: Text('${model.counterA}'),
          ),
          TextButton(
            onPressed: presenter.onIncreaseCounterBTap,
            child: Text('${model.counterB}'),
          ),
        ],
      ),
    );
  }
}

class CountersWithObserverPresenter extends CompletePresenter<CountersWithObserverModel> {
  CountersWithObserverPresenter() : super(CountersWithObserverModel());

  void onIncreaseCounterATap() => notify(() => model.counterA++);
  void onIncreaseCounterBTap() => notify(() => model.counterB++);
}

class CountersWithObserverModel with MutableEquatableMixin {
  int counterA = 0;
  int counterB = 0;

  @override
  List<Object?> get mutableProps => [counterA, counterB];
}
