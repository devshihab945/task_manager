import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailEController = TextEditingController();
  final TextEditingController _firstNameEController = TextEditingController();
  final TextEditingController _lastNameEController = TextEditingController();
  final TextEditingController _mobileEController = TextEditingController();
  final TextEditingController _passwordEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  File? _selectedImage;
  String? _selectedImageName;

  bool _updateProfileInProgress = false;

  String? _authToken;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadUserInfo();
  }

  String? _savedName;
  String? _savedMail;

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _savedName = prefs.getString('name');
    _savedMail = prefs.getString('email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(
        fromProfileScreen: true,
        name: _savedName ?? 'Loading...',
        email: _savedMail ?? 'Loading...',
      ),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Text(
                    'Update Profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _selectPhotoPickerWidget(),
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
                    validator: (String? value) {
                      String email = value?.trim() ?? '';
                      if (EmailValidator.validate(email) == false) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _firstNameEController,
                    decoration: InputDecoration(
                      hintText: 'First Name',
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _lastNameEController,
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _mobileEController,
                    decoration: InputDecoration(
                      hintText: 'Mobile',
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    validator: (String? value) {
                      String mobile = value?.trim() ?? '';
                      RegExp regex = RegExp(r'^(?:\+88|88)?(01[3-9]\d{8})$');

                      if (mobile.isEmpty) {
                        return 'Mobile number is required';
                      } else if (!regex.hasMatch(mobile)) {
                        return 'Enter a valid Bangladeshi mobile number';
                      }
                      return null;
                    },
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
                  const SizedBox(
                    height: 16,
                  ),
                  Visibility(
                    visible: _updateProfileInProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                        onPressed: _onTapUpdateProfile,
                        child: Text(
                          'Update Profile',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectPhotoPickerWidget() {
    return GestureDetector(
      onTap: _onTapPhotoPicker,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                color: Colors.grey,
              ),
              alignment: Alignment.center,
              child: Text(
                'Photo',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            _selectedImage == null
                ? Text('Select Your Photo')
                : Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(
                          _selectedImage!,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(_selectedImageName.toString())),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  void _onTapPhotoPicker() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _selectedImageName = pickedFile.name;
      });
    } else {}
  }

  void _onTapUpdateProfile() {
    if (_formKey.currentState!.validate()) {
      _updateUserProfile();
    }
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');

    Logger().i('1st check : $_authToken');

    if (_authToken == null) {
      showSnackBarMessage(context, "User not authenticated!", 2, isError: true);
      return;
    }

    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.profileDetailsUrl,
      headers: {"token": "$_authToken"},
    );

    if (response.isSuccess) {
      var userData = response.data?['data'][0]; // Extract user details
      setState(() {
        _emailEController.text = userData['email'];
        _firstNameEController.text = userData['firstName'];
        _lastNameEController.text = userData['lastName'];
        _mobileEController.text = userData['mobile'];
        _passwordEController.text = userData['password'];
      });
    } else {
      showSnackBarMessage(context, "Failed to load profile!", 2, isError: true);
    }

  }


  Future<void> _updateUserProfile() async {
    if (_authToken == null) return;

    setState(() {
      _updateProfileInProgress = true;
    });

    Map<String, dynamic> requestBody = {
      "email": _emailEController.text.trim(),
      "firstName": _firstNameEController.text.trim(),
      "lastName": _lastNameEController.text.trim(),
      "mobile": _mobileEController.text.trim(),
      "password": _passwordEController.text,
    };

    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.profileUpdateUrl,
      body: requestBody,
      headers: {"token": "$_authToken"},
    );

    if (response.isSuccess) {
      showSnackBarMessage(context, "Profile Updated Successfully!", 2, isError: false);
      _loadUserProfile(); // Reload updated profile
      _saveUserInfo(response); // Reload updated profile
    } else {
      showSnackBarMessage(context, response.errorMessage.toString(), 2, isError: true);
    }

    setState(() {
      _updateProfileInProgress = false;
    });
  }

  _saveUserInfo(NetworkResponse response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userData = response.data?['data'][0]; // Extract user details
    String email = userData['email'];
    String firstName = userData['firstName'];
    String lastName = userData['lastName'];

    String name = '$firstName $lastName';

    // Save user details in SharedPreferences
    await prefs.setString('name', name);
    await prefs.setString('email', email);

    // Update state to reflect changes in UI
    setState(() {
      _savedName = name;
      _savedMail = email;
    });
  }

  @override
  void dispose() {
    _emailEController.dispose();
    _firstNameEController.dispose();
    _lastNameEController.dispose();
    _mobileEController.dispose();
    _passwordEController.dispose();
    super.dispose();
  }
}
