import 'package:flutter/material.dart';
import 'package:javalearn/screen/auth/login_screen.dart';
import 'package:javalearn/screen/auth/register_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/images/home1.png",
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/logo-j.png',
                        height: 60,
                      ),
                    ),
                    Text(
                      'JAVA LEARN',
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    FilledButton(
                      style: ButtonStyle(
                          side: const MaterialStatePropertyAll(
                            BorderSide(color: Colors.grey),
                          ),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          fixedSize: MaterialStatePropertyAll(Size.fromWidth(
                              MediaQuery.of(context).size.width)),
                          padding: const MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 20),
                          ),
                          backgroundColor: const MaterialStatePropertyAll(
                            Color.fromARGB(255, 104, 16, 136),
                          )),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: Text(
                        "Login",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FilledButton(
                      style: ButtonStyle(
                          side: const MaterialStatePropertyAll(BorderSide(
                              color: Color.fromARGB(255, 104, 16, 136))),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          fixedSize: MaterialStatePropertyAll(Size.fromWidth(
                              MediaQuery.of(context).size.width)),
                          padding: const MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 20),
                          ),
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.white)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()));
                      },
                      child: Text(
                        "Register",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
