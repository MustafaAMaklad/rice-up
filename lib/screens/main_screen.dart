import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rice_up/widgets/nav_bar.dart';
import 'package:rice_up/widgets/palatte.dart';
import 'settings_screen.dart';
import 'crop_screen.dart';
import 'data_screens/dashboard_screen.dart';
import 'model_screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // getUserAttributes();
  }

  int currentIndex = 0;
  final screens = [
    HomeScreen(),
    DashboardScreen(),
    CropScreen(),
  ];
  // Fetch user attributes
  // Future<Map<String, String?>> getUserAttributes() async {
  //   final attributes = await Amplify.Auth.fetchUserAttributes();
  //   final data = {for (var e in attributes) e.userAttributeKey.key: e.value};

  //   Map<String, String?> userAttributes = {};
  //   userAttributes['accountUsername'] = data['preferred_username'];
  //   userAttributes['accountEmail'] = data['email'];
  //   setState(() {
  //     accountEmail = userAttributes['accountEmail'];
  //     accountName = userAttributes['accountUsername'];
  //   });
  //   debugPrint(accountEmail);
  //   debugPrint(accountName);
  //   return userAttributes;
  // }

  // Provider.of<UserProvider>(context, listen: false).updateUserAttributes(userAttributes);

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
          // IconButton(
          //   onPressed: () {
          //   },
          //   icon: const CircleAvatar(
          //     radius: 20.0,
          //     backgroundColor: backgroundColor,
          //     child: Icon(
          //       Icons.notification_important_rounded,
          //       color: Colors.amber,
          //     ),
          //   ),
          // ),
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
      drawer: NavBar(),
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
          BottomNavigationBarItem(
            icon: Icon(
              Icons.spa,
            ),
            label: 'Crop',
            backgroundColor: primaryColor,
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.device_hub,
          //   ),
          //   label: 'Devices',
          //   backgroundColor: primaryColor,
          // ),
        ],
      ),
    );
  }
}
