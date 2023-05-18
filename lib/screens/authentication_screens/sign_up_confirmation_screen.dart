import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rice_up/screens/main_screen.dart';

import '../../widgets/background_image.dart';
import '../../widgets/rounded_button.dart';
import '../../widgets/text_input.dart';

class SignUpConfirmationScreen extends StatefulWidget {
  const SignUpConfirmationScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  @override
  _SignUpConfirmationScreenState createState() =>
      _SignUpConfirmationScreenState();
}

class _SignUpConfirmationScreenState extends State<SignUpConfirmationScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _confirmationCodeController =
      TextEditingController();

  Future<void> _confirmOnPressed(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final confirmationCode = _confirmationCodeController.text;
      print("Confirmation code: $confirmationCode");
      try {
        final signUpResult = await Amplify.Auth.confirmSignUp(
          username: widget.email,
          confirmationCode: confirmationCode,
        );
        print("SignUpResult: $signUpResult");
        if (signUpResult.isSignUpComplete) {
          debugPrint("successful log in");
          goToMainScreen(context);
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

  void goToMainScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(
                        child: Image(
                          image: AssetImage('assets/images/logo.png'),
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                      ),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'An email confirmation code is sent to ${widget.email} please enter the code to confirm your email.',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextInput(
                                icon: Icons.numbers,
                                hint: 'Confirmation Code',
                                inputType: TextInputType.text,
                                inputAction: TextInputAction.done,
                                controller: _confirmationCodeController,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              RoundedButton(
                                buttonText: 'Confirm',
                                onPressed: () => _confirmOnPressed(context),
                              ),
                              const SizedBox(
                                height: 80,
                              ),
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
