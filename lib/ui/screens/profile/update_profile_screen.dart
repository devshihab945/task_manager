import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
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
  final TextEditingController _fullNameEController = TextEditingController();
  final TextEditingController _mobileEController = TextEditingController();
  final TextEditingController _passwordEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  File? _selectedImage;
  String? _selectedImageName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(
        fromProfileScreen: true,
      ),
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
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _fullNameEController,
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
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
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _passwordEController,
                    obscureText: _isObscure, // Control password visibility
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
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                      onPressed: _onUpdateProfile,
                      child: Text(
                        'Update Profile',
                        style: TextStyle(color: Colors.white),
                      )),
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

  void _onUpdateProfile() {}

  @override
  void dispose() {
    _emailEController.dispose();
    _fullNameEController.dispose();
    _mobileEController.dispose();
    _passwordEController.dispose();
    super.dispose();
  }
}
