import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/login_register/login_screen.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen(
      {super.key, required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordEController = TextEditingController();
  final TextEditingController _confirmPasswordEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isObscure = true;
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
                    'Set Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Set a new password with at least 8 characters',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _passwordEController,
                    obscureText: _isObscure,
                    // Control password visibility
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure; // Toggle visibility
                          });
                        },
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (String? value) {
                      if ((value?.isEmpty ?? true) || (value!.length < 6)) {
                        return 'Enter your password more than 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordEController,
                    obscureText: _isObscure,
                    // Apply the same toggle
                    decoration: InputDecoration(
                      hintText: 'Confirm New Password',
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure; // Toggle visibility
                          });
                        },
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    validator: (String? value) {
                      if ((value?.isEmpty ?? true) || (value!.length < 6)) {
                        return 'Enter your password more than 6 characters';
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
                          'Confirm',
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

  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (pre) => false);
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      String email = widget.email;
      String otp = widget.otp;
      String password = _passwordEController.text.trim();
      String confirmPassword = _confirmPasswordEController.text.trim();

      if (password == confirmPassword) {
        _updateNewPassword(email, otp, password);
      } else {
        showSnackBarMessage(context, 'Password not match', 1, isError: true);
      }
    }
  }

  void _updateNewPassword(String email, String otp, String password) async {
    setState(() => _inProgress = true);

    Map<String, dynamic> requestBody = {
      "email": email,
      "OTP": otp,
      "password": password
    };

    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.recoverResetPasswordUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      _passwordEController.clear();
      _confirmPasswordEController.clear();

      showSnackBarMessage(context, 'Password Reset Success!', 2);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (pre) => false);

    } else {
      showSnackBarMessage(context, response.errorMessage.toString(), 2,
          isError: true);
    }

    setState(() => _inProgress = true);

  }

  @override
  void dispose() {
    _passwordEController.dispose();
    _confirmPasswordEController.dispose();
    super.dispose();
  }
}
