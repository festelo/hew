import 'package:hew/src/mutable_equatable/mutable_equatable.dart';

/// Default type for models used by [Presenter]s.
///
/// All mutable fields of the model should be listed in [mutableFields] getter.
typedef PresentationModel = MutableEquatable;
