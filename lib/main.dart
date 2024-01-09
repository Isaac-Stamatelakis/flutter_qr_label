
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  /*
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Example: Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("User signed in successfully!");
    } catch (e) {
      print("Error signing in: $e");
    }
  }
  */
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR_Label',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      
      home: const MainScaffold(
        content: null,
        title: "Test",
         userID: '8GpGKNl8TVvjafven2rn', 
         initalPage: MainPage.Scanner,
      )
    );
  }
}

class test extends WidgetLoader {
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    User user= snapshot.data;
    print(user.firstName);
    return Container();
  }

  @override
  Future getFuture() async {
    return UserRetriever(id: "8GpGKNl8TVvjafven2rn").fromDatabase();
  }
  
}
