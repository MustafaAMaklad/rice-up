import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rice_up/widgets/palatte.dart';
import '../../widgets/widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // form state key
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // intialize text fields controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _staySignedIn = false;
  // sing in method
  Future<void> _signInOnPressed(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      // ToDo sign in code
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final signInContext = context;
      try {
        final signInResult = await Amplify.Auth.signIn(
          username: email,
          password: password,
        );
        if (signInResult.isSignedIn) {
          //           if (_staySignedIn) {
          //   await Amplify.Auth.setAuthSession(
          //     persist: true,
          //     maxAge: Duration(days: 30),
          //   );
          // }

          _goTOMainScreen(signInContext);
        }
      } on AuthException catch (e) {
        debugPrint(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  // go to main screen
  void _goTOMainScreen(BuildContext context) {
    // direct user to main screen after successfully signing in
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/main_route',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    // ignore: sized_box_for_whitespace
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        height: 80,
                        child: const Center(
                          child: Image(
                            image: AssetImage('assets/images/logo.png'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 120,
                    ),
                    // ignore: avoid_unnecessary_containers
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                      ),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // emailInput
                              TextInput(
                                icon: Icons.email,
                                hint: 'Email',
                                inputType: TextInputType.emailAddress,
                                inputAction: TextInputAction.done,
                                controller: _emailController,
                              ),

                              // passwordInput
                              TextInput(
                                icon: Icons.lock,
                                hint: 'Password',
                                inputType: TextInputType.text,
                                inputAction: TextInputAction.done,
                                controller: _passwordController,
                                obscure: true,
                              ),
                              // TextButton(
                              //   onPressed: () {
                              //     Navigator.pushNamedAndRemoveUntil(
                              //         context,
                              //         '/reset_pass_route',
                              //         ModalRoute.withName('/reset_pass_route'));
                              //   },
                              //   child: const Text(
                              //     'Forgot Password?',
                              //     style: kBodyText,
                              //   ),
                              // ),
                              // stay signed in checkbox
                            ],
                          ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 100,
                              ),
                              RoundedButton(
                                buttonText: 'Sign in',
                                onPressed: () => _signInOnPressed(context),
                              ),
                              const SizedBox(
                                height: 80,
                              ),
                              Column(
                                children: [
                                  const Text(
                                    'Don\'t have an account yet?',
                                    style: kBodyText,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/sign_up_route',
                                      );
                                    },
                                    child: const Text(
                                      'Create new account',
                                      style: kBodyButtonText,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
