import 'package:flutter/material.dart';
import 'package:messenger/firebase_helper.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {

  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  Service service = Service();

  bool loading = false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Register',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 56,
                    color: Colors.blue),
              ),
              const SizedBox(height: 36),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Enter your Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "Enter your Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                           setState(() {
                          loading = true;
                        });
                      service.createUser(context, emailController.text,
                          passwordController.text);
                    } else {
                      service.errorBox(context,
                          'Fields must not empty please provide valid email and password');
                    }
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text('ALLREADY HAVE ACCOUNT')),

                  if (loading)
                const CircularProgressIndicator(
                  color: Colors.red,
                  strokeWidth: 7,
                )
            ],
          ),
        ),
      ),
    );
  }
}
