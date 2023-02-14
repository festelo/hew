import 'equatable_utils.dart';

abstract class MutableEquatable {
  List<Object?> get mutableProps;
  int get mutableHashCode => mapPropsToHashCode(mutableProps);
}

mixin MutableEquatableMixin implements MutableEquatable {
  @override
  List<Object?> get mutableProps;

  @override
  int get mutableHashCode => mapPropsToHashCode(mutableProps);
}
