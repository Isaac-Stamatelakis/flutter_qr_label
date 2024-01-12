
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:qr_label/auth/auth_services.dart';
import 'package:qr_label/auth/authentication.dart';
import 'package:qr_label/firebase_options.dart';
import 'package:qr_label/global/global_helper.dart';
import 'package:qr_label/global/global_widgets.dart';
import 'package:qr_label/global/loader.dart';
import 'package:qr_label/main_scaffold.dart';
import 'package:qr_label/user/db_user.dart';
import 'package:qr_label/user/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  String? uid = await AuthService().signInWithGoogle();
  Logger().i("User registered with uid $uid");
  runApp(MyApp(uid: uid));
}

class MyApp extends StatelessWidget {
  final String? uid;
  MyApp({super.key, this.uid});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR_Label',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      
      home: Scaffold(
        body: Stack(
        children: [
          Container(
            height: double.maxFinite,
            width: double.maxFinite,  
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black,Colors.black54],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              )
            ),
          ),
          LoadFromUID(uid: uid!)
        ],
      ),
      )
      
      /*const MainScaffold(
        content: null,
        title: "Test",
         userID: 
         //'ITfV2d9rxqJNhUE9IO6n'
         '8GpGKNl8TVvjafven2rn'
         , 
         initalPage: MainPage.Scanner,
      )
      */
    );
  }

}


