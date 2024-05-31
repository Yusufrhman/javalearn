import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  String _enteredEmail = '';

  void _showChangePasswordSent() async {
    bool isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    print("_enteredEmail");

    print(_enteredEmail);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _enteredEmail);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Success!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'We have sent the password change link to your email',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              style: const ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(Colors.purple),
                padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Ok"),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (error) {
      print(error.message);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  child: Text(
                    "Forgot your password?",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) {
                  if (value == null ||
                      value.trim().length < 1 ||
                      !value.contains('@')) {
                    return "Please input a valid email!";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enteredEmail = newValue!;
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
            ),
            const SizedBox(
              height: 20,
            ),
            FilledButton(
              style: ButtonStyle(
                  side: const WidgetStatePropertyAll(
                      BorderSide(color: Colors.grey)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  fixedSize: const WidgetStatePropertyAll(Size.fromWidth(370)),
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 20),
                  ),
                  backgroundColor: const WidgetStatePropertyAll(
                    Color.fromARGB(255, 104, 16, 136),
                  )),
              onPressed: () {
                _showChangePasswordSent();
              },
              child: Text(
                "Forgot",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
