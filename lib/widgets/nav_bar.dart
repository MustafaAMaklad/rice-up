import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rice_up/widgets/palatte.dart';

import '../user_provider.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  Future<void> signOutCurrentUser(context) async {
    try {
      final result = await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      debugPrint(e.toString());
    }
    Navigator.pushReplacementNamed(context, '/sign_in_route');
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final accountEmail = userProvider.accountEmail;
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(
              accountEmail,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: primaryLightColor,
              child: Image.asset('assets/images/user.png'),
            ),
            accountName: null,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 114, 147, 67)),
          ),
          ListTile(
            leading: const Icon(
              Icons.info,
              color: primaryColor,
            ),
            title: const Text('About Us'),
            onTap: () {
              Navigator.pushNamed(context, '/about_us_route');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: primaryColor,
            ),
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
