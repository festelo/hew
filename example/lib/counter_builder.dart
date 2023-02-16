import 'package:flutter/material.dart';
import 'package:hew/hew.dart';
import 'package:hew_example/presenter.dart';

class CounterBuilder extends StatelessWidget {
  const CounterBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PresenterBuilder<CounterBuilderPresenter, CounterBuilderModel>(
      resolver: () => CounterBuilderPresenter(),
      builder: (context, presenter, model) => TextButton(
        onPressed: presenter.onIncreaseCounterTap,
        child: Text('${model.counter}'),
      ),
    );
  }
}

class CounterBuilderPresenter extends CompletePresenter<CounterBuilderModel> {
  CounterBuilderPresenter() : super(CounterBuilderModel());

  void onIncreaseCounterTap() => notify(() => model.counter++);
}

class CounterBuilderModel with MutableEquatableMixin {
  int counter = 0;

  @override
  List<Object?> get mutableProps => [counter];
}
