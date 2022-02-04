import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voicewebapp/app/data/remote/provider/models/product.dart';
import 'package:voicewebapp/controller/firebase_helper.dart';

class HomeController extends GetxController {
  RxInt tabIndex = 0.obs;
  Map<Icon, String> appBarItems = {
    const Icon(Icons.home): 'Home',
    const Icon(Icons.add_shopping_cart_outlined): 'Cart',
    const Icon(Icons.shopping_bag): 'Shop',
    const Icon(Icons.contact_mail): 'Contact',
  };
  Map<Icon, String> navigationRail = {
    const Icon(Icons.home): 'Beverages',
    const Icon(Icons.add_shopping_cart_outlined): 'Snacks and Foods',
    const Icon(Icons.shopping_bag): 'Fruits & Vegetables',
    const Icon(Icons.contact_mail): 'Food Grains',
  };

  final SpeechToText speechToText = SpeechToText();
  //GETTER TO RETURN INSTANCE OF SPEECH TO TEXT.
  //SpeechToText get speechToText => _speechToText;
  /*//FUNCTION GETTERS.
  get startListening => _startListening();
  get stopListening => _stopListening();*/

  RxBool speechEnabled = false.obs;
  // RxBool addToCartButton = false.obs;
  RxString lastWords = ''.obs;
  // RxInt productQuantity = 1.obs;
  final count = 0.obs;
  FirebaseHelper firebaseHelper = FirebaseHelper();
  List<Product>? products = [];
  RxBool isLoading = false.obs;
  RxBool drawerExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initSpeech(); // FUNCTION TO CALL ONLY ONCE AN APP IS INITIALIZED.
    getProductsData();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    speechEnabled(await speechToText.initialize());
    print('SPEECH ENABLED BOOL : $speechEnabled');
    //setState(() {});
    // getProducts();
    update();
  }

  Future<void> getProductsData() async {
    isLoading(true);
    products = await firebaseHelper.getProducts();
    print(products);
    isLoading(false);
  }

  /// Each time to start a speech recognition session
  void startListening() async {
    await speechToText.listen(
      onResult: onSpeechResult,
      pauseFor: const Duration(seconds: 5),
      listenFor: const Duration(seconds: 20),
      //cancelOnError: ,
    );
    update();
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void stopListening() async {
    await speechToText.stop();
    // setState(() {});
    update();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    lastWords(result.recognizedWords);
    update();
    print('LIST OF WORDS: ${result.alternates}');
    log(lastWords());
  }

  @override
  void onClose() {}
}
