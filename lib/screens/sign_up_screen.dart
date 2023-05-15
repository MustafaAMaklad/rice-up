import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rice_up/screens/sign_up_confirmation_screen.dart';
import '../widgets/palatte.dart';
import '../widgets/widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Intialize the text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Sign up auth method
  Future<void> _signUpOnPressed(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final signUpResult = await Amplify.Auth.signUp(
          username: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          options: CognitoSignUpOptions(
            userAttributes: {
              CognitoUserAttributeKey.email: _emailController.text.trim(),
              CognitoUserAttributeKey.preferredUsername:
                  _usernameController.text.trim()
            },
          ),
        );
        // debugPrint("Error in signupresult get controller");
        if (signUpResult.isSignUpComplete) {
          _goTOSignUpConfirmationScreen(context, _emailController.text.trim());
          debugPrint("Sign Up done, forwarded to confirm");
        }
      } on AuthException catch (e) {
        debugPrint(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message),
          duration: const Duration(seconds: 5),
        ));
      }
    }
  }

  void _goTOSignUpConfirmationScreen(BuildContext context, String email) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SignUpConfirmationScreen(
          email: email,
        ),
      ),
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
                      height: 30,
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
                              // username Input
                              TextInput(
                                icon: Icons.person,
                                hint: 'Username',
                                inputType: TextInputType.text,
                                inputAction: TextInputAction.done,
                                controller: _usernameController,
                              ),

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
                            ],
                          ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              RoundedButton(
                                buttonText: 'Sign up',
                                onPressed: () => _signUpOnPressed(context),
                              ),
                              const SizedBox(
                                height: 100,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Already have an account?',
                                      style: kBodyText,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/sign_in_route',
                                            ModalRoute.withName(
                                                '/sign_in_route'));
                                      },
                                      child: const Text(
                                        'Sign in',
                                        style: kBodyButtonText,
                                      ),
                                    ),
                                  ],
                                ),
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
