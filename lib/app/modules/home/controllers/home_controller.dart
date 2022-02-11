import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voicewebapp/app/data/remote/provider/models/cartProduct.dart';
import 'package:voicewebapp/app/data/remote/provider/models/product.dart';
import 'package:voicewebapp/app/routes/app_pages.dart';
import 'package:voicewebapp/components/snack_bar.dart';
import 'package:voicewebapp/controller/firebase_helper.dart';

class HomeController extends GetxController {
  RxInt tabIndex = 1.obs;
  // RxBool addToCartLoading = false.obs;
  Map<Widget, String> appBarItems = {
    // const Icon(Icons.home): 'Home',
    const Icon(Icons.add_shopping_cart_outlined): 'Basket',
    // const Icon(Icons.shopping_bag): 'Shop',
    const Icon(Icons.logout): 'Logout',
  };
/*  Map<Icon, String> navigationRail = {
    const Icon(Icons.home): 'Beverages',
    const Icon(Icons.add_shopping_cart_outlined): 'Snacks and Foods',
    const Icon(Icons.shopping_bag): 'Fruits & Vegetables',
    const Icon(Icons.contact_mail): 'Food Grains',
  };*/
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final SpeechToText speechToText = SpeechToText();
  //GETTER TO RETURN INSTANCE OF SPEECH TO TEXT.
  //SpeechToText get speechToText => _speechToText;
  /*//FUNCTION GETTERS.
  get startListening => _startListening();
  get stopListening => _stopListening();*/
  RxList<Product>? searchedResult = <Product>[].obs;
  RxBool speechEnabled = false.obs;
  RxString lastWords = ''.obs;
  final count = 0.obs;
  FirebaseHelper firebaseHelper = FirebaseHelper();
  CartProduct cartProduct = CartProduct();
  List<Product>? products = [];
  List<Product>? fruits = [];
  RxBool isLoading = false.obs;
  RxBool drawerExpanded = false.obs;
  TextEditingController searchBarCtrl = TextEditingController();
  RxString initialValue = ''.obs;
  RxBool searchByVoice = false.obs;
  List productList = [];
  Map numbers = {'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5};

  @override
  void onInit() {
    super.onInit();
    // _initSpeech(); // FUNCTION TO CALL ONLY ONCE AN APP IS INITIALIZED.
    getProductsData();
    getProductList();
  }

  void getProductList() async {
    productList = await firebaseHelper.getProductList();
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
    // print(products);
    isLoading(false);
  }

  Future<void> getProductsByCategory({required String category}) async {
    // print('###########categrory called');
    isLoading(true);
    products = await firebaseHelper.getProductsByCategory(category);
    // print(products);
    isLoading(false);
  }

  /// Each time to start a speech recognition sess ion
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
    // print('LIST OF WORDS: ${result.alternates}');
    log(lastWords());
  }

  //FUNCTION FOR SIGN OUT && Delete the shared preference data from localS.
  Future<String> signOut() async {
    await _auth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', false);

    /*uid = null;
    userEmail = null;*/

    return 'User signed out';
  }

  @override
  void onClose() {}

  Future<void> evaluateCommand(String string) async {
    print('evaluate command');
    List<String> words = string.toLowerCase().split(' ');
    if (words.contains('navigate')) {
      if (words.contains('vegetables') || words.contains('vegetable')) {
        tabIndex(3);
      } else if (words.contains('fruits') || words.contains('fruit')) {
        tabIndex(4);
      } else if (words.contains('beverages') || words.contains('beverage')) {
        tabIndex(2);
      } else if (words.contains('basket')) {
        Get.toNamed(Routes.CART);
      } else if (words.contains('home')) {
        tabIndex(1);
      }
    } else if ((words.contains('log') && words.contains('out')) ||
        (words.contains('sign') && words.contains('out')) ||
        words.contains('signout') ||
        words.contains('logout')) {
      signOut();
      Get.offAllNamed(Routes.SIGN_IN);
    } else if (words.contains('search') || words.contains('find')) {
      tabIndex(0);
      searchByVoice(true);
      initialValue(words[1]);
      print(initialValue());
      searchedResult!(await firebaseHelper.getProductsBySearch(initialValue));
    } else if (words.contains('basket') && words.contains('add')) {
      String product = '';
      int quantity = 1;
      for (var item in productList) {
        if (words.contains(item)) {
          product = item;
          try {
            String aStr = string.replaceAll(new RegExp(r'[^0-9]'), '');
            quantity = int.parse(aStr);
            print(quantity);
          } catch (e) {
            for (var num in numbers.keys) {
              if (words.contains(num)) {
                quantity = numbers[num];
                print(quantity);
              }
            }
          }
        }
      }
      if (product != '') {
        var productItem = await firebaseHelper.searchProductItem(product);
        await firebaseHelper.addProductToCart(CartProduct(
            productName: productItem?.name,
            quantity: quantity,
            metric: productItem?.metric,
            price: productItem?.price,
            img: productItem?.urlImage));
        appSnackbar(message: '$product added successfully to the cart');
        evaluateCommand('Navigate to basket');
      } else {
        appSnackbar(message: 'No such item exist');
      }
    }
  }
}
