import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rice_up/widgets/nav_bar.dart';
import 'package:rice_up/widgets/palatte.dart';
// import 'settings_screen.dart';
import 'data_screens/dashboard_screen.dart';
import 'model_screens/home_screen.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  String userId = '';
  final url =
      'https://pb3crrjdhc.execute-api.us-east-1.amazonaws.com/dev/devices?user_id=ed174e10-7480-46f5-b31e-616d638e260b';
  int deviceID = 0;
  @override
  void initState() {
    super.initState();
    // getCurrentUser();
    // getDeviceId();
  }

  int currentIndex = 0;
  final screens = [
    HomeScreen(),
    DashboardScreen(),
  ];
  getCurrentUserID() {}

  // Future<void> getCurrentUser() async {
  //   final user = await Amplify.Auth.getCurrentUser();
  //   setState(() {
  //     userId = user.userId;
  //   });
  //   debugPrint('userId: $userId');
  // }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leadingWidth: 0.0,
        elevation: mainElevation,
        title: Image.asset(
          'assets/images/logo-titleonly.png',
          fit: BoxFit.contain,
          height: 80,
          width: 80,
        ),
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: const CircleAvatar(
              radius: 20.0,
              backgroundColor: backgroundColor,
              child: Icon(
                Icons.settings_rounded,
                color: Colors.amber,
              ),
            ),
          ),
        ],
        backgroundColor: primaryLightColor,
      ),
      drawer: const NavBar(),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amberAccent,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.line_axis,
            ),
            label: 'Dashboard',
            backgroundColor: primaryColor,
          ),
        ],
      ),
    );
  }
}
