import 'package:flutter/material.dart';
import 'package:signuser_module/routes/route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signuser_module/themes/projectTheme.dart';
import 'package:signuser_module/views/activity.dart';
import 'package:signuser_module/views/behavior.dart';
import 'package:signuser_module/views/club.dart';
import 'package:signuser_module/views/loadingView.dart';
import 'package:signuser_module/views/milestone.dart';
import 'package:signuser_module/views/profileView.dart';
import 'package:signuser_module/views/report.dart';
import 'services/auth/auth_services.dart';
import 'views/register.dart';
import 'views/login.dart';
import 'views/contentView.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ToddlerApp());
}

class ToddlerApp extends StatelessWidget {
  const ToddlerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: projectTheme,
      home: const IndexPage(),
      initialRoute: loadingRoute,
      routes: {
        loadingRoute:(context) => const LoadingView(),
        loginRoute:(context) => const LoginPage(),
        registerRoute:(context) => const Register(),
        contentRoute:(context) => const ContentView(),
        milestoneRoute:(context) => const Milestones(),
        activityRoute:(context) => const ActivityView(),
        clubRoute:(context) => const ClubView(),
        reportRoute:(context) => const ReportView(),
        behaviorRoute:(context) => const BehaviorView(),
        profileViewRoute:(context) => const ProfileView(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
       switch(snapshot.connectionState) {
         case ConnectionState.done:
           final user = FirebaseAuth.instance.currentUser;
           if(user == null){
             return const Register();
           }
       }
        return const ContentView();
      },
      future: AuthService.firebase().initialize(),
    );
  }
}
