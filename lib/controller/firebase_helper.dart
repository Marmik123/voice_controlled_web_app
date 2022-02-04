import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voicewebapp/app/data/remote/provider/models/cart.dart';
import 'package:voicewebapp/app/data/remote/provider/models/cartProduct.dart';
import 'package:voicewebapp/app/data/remote/provider/models/order.dart';
import 'package:voicewebapp/app/data/remote/provider/models/product.dart';
import 'package:voicewebapp/app/data/remote/provider/models/user.dart';
import 'package:voicewebapp/seed/seed.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class FirebaseHelper {
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
              metric: docData['metric']);
          products.add(product);
          print('inside firebase helper $products');
        }
      });
    } catch (e) {
      return null;
    }
    return products;
  }

  //For calling add to cart.
  Future<bool> addProductToCart(CartProduct cartproduct) async {
    try {
      //Before adding the product to the cart remember
      // to check the current stock with quantity requested by the user
      String? product = cartproduct.productName;
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
        'items': FieldValue.arrayUnion([
          {
            'name': product,
            'qty': quantity,
            'price': cartproduct.price,
            'metric': cartproduct.metric,
          }
        ]),
        'amount': current_price + (quantity ?? 0 * cartproduct.price!)
      });
    } catch (e) {
      return false;
    }
    return true;
  }

  //
  Future<bool> modifyCart(CartProduct cartproduct, int modifiedQuantity) async {
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
            'qty': quantity,
            'price': cartproduct.price,
            'metric': cartproduct.metric
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
          'items': FieldValue.arrayRemove([
            {
              'name': productName,
              'qty': modifiedQuantity,
              'price': cartproduct.price,
              'metric': cartproduct.metric
            }
          ]),
          'amount': current_price -
              (quantity ?? 0 * cartproduct.price!) +
              (modifiedQuantity * cartproduct.price!)
        });
      } else {
        await _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('cart')
            .doc(_auth.currentUser!.uid)
            .update({
          'amount': current_price - (quantity ?? 0 * cartproduct.price!)
        });
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<Cart?> getCart() async {
    List<CartProduct>? listOfCartProducts;
    List products;
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
              metric: temp['metric']);
          listOfCartProducts?.add(cartProduct);
        }
      });
    } catch (e) {
      return null;
    }
    return Cart(listOfCartProducts!, amount!);
  }

  Future<bool> checkOut(Cart cart, Address address) async {
    List<CartProduct> products = cart.products;
    int amount = cart.amount;
    List<dynamic>? temp;
    for (var cartProduct in products) {
      temp?.add({
        'name': cartProduct.productName,
        'qty': cartProduct.quantity,
        'price': cartProduct.price,
        'metrics': cartProduct.metric,
      });
    }
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('Orders')
          .add({
        'items': FieldValue.arrayUnion(
            temp!), //TODO:CHECK FOR THE NULL AWARE OF TEMP.
        'amount': amount,
        'address': address.flatNumber +
            " " +
            address.apartmentName +
            " " +
            address.streetName +
            " " +
            address.city +
            " " +
            address.state +
            " Pincode:-" +
            address.pincode.toString(),
        'date': Timestamp.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch)
      });
      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('cart')
          .doc(_auth.currentUser!.uid)
          .delete();
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
          .collection('users')
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
              metric: temp['metric']);
          modifyProduct(temp['name'], temp['qty']);
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

  Future<Product?> searchProduct(String productName) async {
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
      }
    } catch (e) {
      return null;
    }

    return resultantProduct;
  }

  //for search by vegetables,fruits.
  Future<List<Product>?> getProductsByCategory(String category) async {
    List<Product>? products;
    Map docData;
    Product product;
    try {
      await _firestore.collection('Products').get().then((querySnapShot) {
        for (var temp in querySnapShot.docs) {
          docData = temp.data();
          if (docData['category'] == category) {
            product = Product(
                name: docData['name'],
                category: docData['category'],
                currentStock: docData['current_stock'],
                urlImage: docData['image_url'],
                price: docData['price'],
                metric: docData['metric']);
            products?.add(product);
          }
        }
      });
    } catch (e) {
      return null;
    }
    return products;
  }

  //Required only to call once.
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
}
