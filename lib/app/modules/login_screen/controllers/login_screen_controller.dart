import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicewebapp/app/data/remote/provider/models/user.dart';
import 'package:voicewebapp/app/routes/app_pages.dart';
import 'package:voicewebapp/components/snack_bar.dart';

class LoginScreenController extends GetxController {
  var formKey = GlobalKey<FormState>();
  RxBool hidePassword = false.obs;
  RxBool isLoading = false.obs;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // var signUpCtrl = Get.put(SignInController());

  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> signUpUser(LoggedInUser newUser) async {
    try {
      await _firestore.collection('Users').doc(_auth.currentUser!.uid).set({
        'first_name': newUser.firstName,
        'last_name': newUser.lastName,
        'email': newUser.email
      });
    } catch (e) {
      return false;
    }
    return true;
  }

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

        /* uid = user.uid;
        userEmail = user.email;
        */

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
        /* signUpUser(
          LoggedInUser(signUpCtrl.firstName.text.trim(),
              signUpCtrl.lastName.text.trim(), email),
        );*/
        Get.offAllNamed(Routes.HOME);

        // return 'Successfully logged in, User UID: ${user.uid}';
      }
    } on FirebaseAuthException catch (e) {
      isLoading(false);
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
}
