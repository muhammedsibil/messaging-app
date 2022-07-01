import 'package:flutter/material.dart';
import 'package:messenger/chat_screen.dart';
import 'package:messenger/firebase_helper.dart';
import 'package:messenger/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool loading = false;

  Service service = Service();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

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
                'Messenger',
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
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      if (emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        setState(() {
                          loading = true;
                        });

                        service.loginUser(context: context, email: emailController.text,
                           password:  passwordController.text);

                        pref.setString("email", emailController.text);
                      
                      } else {
                        service.errorBox(context,
                            'Fields must not empty please provide valid email and password');
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white),
                    ),),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  },
                  child: Text('I DONT HAVE ANY ACCOUNT')),
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
