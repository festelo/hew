import 'package:hew/src/mutable_equatable/mutable_equatable.dart';

// imports for documentation only
import 'presenter.dart';
// </>

/// Default type for models used by [Presenter]s.
///
/// All mutable fields of the model should be listed in [MutableEquatable.mutableProps] getter.
typedef PresentationModel = MutableEquatable;
