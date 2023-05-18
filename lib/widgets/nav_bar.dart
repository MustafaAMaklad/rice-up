import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rice_up/widgets/palatte.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key, String? accountName, String? accountEmail})
      : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String accountName = "Mustafa";
  String accountEmail = "Mu575@mail.com";

  @override
  void initState() {
    super.initState();
    // fetchAndUpdateUserAttributes();
  }

  Future<void> signOutCurrentUser(context) async {
    try {
      final result = await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      debugPrint(e.toString());
    }
    Navigator.pushReplacementNamed(context, '/sign_in_route');
  }

  Future<void> fetchAndUpdateUserAttributes() async {
    final userAttributes = await getUserAttributes();

    if (userAttributes != null) {
      setState(() {
        accountName = userAttributes['accountUsername'] ?? accountName;
        accountEmail = userAttributes['accountEmail'] ?? accountEmail;
      });
    }
  }

  Future<Map<String, String?>> getUserAttributes() async {
    final attributes = await Amplify.Auth.fetchUserAttributes();
    final data = {for (var e in attributes) e.userAttributeKey.key: e.value};

    Map<String, String?> userAttributes = {};
    userAttributes['accountUsername'] = data['preferred_username'];
    userAttributes['accountEmail'] = data['email'];
    debugPrint(userAttributes['accountUsername']);
    debugPrint(userAttributes['accountEmail']);
    return userAttributes;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(accountName),
            accountEmail: Text(accountEmail),
            currentAccountPicture: CircleAvatar(
              child: Image.asset('assets/images/user.png'),
              backgroundColor: primaryColor,
            ),
          ),
          // ListTile(
          //   leading: Icon(Icons.home),
          //   title: Text('Home'),
          //   onTap: () {
          //     Navigator.pushReplacementNamed(context, '/home_route');
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.dashboard),
          //   title: Text('Dashboard'),
          //   onTap: () {
          //     Navigator.pushReplacementNamed(context, '/main_route');
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.spa),
          //   title: Text('Crop'),
          //   onTap: () {
          //     Navigator.pushReplacementNamed(context, '/crop_route');
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Settings'),
          //   onTap: () {
          //     Navigator.pushReplacementNamed(context, '/settings_route');
          //   },
          // ),
          const SizedBox(
            height: 380,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
              signOutCurrentUser(context);
            },
          ),
        ],
      ),
    );
  }
}
