import 'package:get/get.dart';
import 'package:voicewebapp/controller/firebase_helper.dart';

class CartController extends GetxController {
  //TODO: Implement CartController
  FirebaseHelper firebaseHelper = FirebaseHelper();
  RxInt cartTotal = 0.obs;
  RxBool isLoading = false.obs;
  final count = 0.obs;

  Future<void> getCartTotal() async {
    isLoading(true);
    var cart = await firebaseHelper.getCart();
    cartTotal(cart?.amount);
    isLoading(false);
  }
}
