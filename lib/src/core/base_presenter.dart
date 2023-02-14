import 'package:flutter/material.dart';

abstract class BasePresenter {
  void initState() {}

  void postInitState() {}

  @protected
  void notify();

  @mustCallSuper
  void dispose() {}
}
