import 'package:flutter/material.dart';
import 'package:couldai_user_app/ui/home_screen.dart';

void main() {
  runApp(const IOSimulationApp());
}

class IOSimulationApp extends StatelessWidget {
  const IOSimulationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'I/O System Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}
