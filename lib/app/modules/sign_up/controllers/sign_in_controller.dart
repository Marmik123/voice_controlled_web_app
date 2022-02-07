import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicewebapp/app/data/remote/provider/models/user.dart';
import 'package:voicewebapp/app/routes/app_pages.dart';
import 'package:voicewebapp/components/snack_bar.dart';

class SignInController extends GetxController {
  final count = 0.obs;
  RxBool hidePassword = false.obs;
  RxBool newRegisteration = false.obs;
  RxBool isLoading = false.obs;
  var formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool? authSignedIn;
  String? uid;
  String? userEmail;

  Future<bool> signUpUser(LoggedInUser newUser) async {
    try {
      await _firestore.collection('Users').doc(_auth.currentUser!.uid).set({
        'first_name': newUser.firstName,
        'last_name': newUser.lastName,
        'email': newUser.email,
      });
    } catch (e) {
      return false;
    }
    return true;
  }

//FUNCTION FOR REGISTERING THE USER
  Future<String?> registerWithEmailPassword(
      String email, String password) async {
    // Initialize Firebase
    //await Firebase.initializeApp();

    isLoading(true);
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;

      if (user != null) {
        // checking if uid or email is null
        assert(user.uid != null);
        assert(user.email != null);

        uid = user.uid;
        userEmail = user.email;

        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);
        appSnackbar(
          message: 'Successfully registered,User UID: ${user.uid}',
          snackbarState: SnackbarState.success,
        );
        isLoading(false);
        await signUpUser(
            LoggedInUser(firstName.text.trim(), lastName.text.trim(), email));
        Get.toNamed(Routes.LOGIN_SCREEN);
        dispose(); //Clearing all registeration text form fields.
        return 'Successfully registered, User UID: ${user.uid}';
      } else {
        return 'Error in register';
      }
    } on FirebaseAuthException catch (e) {
      print('${e.code}');
      isLoading(false);

      if (e.code == 'email-already-in-use') {
        appSnackbar(
          message: 'User with this email ID already exist.',
          snackbarState: SnackbarState.warning,
        );
      } else {
        appSnackbar(
          message: 'Error Occured,$e',
          snackbarState: SnackbarState.warning,
        );
      }
    }
  }

  void dispose() {
    firstName.clear();
    lastName.clear();
    password.clear();
    email.clear();
  }

/*
//FUNCTION FOR USER SIGN - IN && ADDED SHARED PREFERENCES
  Future<User?> signInWithEmailPassword(String email, String password) async {
    // Initialize Firebase
    // await Firebase.initializeApp();
    User? user;
    try {
      isLoading(true);
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;

      if (user != null) {
        // checking if uid or email is null
        assert(user.uid != null);
        assert(user.email != null);

        uid = user.uid;
        userEmail = user.email;

        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User? currentUser = _auth.currentUser;
        assert(user.uid == currentUser?.uid);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('auth', true);
        isLoading(false);
        appSnackbar(
          message: 'Successfully logged in, User UID: ${user.uid}',
          snackbarState: SnackbarState.success,
        );
        Get.to(() => HomeView());
        // return 'Successfully logged in, User UID: ${user.uid}';
      }
    } on FirebaseAuthException catch (e) {
      isLoading(false);
      log(e.code);
      if (e.code == 'user-not-found') {
        appSnackbar(
          message: 'User Not Found,Please register first',
          snackbarState: SnackbarState.warning,
        );
      } else {
        appSnackbar(
          message: 'Error Occured, $e',
          snackbarState: SnackbarState.warning,
        );
      }
    } catch (e) {
      isLoading(false);
      appSnackbar(
        message: '$e',
        snackbarState: SnackbarState.info,
      );
    }
  }
*/

  //FUNCTION FOR SIGN OUT && Delete the shared preference data from localS.
  Future<String> signOut() async {
    await _auth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', false);

    uid = null;
    userEmail = null;

    return 'User signed out';
  }
}
