import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/nav_task/cancelled_task_screen.dart';
import 'package:task_manager/ui/screens/nav_task/completed_task_screen.dart';
import 'package:task_manager/ui/screens/nav_task/new_task_screen.dart';
import 'package:task_manager/ui/screens/nav_task/progress_task_screen.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screen = const [
    NewTaskScreen(),
    ProgressTaskScreen(),
    CompleteTaskScreen(),
    CancelledTaskScreen(),
  ];

  String? _authToken;
  String? _savedName;
  String? _savedMail;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _savedName = prefs.getString('name');
    _savedMail = prefs.getString('email');
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');

    Logger().i('Auth Token: $_authToken');

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

    } else {
      showSnackBarMessage(context, "Failed to load profile!", 2, isError: true);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(
        name: _savedName ?? 'Loading...',
        email: _savedMail ?? 'Loading...',
      ),
      body: _screen[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.new_label), label: 'New'),
          NavigationDestination(icon: Icon(Icons.track_changes), label: 'Progress'),
          NavigationDestination(icon: Icon(Icons.done), label: 'Completed'),
          NavigationDestination(icon: Icon(Icons.cancel), label: 'Cancelled'),
        ],
      ),
    );
  }
}
