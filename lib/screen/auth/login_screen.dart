import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:javalearn/screen/auth/login_checker.dart';
import 'package:javalearn/screen/auth/register_screen.dart';

final _firebaseAuth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool flag = true;
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  void _login() async {
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        if (!mounted) {
          return;
        }
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginChecker()));
      } on FirebaseAuthException catch (e) {
        if (!mounted) {
          return;
        }
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message!),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var content = Container(
      margin: const EdgeInsets.all(25.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 0),
                child: Text(
                  "Hello there! Welcome \nto Java Learn!",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                )),
            const SizedBox(
              height: 50,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null ||
                        value.trim().length < 1 ||
                        !value.contains('@')) {
                      return "Please input a valid email!";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _email = newValue!;
                  },
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(18),
                    hintText: "Enter your Email",
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 104, 16, 136)),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return "Password must be atleast 6 characters!";
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    _password = newValue!;
                  },
                  style: Theme.of(context).textTheme.bodyMedium,
                  obscureText: flag ? true : false,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(18),
                    hintText: "Enter your password",
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 104, 16, 136)),
                        borderRadius: BorderRadius.circular(12)),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          flag =
                              !flag; // Mengubah status flag ketika tombol mata ditekan
                        });
                      },
                      icon: Icon(
                        flag
                            ? Icons.visibility_off
                            : Icons
                                .visibility, // Menampilkan ikon berdasarkan status flag
                        color: const Color.fromARGB(
                            255, 104, 16, 136), // Atur warna ikon
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "Forget Password?",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Urbanist-SemiBold",
                          ),
                        ))),
                const SizedBox(
                  height: 25,
                ),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : FilledButton(
                        style: ButtonStyle(
                            side: const MaterialStatePropertyAll(
                                BorderSide(color: Colors.grey)),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            fixedSize: const MaterialStatePropertyAll(
                                Size.fromWidth(370)),
                            padding: const MaterialStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 20),
                            ),
                            backgroundColor: const MaterialStatePropertyAll(
                              Color.fromARGB(255, 104, 16, 136),
                            )),
                        onPressed: () {
                          _login();
                        },
                        child: Text(
                          "Login",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                        ),
                      ),
              ],
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: Center(
                    child: Text(
                  "Don't have an account?, Register",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 14),
                )))
          ],
        ),
      ),
    );
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: MediaQuery.of(context).viewInsets.bottom > 0
            ? SingleChildScrollView(
                child: content,
              )
            : content);
  }
}
