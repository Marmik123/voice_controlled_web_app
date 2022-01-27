import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicewebapp/components/snack_bar.dart';
import 'package:voicewebapp/utils/size_config.dart';

class SignInController extends GetxController {
  //TODO: Implement SignInController

  final count = 0.obs;
  RxBool hidePassword = false.obs;
  RxBool newRegisteration = false.obs;
  RxBool isLoading = false.obs;
  var formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool? authSignedIn;
  String? uid;
  String? userEmail;

//FUNCTION FOR REGISTERING THE USER
  Future<String?> registerWithEmailPassword(
      String email, String password) async {
    // Initialize Firebase
    //await Firebase.initializeApp();

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
        newRegisteration(false);
        return 'Successfully registered, User UID: ${user.uid}';
      } else {
        return 'Error in register';
      }
    } on FirebaseAuthException catch (e) {
      // TODO
      print('${e.code}');
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
        // return 'Successfully logged in, User UID: ${user.uid}';
      }
    } on FirebaseAuthException catch (e) {
      isLoading(false);
      print(e.code.toString());
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

//FUNCTION FOR SIGN OUT && Delete the shared preference data from localS.
  Future<String> signOut() async {
    await _auth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', false);

    uid = null;
    userEmail = null;

    return 'User signed out';
  }

  @override
  void onInit() {
    SizeConfig.init();
    super.onInit();
  }

  @override
  void onClose() {}
}
