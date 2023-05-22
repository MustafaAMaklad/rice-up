import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rice_up/widgets/palatte.dart';
import '../../user_provider.dart';
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
  bool _obscurePassword = true;

  // loading icon indecator
  bool _isLoading = false;
  // sing in method
  Future<void> _signInOnPressed(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Show loading icon
      });

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
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.updateAccountEmail(email);
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
      } finally {
        setState(() {
          _isLoading = false; // Hide loading icon
        });
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
                                obscure: _obscurePassword,
                                suffix: IconButton(
                                  color: Colors.white,
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
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
                                height: 50,
                              ),
                              Visibility(
                                visible: _isLoading,
                                replacement: const SizedBox(
                                  height: 35,
                                ),
                                child: const CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
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
