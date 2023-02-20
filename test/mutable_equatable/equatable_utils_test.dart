import 'package:hew/src/mutable_equatable/equatable_utils.dart';
import 'package:test/test.dart';

import '../stubs.dart';

void main() {
  test('List changes hashCode returned by mapPropToHashCode when modified', () {
    final list = [1, 2, 3];
    final hashCodeA = mapPropToHashCode(list);
    list.add(4);
    final hashCodeB = mapPropToHashCode(list);
    expect(hashCodeA, isNot(hashCodeB));
  });

  test('Set changes hashCode returned by mapPropToHashCode when modified', () {
    final set = {1, 2, 3};
    final hashCodeA = mapPropToHashCode(set);
    set.add(4);
    final hashCodeB = mapPropToHashCode(set);
    expect(hashCodeA, isNot(hashCodeB));
  });

  test('Map changes hashCode returned by mapPropToHashCode when modified', () {
    final map = {1: 1, 2: 2, 3: 3};
    final hashCodeA = mapPropToHashCode(map);
    map[4] = 4;
    final hashCodeB = mapPropToHashCode(map);
    expect(hashCodeA, isNot(hashCodeB));
  });

  test('Map changes hashCode returned by mapPropToHashCode when one of values is modified', () {
    final model = MutableEquatableCounterModel();
    final map = {1: 1, 2: model, 3: 3};
    final hashCodeA = mapPropToHashCode(map);
    model.count++;
    final hashCodeB = mapPropToHashCode(map);
    expect(hashCodeA, isNot(hashCodeB));
  });
}
