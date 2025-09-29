import 'package:flutter/material.dart';
import 'package:video_call_app/features/dashboard/presentation/page/dashboard_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 26, 26, 26),
        primaryColor: Colors.red,
        appBarTheme: AppBarTheme(
          centerTitle: false,
          color: const Color.fromARGB(255, 26, 26, 26),
          actionsPadding: const EdgeInsets.only(right: 10),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 25,
          ),
        ),
      ),
      home: DashboardView(),
    );
  }
}
