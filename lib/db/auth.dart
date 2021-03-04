import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_sign_in/google_sign_in.dart';


abstract class BaseAuth{
  Future<FirebaseUser>googleSignIn();
}

class Auth extends BaseAuth{
  FirebaseAuth firebaseAuth= FirebaseAuth.instance;
  @override
  
  Future<FirebaseUser> googleSignIn()async{
    final GoogleSignIn _googleSignIn= GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount= await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleauth= await googleSignInAccount.authentication;

    final AuthCredential credential= GoogleAuthProvider.getCredential(
      idToken: googleauth.idToken, accessToken: googleauth.accessToken);

      try{
        FirebaseUser user= (await firebaseAuth.signInWithCredential(credential)).user;
        return user;
        }catch(e){
          print(e.toString());
          return null;

        }
      } 


 }
