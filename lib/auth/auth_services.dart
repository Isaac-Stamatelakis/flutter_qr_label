import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<String?> signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn(scopes: ['email','openid']).signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = userCredential.user;
    return user!.uid;
  }

  Future<void> signOut() async {
    await GoogleSignIn(scopes: ['email','openid']).signOut();
  }


}