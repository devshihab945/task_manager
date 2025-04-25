import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/forgot_password/reset_password_screen.dart';
import 'package:task_manager/ui/screens/login_register/login_screen.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class VerifyPinScreen extends StatefulWidget {
  const VerifyPinScreen({super.key, required this.email});

  final String email;

  @override
  State<VerifyPinScreen> createState() => _VerifyPinScreenState();
}

class _VerifyPinScreenState extends State<VerifyPinScreen> {
  final TextEditingController _pinEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
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
                    'Pin Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'A 6 digit verification code has been sent to your email address.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  PinCodeTextField(
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 45,
                      activeFillColor: Colors.white,
                      activeColor: Colors.blue,
                      // Change active border color
                      selectedColor: Colors.green,
                      // Change selected border color
                      inactiveColor: Colors.grey,
                      // Change inactive border color
                      selectedFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      borderWidth: 1, // Set border thickness
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    controller: _pinEController,
                    appContext: context,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'PIN is required';
                      } else if (value.length < 6) {
                        return 'Enter all 6 digits';
                      } else if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                        return 'Invalid PIN';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Visibility(
                    visible: _inProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                        onPressed: _onTapSubmitButton,
                        child: Text(
                          'Verify OTP',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
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

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      String otp = _pinEController.text.trim();
      String email = widget.email;
      _verifyOtp(email, otp);
    }
  }

  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (pre) => false);
  }

  Future<void> _verifyOtp(String email, String otp) async {
    setState(() => _inProgress = true);

    final NetworkResponse response = await NetworkClient.getRequest(
        url: Urls.recoverVerifyOtpUrl(email, otp));

    if (response.isSuccess) {
      _pinEController.clear();

      showSnackBarMessage(context, 'OTP verification successful!', 1);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(
                    email: email,
                    otp: otp,
                  )),
          (pre) => false);
    } else {
      showSnackBarMessage(context, 'OTP verification failed!', 1,
          isError: true);
    }

    setState(() => _inProgress = false);
  }

  @override
  void dispose() {
    _pinEController.dispose();
    super.dispose();
  }
}
