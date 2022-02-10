import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voicewebapp/app/data/remote/provider/models/cart.dart';
import 'package:voicewebapp/app/data/remote/provider/models/cartProduct.dart';
import 'package:voicewebapp/app/data/remote/provider/models/product.dart';
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
  RxBool isOrderPlaced = false.obs;
  RxList<Product>? searchedProduct = <Product>[].obs;
  final count = 0.obs;
  Cart? checkoutCart;

  Future<void> getCartTotal() async {
    isLoading(true);
    var cart = await firebaseHelper.getCart();
    cartTotal(cart?.amount);
    isLoading(false);
  }

  Future<void> getCartOnCheckout() async {
    checkoutCart = await firebaseHelper.getCart();
    print('CART CHECKOUT $checkoutCart');
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
}
