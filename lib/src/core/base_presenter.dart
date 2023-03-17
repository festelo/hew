import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Abstraction for a presenter.
/// Declares basic lifecycle and update methods.
abstract class BasePresenter {
  /// Initializes the presenter.
  /// Should be called just after the presenter is created and attached to a widget.
  @mustCallSuper
  @internal
  void init();

  /// Internal method that is called after the presenter is initialized.
  /// Finalizes the initialization process.
  @mustCallSuper
  @internal
  void postInit();

  /// Protected method used to notify listeners about changes in model.
  /// Optional callback can be passed to be executed before the notification.
  @protected
  void notify([VoidCallback? fn]);

  /// Disposes the presenter.
  /// Should be called when the presenter is no longer needed.
  /// All the resources should be released here.
  @mustCallSuper
  @internal
  void dispose();
}
