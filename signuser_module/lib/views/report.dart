import 'package:flutter/material.dart';

class ReportView extends StatefulWidget {
  const ReportView({Key? key}) : super(key: key);

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: Center(
        child: Text('Hi, I am Report Menu', style: Theme.of(context).textTheme.bodyMedium,),
      ),
    );
  }
}
