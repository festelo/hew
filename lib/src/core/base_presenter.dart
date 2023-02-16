import 'package:flutter/material.dart';

abstract class BasePresenter {
  void init() {}

  void postInit() {}

  @protected
  void notify([VoidCallback? fn]);

  @mustCallSuper
  void dispose() {}
}
