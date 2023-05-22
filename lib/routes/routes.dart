import 'package:provider/provider.dart';
import 'package:rice_up/screens/model_screens/calssification_screen.dart';
import 'package:rice_up/screens/model_screens/home_screen.dart';
import 'package:rice_up/screens/authentication_screens/sign_in_screen.dart';
import 'package:rice_up/screens/authentication_screens/sign_up_confirmation_screen.dart';
import 'package:rice_up/screens/authentication_screens/sign_up_screen.dart';
import 'package:rice_up/screens/data_screens/stats_screen.dart';
import 'package:rice_up/screens/data_screens/suggestions.dart';
import '../screens/about_us_screen.dart';
import '../screens/main_screen.dart';
import '../screens/data_screens/monitor_screen.dart';
import '../user_provider.dart';

var routes = {
  '/sign_in_route': (context) => const SignInScreen(),
  '/sign_up_route': (context) => const SignUpScreen(),
  '/home_route': (context) => const HomeScreen(),
  '/main_route': (context) => const MainScreen(),
  // '/confirmation_route': (context) => const SignUpConfirmationScreen(),
  '/classification_route': (context) => const ClassificationScreen(),
  '/monitor_route': (context) => const MonitorScreen(),
  '/stats_route': (context) => const StatisticsScreen(),
  '/temperature_suggestions_route': (context) => const SuggestionScreen(),

  '/about_us_route': (context) => AboutUsScreen(),
};
