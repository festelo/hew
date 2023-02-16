// TAKEN FROM: https://github.com/felangel/equatable/blob/master/lib/src/equatable_utils.dart
// Copyright: 2022, Felix Angelov.
// Commit: c5f1bbe8aa21091d0a0d59834ec24aa71223a54e
// Thank you Felix Angelov for this awesome library!

import 'package:collection/collection.dart';
import 'package:hew/src/mutable_equatable/mutable_equatable.dart';

int mapPropToHashCode(dynamic prop) => _combine(0, prop);
int mapPropsToHashCode(Iterable? props) => _finish(props == null ? 0 : props.fold(0, _combine));

int mutableHashOrHashCode(dynamic object) {
  if (object is MutableEquatable) {
    return object.mutableHashCode;
  }
  return object.hashCode;
}

/// Jenkins Hash Functions
/// https://en.wikipedia.org/wiki/Jenkins_hash_function
int _combine(int hash, dynamic object) {
  if (object is Map) {
    object.keys
        .sorted((dynamic a, dynamic b) => mutableHashOrHashCode(a) - mutableHashOrHashCode(b))
        .forEach((dynamic key) {
      hash = hash ^ _combine(hash, <dynamic>[key, object[key]]);
    });
    return hash;
  }
  if (object is Set) {
    object = object.sorted(
      ((dynamic a, dynamic b) => mutableHashOrHashCode(a) - mutableHashOrHashCode(b)),
    );
  }
  if (object is Iterable) {
    for (final value in object) {
      hash = hash ^ _combine(hash, value);
    }
    return hash ^ object.length;
  }

  hash = 0x1fffffff & (hash + mutableHashOrHashCode(object));
  hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
  return hash ^ (hash >> 6);
}

int _finish(int hash) {
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash = hash ^ (hash >> 11);
  return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}
