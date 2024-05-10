import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:javalearn/screen/auth/login_screen.dart';

final _firebaseAuth = FirebaseAuth.instance;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool flag = true;
  bool flagConfirm = true;

  String _email = '';
  String _name = '';

  String _password = '';
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  void _register() async {
    setState(() {
      _isLoading = true;
    });
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();
    }
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      await FirebaseAuth.instance.currentUser!.updateDisplayName(_name);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(
        {
          'email': _email,
          'name': _name,
          'articles': [],
          'history': [],
          'liked' : [],
          'is_admin': false
        },
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
      return;
    }
    await FirebaseAuth.instance.signOut();
    if (!mounted) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
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
                  "Hello there! Register \nto Get Started!",
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
                    if (value == null || value.trim().isEmpty) {
                      return "Please input a valid name!";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _name = newValue!;
                  },
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(18),
                    hintText: "Enter your Name",
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
                    _password = value;
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
                TextFormField(
                  validator: (value) {
                    if (value != _password) {
                      return "Password does not match!";
                    }
                    return null;
                  },
                  style: Theme.of(context).textTheme.bodyMedium,
                  obscureText: flagConfirm ? true : false,
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
                          flagConfirm = !flagConfirm;
                        });
                      },
                      icon: Icon(
                        flagConfirm ? Icons.visibility_off : Icons.visibility,
                        color: const Color.fromARGB(255, 104, 16, 136),
                      ),
                    ),
                  ),
                ),
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
                          _register();
                        },
                        child: Text(
                          "Register",
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
                  "Already have an account?, Login",
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
