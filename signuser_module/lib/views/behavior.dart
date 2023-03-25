import 'package:flutter/material.dart';
import '../themes/projectTheme.dart';

class BehaviorView extends StatefulWidget {
  const BehaviorView({Key? key}) : super(key: key);

  @override
  State<BehaviorView> createState() => _BehaviorViewState();
}

class _BehaviorViewState extends State<BehaviorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Behavior'),
      ),
      body:Center(
        child: Text('Hi, I am Behavior Menu', style: Theme.of(context).textTheme.bodyMedium,),
      ),
    );
  }
}
