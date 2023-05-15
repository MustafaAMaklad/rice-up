import 'package:rice_up/screens/calssification_screen.dart';
import 'package:rice_up/screens/home_screen.dart';
import 'package:rice_up/screens/sign_in_screen.dart';
import 'package:rice_up/screens/sign_up_confirmation_screen.dart';
import 'package:rice_up/screens/sign_up_screen.dart';
import 'package:rice_up/screens/stats_screen.dart';
import '../screens/main_screen.dart';
import '../screens/monitor_screen.dart';

var routes = {
  '/sign_in_route': (context) => const SignInScreen(),
  '/sign_up_route': (context) => const SignUpScreen(),
  '/home_route': (context) => const HomeScreen(),
  '/main_route': (context) => const MainScreen(),
  // '/confirmation_route': (context) => const SignUpConfirmationScreen(),
  '/classification_route': (context) => const ClassificationScreen(),
  '/monitor_route': (context) => const MonitorScreen(),
  '/stats_route': (context) => StatisticsScreen(),
};
