import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_tts/flutter_tts_web.dart';
import 'package:get/get.dart';
import 'package:voicewebapp/app/data/remote/provider/models/cart.dart';
import 'package:voicewebapp/app/data/remote/provider/models/cartProduct.dart';
import 'package:voicewebapp/app/data/remote/provider/models/product.dart';
import 'package:voicewebapp/components/snack_bar.dart';
import 'package:voicewebapp/controller/firebase_helper.dart';

class CartController extends GetxController {
  //TODO: Implement CartController
  FirebaseHelper firebaseHelper = FirebaseHelper();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  GlobalKey checkoutKey = GlobalKey<FormState>();
  TextEditingController city = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController flatNo = TextEditingController();
  TextEditingController apartMent = TextEditingController();
  RxInt cartTotal = 0.obs;
  RxBool isLoading = false.obs;
  RxBool evaluatingCommand = false.obs;
  RxBool isOrderPlaced = false.obs;
  RxList<Product>? searchedProduct = <Product>[].obs;
  final count = 0.obs;
  Cart? cartDetails;
  //FLUTTER TEXT TO SPEECH.
  FlutterTts tts = FlutterTts();
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;

  Future<void> getCartTotal() async {
    isLoading(true);
    var cart = await firebaseHelper.getCart();
    cartTotal(cart?.amount);
    isLoading(false);
  }

  Future<void> getCartDetails() async {
    print('CART DETAILS CALLLEDF');
    cartDetails = await firebaseHelper.getCart();
    // print(cartDetails!.products[0].productName);
    // cartDetails = await firebaseHelper.getCart();
    // print('CART CHECKOUT ${cartDetails!.products}');
  }

  Future<bool> modifyCart(CartProduct cartproduct, int modifiedQuantity,
      int previousQuantity) async {
    try {
      //Before adding the product to the cart remember
      // to check the current stock with quantity requested by the user.
      String? productName = cartproduct.productName;
      int? quantity = cartproduct.quantity;
      int current_price = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('cart')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) => value.data()?['amount']);

      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('cart')
          .doc(_auth.currentUser!.uid)
          .update({
        'items': FieldValue.arrayRemove([
          {
            'name': productName,
            'qty': previousQuantity,
            'price': cartproduct.price,
            'metric': cartproduct.metric,
            'img': cartproduct.img
          }
        ]),
      });
      if (modifiedQuantity != 0) {
        await _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('cart')
            .doc(_auth.currentUser!.uid)
            .update({
          'items': FieldValue.arrayUnion([
            {
              'name': productName,
              'qty': modifiedQuantity,
              'price': cartproduct.price,
              'metric': cartproduct.metric,
              'img': cartproduct.img
            }
          ]),
          'amount': current_price -
              (previousQuantity * cartproduct.price!) +
              (modifiedQuantity * cartproduct.price!)
        });
      } else {
        await _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('cart')
            .doc(_auth.currentUser!.uid)
            .update({
          'amount': current_price - (previousQuantity * cartproduct.price!)
        });
      }
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    // TODO: implement update
    getCartTotal();
    super.update(ids, condition);
  }

  Future<void> initializeTTS() async {
    await tts.awaitSpeakCompletion(true);
    await tts.setLanguage("en-US");
    await tts.setSpeechRate(0.5);
    await tts.setVolume(1.0);
  }

  void evaluateCommand(String command) async {
    evaluatingCommand(true);
    if (evaluatingCommand()) {
      tts.speak('Evaluating Command');
    }
    List words = command.split('');
    if (words.contains('empty') || words.contains('clear')) {
      if (words.contains('cart') || words.contains('basket')) {
        isLoading(true);
        await firebaseHelper.clearCart();
        isLoading(false);
        appSnackbar(
          message: 'Cart is cleared',
          snackbarState: SnackbarState.success,
        );
        tts.speak('Cart is cleared successfully,navigating to home screen');
        evaluatingCommand(false);
        update();
      }
    } else if (words.contains('check') && words.contains('out')) {
    } else if (words.contains('remove')) {
      await getCartDetails();
      tts.speak('Removing item, please wait');
      for (var item in cartDetails!.products) {
        print('THIS IS UNDER REMOVE :$item');
        if (words.contains(item.productName)) {
          await modifyCart(item, 0, item.quantity!);
          update();
        }
      }
    } else {
      tts.speak('Command not recognised, please try again');
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initializeTTS();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tts.stop();
  }
}
