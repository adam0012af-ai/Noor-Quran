import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});
  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  late int count;
  @override
  void initState() {
    super.initState();
    count = Hive.box('counters').get('tasbeeh', defaultValue: 0) as int;
  }

  Future<void> _increment() async {
    HapticFeedback.selectionClick();
    setState(() => count++);
    await Hive.box('counters').put('tasbeeh', count);
  }

  Future<void> _reset() async {
    setState(() => count = 0);
    await Hive.box('counters').put('tasbeeh', 0);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('السبحة الرقمية'), actions: [IconButton(onPressed: _reset, icon: const Icon(Icons.refresh))]),
        body: Center(child: GestureDetector(onTap: _increment, child: Container(width: 240, height: 240, decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.primaryContainer), child: Center(child: Text('$count', style: Theme.of(context).textTheme.displayLarge))))),
      );
}
