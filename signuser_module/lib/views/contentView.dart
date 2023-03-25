import 'dart:async';
import 'package:flutter/material.dart';
import 'package:signuser_module/routes/route.dart';
import 'package:signuser_module/services/auth/auth_services.dart';
import 'dart:developer' as devtools show log;

class ContentView extends StatefulWidget {
  const ContentView({Key? key}) : super(key: key);

  @override
  State<ContentView> createState() => _ContentViewState();
}

enum MenuAction { signOut, profile }

class _ContentViewState extends State<ContentView> {
  late PageController _controller;
  int pageNo = 0;

  Timer? carousalTimer;

  Timer getTimer() {
    return Timer.periodic(const Duration(seconds: 2), (timer) {
      if (pageNo == 5) {
        pageNo = 0;
      }
      _controller.animateToPage(pageNo,
          duration: const Duration(
            seconds: 1,
          ),
          curve: Curves.linear);
      pageNo++;
    });
  }

  List<Map<String, dynamic>> activity = [
    {
      "title": "Milestones",
      "description": "Track your baby growth",
      "pageRoute": milestoneRoute,
    },
    {
      "title": "Activities",
      "description": "Boost your baby's growth",
      "pageRoute": activityRoute,
    },
    {
      "title": "Behavior",
      "description": "Learn and record behaviors show by your baby",
      "pageRoute": behaviorRoute,
    },
    {
      "title": "Club",
      "description": "Meet other people and share experience",
      "pageRoute": clubRoute,
    },
    {
      "title": "Report",
      "description": "Generate Report of growth of your baby",
      "pageRoute": reportRoute,
    },
  ];

  @override
  void initState() {
    _controller = PageController(
      initialPage: 0,
      viewportFraction: 0.85,
    );
    carousalTimer = getTimer();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Content Page'),
        centerTitle: true,
        actions: [
          PopupMenuButton<MenuAction>(
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: MenuAction.signOut,
                  child: Text("Sign Out"),
                ),
                const PopupMenuItem(
                  value: MenuAction.profile,
                  child: Text("Profile"),
                ),
              ];
            },
            onSelected: (value) async {
              switch (value) {
                case MenuAction.signOut:
                  final shouldLogOut = await showWarningAlert(context);
                  devtools.log(shouldLogOut.toString());
                  if (shouldLogOut) {
                    await AuthService.firebase().logOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  }
                  break;
                case MenuAction.profile:
                  Navigator.pushNamedAndRemoveUntil(context, profileViewRoute, (route) => false);
                  break;
              }
            },
          )
        ],
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              SizedBox(
                height: 220,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      pageNo = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return child!;
                      },
                      child: GestureDetector(
                        onPanDown: (d) {
                          carousalTimer?.cancel();
                          carousalTimer = null;
                        },
                        onPanCancel: () {
                          carousalTimer = getTimer();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(20),
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity[index]['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                activity[index]['description'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(
                                height: 35,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          activity[index]['pageRoute'],
                                          (route) => false);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  controller: _controller,
                  itemCount: 5,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Container(
                    margin: const EdgeInsets.all(2),
                    child: Icon(
                      Icons.circle,
                      size: 12,
                      color: pageNo == index ? Colors.blue : Colors.grey,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> showWarningAlert(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to sign out!"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Sign Out")),
        ],
      );
    },
  ).then((value) => value ?? false);
}
