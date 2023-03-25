import 'package:flutter/material.dart';

class ClubView extends StatefulWidget {
  const ClubView({Key? key}) : super(key: key);

  @override
  State<ClubView> createState() => _ClubViewState();
}

class _ClubViewState extends State<ClubView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Club'),
      ),
      body: Center(
        child: Text('Hi, I am Club Menu', style: Theme.of(context).textTheme.bodyMedium,),
      ),
    );
  }
}
