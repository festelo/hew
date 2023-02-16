import 'package:flutter/material.dart';
import 'package:hew_example/counter_builder.dart';
import 'package:hew_example/counter_stateful.dart';
import 'package:hew_example/counter_stateless.dart';
import 'package:hew_example/counters_with_observer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: const [
            CounterStateful(),
            CounterStateless(),
            CounterBuilder(),
            CountersWithObserver(),
          ],
        ),
      ),
    );
  }
}
