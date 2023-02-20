import 'package:hew/src/mutable_equatable/mutable_equatable.dart';
import 'package:test/test.dart';

class MutableEquatableCounter extends MutableEquatable {
  int count = 1;
  MutableEquatableCounter? internal;

  @override
  List<Object?> get mutableProps => [count, internal];
}

class MutableEquatableCounterWithMixin with MutableEquatableMixin {
  int count = 1;
  MutableEquatableCounterWithMixin? internal;

  @override
  List<Object?> get mutableProps => [count, internal];
}

void main() {
  group('MutableEquatable', () {
    test('Model changes `mutableHashCode` on field change', () {
      final model = MutableEquatableCounter();

      final oldHashCode = model.mutableHashCode;
      model.count++;

      expect(oldHashCode, isNot(model.mutableHashCode));
    });

    test('Model changes `mutableHashCode` on nested field', () {
      final model = MutableEquatableCounter();
      model.internal = MutableEquatableCounter();

      final oldHashCode = model.mutableHashCode;
      model.internal!.count++;

      expect(oldHashCode, isNot(model.mutableHashCode));
    });

    test('two different Models with equal fields are equal', () {
      final modelA = MutableEquatableCounter();
      modelA.internal = MutableEquatableCounter();

      final modelB = MutableEquatableCounter();
      modelB.internal = MutableEquatableCounter();

      modelA.count++;
      modelB.count++;

      expect(modelA.mutableHashCode, modelB.mutableHashCode);
    });

    test('mutation in field doesn\'t break Map, when Model used as key', () {
      final model = MutableEquatableCounter();
      const testMapValue = 5;
      final map = <MutableEquatableCounter, int>{
        model: testMapValue,
      };
      model.count++;

      expect(map[model], testMapValue);
    });
  });

  group('MutableEquatableMixin', () {
    test('Model changes `mutableHashCode` on field change', () {
      final model = MutableEquatableCounterWithMixin();

      final oldHashCode = model.mutableHashCode;
      model.count++;

      expect(oldHashCode, isNot(model.mutableHashCode));
    });

    test('Model changes `mutableHashCode` on nested field', () {
      final model = MutableEquatableCounterWithMixin();
      model.internal = MutableEquatableCounterWithMixin();

      final oldHashCode = model.mutableHashCode;
      model.internal!.count++;

      expect(oldHashCode, isNot(model.mutableHashCode));
    });

    test('two different Models with equal fields are equal', () {
      final modelA = MutableEquatableCounterWithMixin();
      modelA.internal = MutableEquatableCounterWithMixin();

      final modelB = MutableEquatableCounterWithMixin();
      modelB.internal = MutableEquatableCounterWithMixin();

      modelA.count++;
      modelB.count++;

      expect(modelA.mutableHashCode, modelB.mutableHashCode);
    });

    test('mutation in field doesn\'t break Map, when Model used as key', () {
      final model = MutableEquatableCounterWithMixin();
      const testMapValue = 5;
      final map = <MutableEquatableCounterWithMixin, int>{
        model: testMapValue,
      };

      expect(map[model], testMapValue);
    });
  });
}
