import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/forgot_password/verify_pin_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {

  TextEditingController _emailEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            key: _formKey,
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Text(
                    'Your Email Address',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),

                  Text(
                    'A 6 digit verification code has been sent to your email address.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _emailEController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                      onPressed: _onTapSubmitButton,
                      child: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.white,
                        size: 24,
                      )),
                  SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [

                        RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                              children: [
                                TextSpan(text: 'Have an account? '),
                                TextSpan(
                                  text: 'Sign In',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _onTapSignInButton,
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  void _onTapSubmitButton() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => VerifyPinScreen()));
  }

  @override
  void dispose() {
    _emailEController.dispose();
    super.dispose();
  }

}
