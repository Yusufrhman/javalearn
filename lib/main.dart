import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:javalearn/firebase_options.dart';
import 'package:javalearn/screen/auth/auth_screen.dart';
import 'package:javalearn/screen/auth/login_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF9C8FFF),
          ),
          textTheme: GoogleFonts.urbanistTextTheme(
            Theme.of(context).textTheme.copyWith(
                  displayLarge: const TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 104, 16, 136),
                  ),
                  bodyLarge: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 104, 16, 136),
                  ),
                  bodyMedium: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 104, 16, 136),
                  ),
                ),
          ),
        ),
        home: const LoginChecker());
  }
}
