import 'dart:developer';
import 'dart:io';
import 'package:chat_firstdemo_app/app/data/const/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_function.dart';


class FirebaseGoogleAuth{

  // Google Sign In
  Future<UserCredential?> signInWithGoogle() async {

    try{
      await InternetAddress.lookup('google.com');
    //Trigger the authentication flow
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    //Once signIn in return the UserCredential
    return await FirebaseFunction.auth.signInWithCredential(credential);

    }catch (e){
      log('\nSignInWithGoogle: $e');
      CustomSnackBar.showSnackBar(msg: 'Something went wrong');
      return null;
    }

  }

   Future signOut() async {
      try {
        await FirebaseFunction.auth.signOut();
        await GoogleSignIn().signOut();
      }catch (e){
        log(e.toString());
      }
  }
}