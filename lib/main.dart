import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rice_up/routes/routes.dart';
import 'package:rice_up/screens/authentication_screens/sign_up_confirmation_screen.dart';
import 'package:rice_up/user_provider.dart';
import 'package:rice_up/widgets/palatte.dart';

import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<UserProvider>(
      create: (_) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignedIn = false;
  String initialRoute = '/sign_in_route';

  @override
  void initState() {
    super.initState();
    _configureAmplify();
    // checkAuthSession();
  }

  Future<void> _configureAmplify() async {
    try {
      // Intialize Cognito
      final auth = AmplifyAuthCognito();
      // Add Cognito plugin to amplify
      await Amplify.addPlugin(auth);

      // Intialize GraphQL API model provider
      final api = AmplifyAPI(modelProvider: ModelProvider.instance);
      // Add GraphQL API model provider plugin to amplify
      await Amplify.addPlugin(api);

      // call Amplify.configure to use the initialized categories in your app
      await Amplify.configure(amplifyconfig);

      safePrint('Configured');
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    } finally {
      checkAuthSession();
    }
  }

  Future<void> checkAuthSession() async {
    try {
      final result = await Amplify.Auth.fetchAuthSession();
      setState(() {
        isSignedIn = result.isSignedIn;
        initialRoute = isSignedIn ? '/main_route' : '/sign_in_route';
        debugPrint('is signed in: $isSignedIn');
        debugPrint('reslut..${result.isSignedIn}');
      });
    } catch (e) {
      debugPrint('Error checking auth session: $e');
    }
  }

  Future<void> _checkAuthSessionWithDelay() async {
    await Future.delayed(Duration(seconds: 5)); // Add a delay of 3 seconds
  }

  @override
  Widget build(BuildContext context) {
    String initialRoute = isSignedIn ? '/main_route' : '/sign_in_route';
    debugPrint('Intial route: $initialRoute');
    return FutureBuilder<void>(
      future: _checkAuthSessionWithDelay(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Color.fromARGB(255, 114, 147, 67),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  child: Image.asset('assets/images/logo.png'),
                ), // Replace with your image asset
                const SizedBox(height: 16.0),
                const CircularProgressIndicator(
                  color: primaryColor,
                ),
              ],
            ),
          );
        } else {
          debugPrint('Initial route: $initialRoute');
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: initialRoute,
            routes: routes,
          );
        }
      },
    );
  }
}
