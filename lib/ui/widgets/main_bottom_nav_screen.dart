import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
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

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }


  Future<void> _loadUserProfile() async {

    final bool isLoggedIn = await AuthController.checkIfUserLoggedIn();

    if (!isLoggedIn) {
      showSnackBarMessage(context, "User not authenticated!", 2, isError: true);
      return;
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
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
