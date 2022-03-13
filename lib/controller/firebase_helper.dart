import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:voicewebapp/app/data/remote/provider/models/cart.dart';
import 'package:voicewebapp/app/data/remote/provider/models/cartProduct.dart';
import 'package:voicewebapp/app/data/remote/provider/models/order.dart';
import 'package:voicewebapp/app/data/remote/provider/models/product.dart';
import 'package:voicewebapp/app/data/remote/provider/models/user.dart';
import 'package:voicewebapp/components/snack_bar.dart';
import 'package:voicewebapp/seed/seed.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class FirebaseHelper {
  //TODO: DONE
  // CartController cartCtrl = Get.put(CartController());
  Future<bool> signUpUser(LoggedInUser newUser) async {
    try {
      await _firestore.collection('Users').doc(_auth.currentUser!.uid).set({
        'first_name': newUser.firstName,
        'last_name': newUser.lastName,
        'email': newUser.email
      });
      /*   await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('cart')
          .doc(_auth.currentUser!.uid)
          .set(<String, dynamic>{
        'amount': 0,
      });
   */
    } catch (e) {
      return false;
    }
    return true;
  }

  //TODO: DONE
  Future<bool> addProduct(Product product) async {
    try {
      await _firestore.collection('Products').doc(product.name).set({
        'name': product.name,
        'category': product.category,
        'price': product.price,
        'metric': product.metric,
        'current_stock': product.currentStock,
        'image_url': product.urlImage
      });
    } catch (e) {
      return false;
    }
    return true;
  }

  //TODO: LEFT
  Future<bool> modifyProduct(String productId, int qty) async {
    try {
      int currentStock = await _firestore
          .collection('Products')
          .doc(productId)
          .get()
          .then((value) => value.data()?['current_stock']);
      await _firestore.collection('Products').doc(productId).update({
        'current_stock': currentStock - qty,
      });
    } catch (e) {
      return false;
    }
    return true;
  }

  //TODO: DONE
  //To Display products on the home screen.
  Future<List<Product>?> getProducts() async {
    List<Product> products = [];
    Map docData;
    Product product;
    try {
      await _firestore.collection('Products').get().then((querySnapShot) {
        for (var temp in querySnapShot.docs) {
          docData = temp.data();
          print(docData);
          product = Product(
            name: docData['name'],
            category: docData['category'],
            currentStock: docData['current_stock'],
            urlImage: docData['image_url'],
            price: docData['price'],
            metric: docData['metric'],
          );
          products.add(product);
          print('inside firebase helper $products');
        }
      });
    } catch (e) {
      return null;
    }
    return products;
  }

  //For add to cart.
  Future<dynamic> addProductToCart(CartProduct cartproduct) async {
    try {
      //Before adding the product to the cart remember
      // to check the current stock with quantity requested by the user
      String? product = cartproduct.productName;
      int? quantity = cartproduct.quantity;
      bool isCartEmpty = false;
      bool already_found = false;
      int existingQty = 0;

      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('cart')
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          isCartEmpty = true;
        } else {
          // value.docs.items.forEach((item){
          //   if(item.name==product){
          //     modifyCart(cartProduct,int.parse(item.qty)+1,int.parse(item.qty)));
          //   }
          // });
          var listOfDocs = value.docs;
          for (var doc in listOfDocs) {
            var data = doc.data();
            var listOfCartProducts = data['items'];
            for (var item in listOfCartProducts) {
              if (item['name'].toString() == product) {
                // print(item['name'].toString());
                // print(item['qty']);
                modifyCart(cartproduct, item['qty'] + cartproduct.quantity,
                    item['qty']);
                already_found = true;
                existingQty = item['qty'] + cartproduct.quantity;
              }
            }
          }
          // for(var item in listOfProducts){
          //    if(item.name==product){
          //     modifyCart(cartproduct,int.parse(item.qty)+1,int.parse(item.qty));
          //   }
          // }
        }
      });
      if (already_found) {
        return [existingQty, true];
      }
      if (isCartEmpty) {
        await _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('cart')
            .doc(_auth.currentUser!.uid)
            .set(<String, dynamic>{
          'items': FieldValue.arrayUnion([
            {
              'name': product,
              'qty': quantity,
              'price': cartproduct.price,
              'metric': cartproduct.metric,
              'img': cartproduct.img
            }
          ]),
          'amount': (cartproduct.price! * quantity!),
        });
      } else {
        //THIS IS USED ONLY WHEN THERE IS PRODUCT INSIDE THE CART.
        int currentPrice = await _firestore
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
          'items': FieldValue.arrayUnion([
            {
              'name': product,
              'qty': quantity,
              'price': cartproduct.price,
              'metric': cartproduct.metric,
              'img': cartproduct.img
              // 'img':cartproduct.,
            }
          ]),
          'amount': currentPrice + ((quantity ?? 0) * cartproduct.price!)
        });
      }
    } catch (e) {
      print(e);
      return false;
    }
    return [1, true];
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

  Future<bool> clearCart() async {
    var response = await _firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .collection('cart')
        .doc(_auth.currentUser!.uid)
        .set(<String, dynamic>{
      'items': [],
      'amount': 0,
    });
    return true;
  }
  //
  // Future<bool> modifyCart(CartProduct cartproduct, int modifiedQuantity,int previousQuantity) async {
  //   try {
  //     //Before adding the product to the cart remember
  //     // to check the current stock with quantity requested by the user.
  //     String? productName = cartproduct.productName;
  //     int? quantity = cartproduct.quantity;
  //     //FETCHED CART CURRENT PRICE.
  //     int currentPrice = await _firestore
  //         .collection('Users')
  //         .doc(_auth.currentUser!.uid)
  //         .collection('cart')
  //         .doc(_auth.currentUser!.uid)
  //         .get()
  //         .then((value) => value.data()?['amount']);

  //     await _firestore
  //         .collection('Users')
  //         .doc(_auth.currentUser!.uid)
  //         .collection('cart')
  //         .doc(_auth.currentUser!.uid)
  //         .update({
  //       'items': FieldValue.arrayRemove([
  //         {
  //           'name': productName,
  //           'qty': previousQuantity,
  //           'price': cartproduct.price,
  //           'metric': cartproduct.metric
  //         }
  //       ]),
  //     });

  //     if (modifiedQuantity != 0) {
  //       await _firestore
  //           .collection('Users')
  //           .doc(_auth.currentUser!.uid)
  //           .collection('cart')
  //           .doc(_auth.currentUser!.uid)
  //           .update({
  //         'items': FieldValue.arrayUnion([
  //           {
  //             'name': productName,
  //             'qty': modifiedQuantity,
  //             'price': cartproduct.price,
  //             'metric': cartproduct.metric,
  //           },
  //         ]),
  //         'amount': currentPrice -
  //             (quantity ?? 0 * cartproduct.price!) +
  //             (modifiedQuantity * cartproduct.price!)
  //       });
  //     } else {
  //       await _firestore
  //           .collection('Users')
  //           .doc(_auth.currentUser!.uid)
  //           .collection('cart')
  //           .doc(_auth.currentUser!.uid)
  //           .update({
  //         'amount': currentPrice - (quantity ?? 0 * cartproduct.price!)
  //       });
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  //   return true;
  // }

  Future<Cart?> getCart() async {
    List<CartProduct> listOfCartProducts = [];
    List products = [];
    int? amount;
    CartProduct cartProduct;
    try {
      await _firestore
          .collection('Users')
          .doc(_auth.currentUser?.uid ?? '-')
          .collection('cart')
          .doc(_auth.currentUser?.uid ?? '-')
          .get()
          .then((value) {
        products = List.from(value.data()?['items']);
        amount = value.data()?['amount'] ?? 999;
        for (var temp in products) {
          cartProduct = CartProduct(
            productName: temp['name'],
            quantity: temp['qty'],
            price: temp['price'],
            metric: temp['metric'],
            img: temp['img'],
          );
          listOfCartProducts.add(cartProduct);
        }
      });
      // await cartCtrl.getCartTotal();
    } catch (e) {
      return null;
    }
    return Cart(listOfCartProducts, amount!);
  }

  //FOR REMOVING THROUGH VOICE COMMAND.
  Future<void> removeParticularItem(CartProduct itemToBeRemoved) async {
    print(itemToBeRemoved.productName);
    await _firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .collection('cart')
        .doc(_auth.currentUser!.uid)
        .update({
      'items': FieldValue.arrayRemove([
        {
          'name': itemToBeRemoved.productName,
          'qty': 0,
          /*'price': cartproduct.price,
          'metric': cartproduct.metric,
          'img': cartproduct.img*/
        }
      ]),
    });
  }

  Future<bool> checkOut(
    Cart cart,
  ) async {
    List<CartProduct> products = cart.products;
    int amount = cart.amount;
    List<dynamic> temp = [];
    print(cart.amount);
    // print(address.pincode);
    print('inside checkout');
    for (var cartProduct in products) {
      temp.add({
        'name': cartProduct.productName,
        'qty': cartProduct.quantity,
        'price': cartProduct.price,
        'metrics': cartProduct.metric,
        'img': cartProduct.img
      });
    }
    // print(temp);
    try {
      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Orders')
          .add({
        'items': FieldValue.arrayUnion(temp),
        'amount': amount,
        // 'address': address.flatNumber! +
        //     " " +
        //     address.apartmentName! +
        //     " " +
        //     address.streetName! +
        //     " " +
        //     address.city! +
        //     " " +
        //     address.state! +
        //     " Pincode:-" +
        //     address.pincode.toString(),
        'date': Timestamp.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch)
      });
      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('cart')
          .doc(_auth.currentUser!.uid)
          .delete();
      Get.back();
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<List?> getOrders() async {
    Cart cart;
    Order tempOrder;
    List? Orders;
    List<CartProduct>? listOfCartProducts;
    List products;
    int amount;
    CartProduct cartProduct;
    String address;
    try {
      var listOfOrdersDocs = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Orders')
          .get()
          .then((value) => value.docs);
      for (var order in listOfOrdersDocs) {
        products = List.from(order.data()['items']);
        amount = order.data()['amount'];
        for (var temp in products) {
          cartProduct = CartProduct(
              productName: temp['name'],
              quantity: temp['qty'],
              price: temp['price'],
              metric: temp['metric'],
              img: temp['img']);
          // modifyProduct(temp['name'], temp['qty']);
          listOfCartProducts?.add(cartProduct);
        }
        cart = Cart(listOfCartProducts!, amount);
        address = order.data()['address'].toString();

        //TODO: ID:Timestamp, timestamp to string.
        // Timestamp? datestamp = order.data()["date"];
        String? datestamp = order.data()["date"];

        //while displaying this timestamp it can be converted to string using the following code
        //DateTime.parse(temp.toDate().toString()).toString().split(' ')[0]
        tempOrder = Order(cart: cart, address: address, date: datestamp!);
        Orders?.add(tempOrder);
      }
    } catch (e) {
      return null;
    }
    return Orders;
  }

  Future<List<Product>?> searchProduct(String productName) async {
    List<Product>? searchedProduct = [];
    Product? resultantProduct;

    try {
      var docData = await _firestore
          .collection('Products')
          .doc(productName)
          .get()
          .then((value) => value.data());

      if (docData != null) {
        resultantProduct = Product(
            name: docData['name'],
            category: docData['category'],
            currentStock: docData['current_stock'],
            urlImage: docData['image_url'],
            price: docData['price'],
            metric: docData['metric']);
        searchedProduct.add(resultantProduct);
      } else {
        print('docData is null');
        appSnackbar(
            message: 'Item Not found', snackbarState: SnackbarState.warning);
      }
    } catch (e) {
      appSnackbar(
          message: 'Error occured: $e', snackbarState: SnackbarState.warning);

      return [];
    }

    return searchedProduct;
  }

  Future<Product?> searchProductItem(String productName) async {
    Product? resultantProduct;

    try {
      var docData = await _firestore
          .collection('Products')
          .doc(productName)
          .get()
          .then((value) => value.data());

      if (docData != null) {
        resultantProduct = Product(
            name: docData['name'],
            category: docData['category'],
            currentStock: docData['current_stock'],
            urlImage: docData['image_url'],
            price: docData['price'],
            metric: docData['metric']);
      } else {
        print('docData is null');
        appSnackbar(
            message: 'Item Not found', snackbarState: SnackbarState.warning);
      }
    } catch (e) {
      appSnackbar(
          message: 'Error occured: $e', snackbarState: SnackbarState.warning);
    }

    return resultantProduct;
  }

  //for search by vegetables,fruits.
  Future<List<Product>?> getProductsByCategory(String category) async {
    late List<Product> products = [];
    Map docData;
    Product product;
    try {
      await _firestore.collection('Products').get().then((querySnapShot) {
        for (var temp in querySnapShot.docs) {
          docData = temp.data();
          print(docData);
          if (docData['category'] == category) {
            product = Product(
                name: docData['name'],
                category: docData['category'],
                currentStock: docData['current_stock'],
                urlImage: docData['image_url'],
                price: docData['price'],
                metric: docData['metric']);
            products.add(product);
            print('CATEGORY SELECTION $products');
          }
        }
      });
    } catch (e) {
      return null;
    }
    return products;
  }

  //Required only to call once to populate dummy data.
  Future<bool> seeding() async {
    Data data = Data();
    print('seeding called');
    List<Product>? listOfProducts = data.getProductData();
    print(listOfProducts);
    try {
      print('##');
      for (var product in listOfProducts!) {
        await addProduct(product);
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<List<Product>> getProductsBySearch(searchTerm) async {
    List<Product>? listOfProducts = [];
    await _firestore.collection('Products').get().then((value) async {
      var listOfDocs = value.docs;
      for (var doc in listOfDocs) {
        if (doc.id.contains(searchTerm)) {
          List<Product>? temp = await searchProduct(doc.id);
          listOfProducts.add(temp![0]);
        }
      }
    });
    return listOfProducts;
  }
}
