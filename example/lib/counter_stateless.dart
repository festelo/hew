import 'package:flutter/material.dart';
import 'package:hew/hew.dart';
import 'package:hew_example/presenter.dart';

class CounterStateless extends StatelessWidget {
  const CounterStateless({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PresenterProvider<CounterStatelessPresenter, CounterStatelessModel>(
      presenter: () => CounterStatelessPresenter(),
      builder: (context, presenter, state) => TextButton(
        onPressed: presenter.onIncreaseCounterTap,
        child: Text('${state.counter}'),
      ),
    );
  }
}

class CounterStatelessPresenter
    extends CompletePresenter<CounterStatelessModel> {
  CounterStatelessPresenter() : super(CounterStatelessModel());

  void onIncreaseCounterTap() => notify(() => model.counter++);
}

class CounterStatelessModel with MutableEquatableMixin {
  int counter = 0;

  @override
  List<Object?> get mutableProps => [counter];
}
