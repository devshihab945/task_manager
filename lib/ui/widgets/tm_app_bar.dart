import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/login_register/login_screen.dart';
import 'package:task_manager/ui/screens/profile/update_profile_screen.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key,
    this.fromProfileScreen,
  });

  final bool? fromProfileScreen;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: GestureDetector(
        onTap: () {
          if (fromProfileScreen ?? false) {
            return;
          }
          _onTapProfile(context);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: _shouldShowImage(AuthController.userModel?.photo)
                  ? MemoryImage(
                      base64Decode(AuthController.userModel?.photo ?? ''),
                    )
                  : null,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userModel?.fullName ?? '',
                    // Use dynamic name
                    style: textTheme.bodyLarge?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AuthController.userModel?.email ?? 'Unknown',
                    // Use dynamic email
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  _onTapLogout(context);
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.red,
                )),
          ],
        ),
      ),
    );
  }

  bool _shouldShowImage(String? photo) {
    return photo != null && photo.isNotEmpty;
  }

  void _onTapProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UpdateProfileScreen(),
      ),
    );
  }

  void _onTapLogout(BuildContext context) async {
    await AuthController.clearUserInformation();

    showSnackBarMessage(context, "Logged out successfully", 2, isError: false);

    // Navigate to the LoginScreen
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (predicate) => false);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
