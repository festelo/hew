import 'package:flutter/material.dart';

abstract class BasePresenter {
  @mustCallSuper
  void init();

  @mustCallSuper
  void postInit();

  @protected
  void notify([VoidCallback? fn]);

  @mustCallSuper
  void dispose();
}
