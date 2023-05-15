import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rice_up/widgets/nav_bar.dart';
import 'package:rice_up/widgets/palatte.dart';
import 'settings_screen.dart';
import 'crop_screen.dart';
import 'dashboard_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  final screens = [
    HomeScreen(),
    DashboardScreen(),
    CropScreen(),
    SettingsScreen(),
  ];

  // final String userName = "John Doe";
  // final String email = "johndoe@example.com";
  // final String imageUrl =
  //     "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leadingWidth: 0.0,
        elevation: 0.0,
        title: Image.asset(
          'assets/images/logo-titleonly.png',
          fit: BoxFit.contain,
          height: 80,
          width: 80,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const CircleAvatar(
              radius: 20.0,
              backgroundColor: backgroundColor,
              child: Icon(
                Icons.notification_important_rounded,
                color: Colors.amber,
              ),
            ),
          ),
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
              Icons.stacked_bar_chart_outlined,
            ),
            label: 'Dashboard',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.spa,
            ),
            label: 'Crop',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.device_hub,
            ),
            label: 'Devices',
            backgroundColor: primaryColor,
          ),
        ],
      ),
    );
  }
}
