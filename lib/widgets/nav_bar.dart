import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  final String accountName = "Mustafa";
  final String accountEmail = "Mu575@mail.com";

  Future<void> signOutCurrentUser(context) async {
    try {
      final result = await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      debugPrint(e.toString());
    }
    Navigator.pushReplacementNamed(context, '/sign_in_route');
  }

  // Fetch user attributes
  Future<Map<String, String>> getUserAttributes() async {
    final attributes = await Amplify.Auth.fetchUserAttributes();
    final data = {for (var e in attributes) e.userAttributeKey.key: e.value};

    // for (var key in data.keys) {
    //   var value = data[key];
    //   print('$key: $value');
    // }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    // final attributes = ;
    // final String? username = attributes.keys;

    // final String accountEmail = "Mu575@mail.com";
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(accountName),
            accountEmail: Text(accountEmail),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png",
                  fit: BoxFit.cover,
                  height: 90,
                  width: 90,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                image: NetworkImage(
                  "https://t3.ftcdn.net/jpg/02/71/72/42/360_F_271724295_5mOXgLdBpOIk7jspFGSdkY1ShVqBjCie.jpg",
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          // const Divider(),
          const SizedBox(
            height: 500,
          ),
          ListTile(
            title: const Text('Sign out'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () => signOutCurrentUser(context),
          ),
        ],
      ),
    );
  }
}
