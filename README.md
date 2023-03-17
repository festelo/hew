<p>
<a href="https://github.com/festelo/hew/actions"><img src="https://github.com/festelo/hew/actions/workflows/tests.yml/badge.svg" alt="Build & Test"></a>
<a href="https://codecov.io/gh/festelo/hew"><img src="https://codecov.io/gh/festelo/hew/branch/main/graph/badge.svg" alt="codecov"></a>
<a href="https://opensource.org/licenses/mit"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"></a>
</p>

## Hew

Hew is a simple and fast library that helps you organize your Flutter app's presentation layer.  

It's inspired by `StateNotifier` from [Riverpod](https://riverpod.dev/)  and `Cubit` from [bloc](https://pub.dev/packages/bloc), and introduces two new entities: `Presenter` and `PresentationModel`.  
  
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

The presenter is responsible for updating a model of the widget, and the widget is responsible for displaying the model.

Let's look at the counter presenter example:

```dart
class CounterPresenter extends Presenter<CounterModel> {
  CounterPresenter() : super(CounterModel());

  void onIncreaseCounterTap() => notify(() => model.counter++);
}
```

Here we have a simple presenter that creates `CounterModel` and increases counter by one on `onIncreaseCounterTap` call.

### Model

Model is a class that contains all data we want to be displayed in the widget.

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
  
Presenter uses `mutableHashCode` to make `notify` method notify its listeners only if there're any changes in model.

### Widget

Now it's time to display our model.

We can do this by using `PresenterWidget`, `PresenterStatefulWidget` or by using `PresenterBuilder`. 

Let's look how the first approach works:

```dart
class Counter extends PresenterWidget<CounterPresenter, CounterModel> {
  const Counter({Key? key}) : super(key: key);

  @override
  CounterPresenter createPresenter() => CounterPresenter();

  @override
  Widget build(context, presenter, model) {
    return TextButton(
      onPressed: presenter.onIncreaseCounterTap,
      child: Text(model.counter.toString()),
    );
  }
}
```

Here we display the counter value inside `TextButton` and call `onIncreaseCounterTap` on `onPressed` event.   
`PresenterWidget` maintains `Presenter` lifecycle and supports automatic rebuilding on `model` change.
  
But sometimes we need to implement something more complex and in flutter we usually do it by using `StatefulWidget`. `Hew` has `PresenterStatefulWidget` for this:  


```dart
class Counter extends PresenterStatefulWidget<CounterPresenter> {
  const Counter({super.key});

  @override
  CounterPresenter createPresenter() => CounterPresenter();

  @override
  PresenterState createState() => _CounterState();
}

class _CounterState
    extends PresenterState<CounterPresenter, CounterModel, Counter> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: presenter.onIncreaseCounterTap,
      child: Text(model.counter.toString()),
    );
  }
}
```

And if you want to be more flexible, you can use `PresenterBuilder`:

```dart
class Counter extends StatelessWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PresenterBuilder<CounterPresenter, CounterModel>(
      resolver: () => CounterPresenter(),
      builder: (context, presenter, model) => TextButton(
        onPressed: presenter.onIncreaseCounterTap,
        child: Text(model.counter.toString()),
      ),
    );
  }
}

```

### ModelObserver

All previous approaches by default automatically rebuild themself whenever the model changes. If you want to handle state changes manually, you can disable this behaviour and use `ModelObserver`.

To disable automatic rebuilding, you can pass `false` to `rebuildOnChanges` parameter of `PresenterBuilder`, or override `rebuildOnChanges` getter in your `PresenterWidget` and `PresenterStatefulWidget`:

```dart
class Counter extends PresenterWidget<CounterPresenter> {
  bool get rebuildOnChanges => false;
  ...
}

// or

@override
Widget build(BuildContext context) {
  return PresenterBuilder<CounterPresenter, CounterModel>(
    rebuildOnChanges: false,
    resolver: () => CounterPresenter(),
    builder: (context, presenter, model) => TextButton(
      onPressed: presenter.onIncreaseCounterTap,
      child: Text(model.counter.toString()),
    ),
  );
}
```

Then you should use `ModelObserver` to track model changes:

```dart
@override
Widget build(context, presenter, model) {
  return ModelObserver(
    presenter: presenter,
    builder: (context) => TextButton(
      onPressed: presenter.onIncreaseCounterATap,
      child: Text(model.counter.toString()),
    ),
  );
}
```

If you want to rebuild your widget only when changes are in some specific field, you can use `when` parameter, just specify a path to the field:  
`when: (model) => model.counterB`.   

If there are multiple fields, you can pass a list of fields as well:  
`when: (model) => [model.counterA, model.counterB]`.

## Expansions

TBD