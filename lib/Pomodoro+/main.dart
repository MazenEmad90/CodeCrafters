import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/focus_provider.dart';
import 'screens/focus_screen.dart';

void main() {
  runApp(const FocusApp());
}

class FocusApp extends StatelessWidget {
  const FocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FocusProvider(),
      child: MaterialApp(
        title: 'Focus Timer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness:              Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0A1F0F),
          fontFamily:              'Roboto',
        ),
        home: const FocusScreen(),
      ),
    );
  }
}

