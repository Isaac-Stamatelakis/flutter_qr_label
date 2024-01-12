import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qr_label/auth/auth_services.dart';
import 'package:qr_label/global/global_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  
  
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SquareGradientButton(
              onPress: (BuildContext) {
                AuthService().signInWithGoogle();
              }, 
              text: "Sign in", 
              colors: [Colors.green, Colors.green.shade100], 
              height: 100
            )
          ],
        )
      ],
    );
  }

}