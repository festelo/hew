<p>
<a href="https://github.com/festelo/hew/actions"><img src="https://github.com/festelo/hew/actions/workflows/tests.yml/badge.svg" alt="Build & Test"></a>
<a href="https://codecov.io/gh/festelo/hew"><img src="https://codecov.io/gh/festelo/hew/branch/master/graph/badge.svg" alt="codecov"></a>
<a href="https://opensource.org/licenses/Apache-2.0"><img src="https://img.shields.io/badge/License-Apache_2.0-blue.svg" alt="License: Apache 2.0"></a>
</p>

## Hew

Hew is a simple and fast library that helps you organize your Flutter app's presentation layer.  

It's inspired by `StateNotifier` from [Riverpod](https://riverpod.dev/)  and `cubit` from [bloc](https://pub.dev/packages/bloc), and introduces two new entities: `Presenter` and `PresentationModel`.  
  
It's worth noting that `Cubit` is designed to be used in the domain layer, whereas `hew` is meant to be used exclusively in the presentation layer.  

The goal of this library is to provide a convenient way to split `StatefulWidget`s into three distinct parts:  `Model`, `Presenter` and `Widget`. By doing so, you can easily test your `Presenter` and `Model` without having to worry about `Widget` itself. Additionally, it separates your presentation logic from your view logic and makes your code easier to maintain.

## Configuring

Add `hew` to your `pubspec.yaml` file:

```yaml
dependencies:
  hew: ^0.0.1
```

## Usage

### Presenter

Presenter is a class that contains all the logic of your widget.

The presenter is responsible for updating the model of the widget, and the widget is responsible for displaying the model.

By design, it should not contain any references to `BuildContext` or `StatefulWidget` itself.

Let's look at simple counter presenter example:

```dart
class CounterPresenter extends Presenter<CounterModel> {
  CounterPresenter() : super(CounterModel());

  void onIncreaseCounterTap() => notify(() => model.counter++);
}
```

Here we have a simple presenter that creates `CounterModel` and increases counter by one on `onIncreaseCounterTap` call.

### Model

Model is a class that contains all the data that is needed to display the widget.

Let's create a simple model for our previous presenter:

```dart
class CounterModel with MutableEquatableMixin {
  int counter = 0;

  @override
  List<Object?> get mutableProps => [counter];
}
```

The model contains only one field - `counter`, the value we want to display.  
  
It also mixes in `MutableEquatableMixin` and overrides `mutableProps` getter.  
You should pass all your mutable fields to `mutableProps` getter to make `Presenter` behave correctly.  
  
`MutableEquatableMixin` is a mixin that adds `mutableHashCode` to the model. This is an integer generated based on hashCodes of fields you pass to `mutableProps`.  
  
Presenter uses `mutableHashCode` to make `notify` method notify its listeners only if there's any changes in model.

### Widget

Now it's time to display our model.

We can do this by combination of `StatelessWidget` and `PresenterProvider`, by using `StatefulWidget` and `PresenterProviderMixin` or by using `StatefulWidget` and `PresenterState`.  

Let's look how the first approach works:

```dart
class Counter extends StatelessWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PresenterProvider<CounterPresenter, CounterState>(
      presenter: () => CounterPresenter(),
      builder: (context, presenter, state) => TextButton(
        onPressed: presenter.onIncreaseCounterTap,
        child: Text('${state.counter}'),
      ),
    );
  }
}
```

Here we display the counter value inside `TextButton` and call `onIncreaseCounterTap` on `onPressed` event.
  
But sometimes we need to implement something more complex and in flutter we usually do it using `StatefulWidget`. With `hew` you can use `StatefulWidget` as you usually do, but `hew` tries to make your life even better with `PresenterProviderMixin` and `PresenterState`.  

When you mix in `PresenterProviderMixin` into your `StatefulWidget`, you get access to `presenter` and `state` properties. It also automatically handles `presenter` lifecycle for you and may rebuild your widget when `state` changes.

```dart
class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  State createState() => _CounterState();
}

class _CounterState extends PresenterState<CounterPresenter, CounterState, Counter>
  @override
  CounterPresenter createPresenter() => CounterPresenter();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: presenter.onIncreaseCounterTap,
      child: Text('${model.counter}'),
    );
  }
}
```

If you for some reason don't want to use `PresenterState` (e.g. you want to also use `StatefulHookWidget` from [flutter_hooks](https://pub.dev/packages/flutter_hooks)), you can take a look on `PresenterProviderMixin`:

```dart
class _CounterState extends State<Counter> 
  with PresenterProviderMixin<CounterPresenter, CounterState, Counter> { ... }
```


## Expansions

TBD