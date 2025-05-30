import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: TaskManagerApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorSchemeSeed: Colors.green,

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 1,),
          border: _getZeroBorder(),
          enabledBorder: _getZeroBorder(),
          focusedBorder: _getZeroBorder(),
          errorBorder: _getZeroBorder(),
          focusedErrorBorder: _getZeroBorder(),
          disabledBorder: _getZeroBorder(),
          errorStyle: TextStyle(
            color: Colors.red,
          ),

        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              fixedSize: Size.fromWidth(double.maxFinite),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              )
          ),
        ),

        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.w600,
          ),

          bodyLarge: TextStyle(
            fontWeight: FontWeight.w300,
          ),
        ),

      ),
      home: const SplashScreen(),
    );
  }

  OutlineInputBorder _getZeroBorder(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    );
  }

}
