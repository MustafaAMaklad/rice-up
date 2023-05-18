import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rice_up/routes/routes.dart';
import 'package:rice_up/user_provider.dart';

import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    _configureAmplify();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/main_route',
      routes: routes,
    );
  }
}
