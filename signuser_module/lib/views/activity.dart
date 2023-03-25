import 'package:flutter/material.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({Key? key}) : super(key: key);

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
      ),
      body: Center(
        child: Text(
          'Hi, I am Activity Menu',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
