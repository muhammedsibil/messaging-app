import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messenger/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences pref = await SharedPreferences.getInstance();
  var email = pref.get("email");
  // print("${email} : email id");
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: email == null ? const LoginPage() : const ChatScreen()));
  // home: LoginPage()));
}
