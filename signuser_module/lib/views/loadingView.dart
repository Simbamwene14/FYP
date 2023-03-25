import 'package:flutter/material.dart';
import 'package:signuser_module/routes/route.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(
        seconds: 5,
      ),
    ).then(
      (value) => Navigator.pushNamedAndRemoveUntil(
          context, loginRoute, (route) => false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.cyan,
      ),
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'SMART TRACKER FOR YOUR BABY',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              wordSpacing: 1,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          CircleAvatar(
            foregroundImage: AssetImage('images/baby.jpg'),
            radius: 100,
          ),
        ],
      ),
    );
  }
}
