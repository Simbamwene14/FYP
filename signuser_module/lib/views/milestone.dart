import 'package:flutter/material.dart';

class Milestones extends StatefulWidget {
  const Milestones({Key? key}) : super(key: key);

  @override
  State<Milestones> createState() => _MilestonesState();
}

class _MilestonesState extends State<Milestones> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Milestones'),
      ),
      body: Center(
        child: Text('Hi, I am Behavior Menu', style: Theme.of(context).textTheme.bodyMedium,),
      ),
    );
  }
}
