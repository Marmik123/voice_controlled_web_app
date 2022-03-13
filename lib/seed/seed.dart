import 'package:voicewebapp/app/data/remote/provider/models/product.dart';

class Data {
  List<Product> listOfProducts = [];
  Product tomatoes = Product(
    name: 'tomatoes',
    category: 'vegetables',
    urlImage:
        'https://images.freeimages.com/images/small-previews/7d8/tomato-making-salsa-5-1558689.jpg',
    price: 58,
    metric: 'kg',
    currentStock: 50,
  );

  Product onions = Product(
    name: 'onions',
    category: 'vegetables',
    urlImage:
        'https://images.freeimages.com/images/small-previews/e05/onions-1171785.jpg',
    price: 39,
    metric: 'kg',
    currentStock: 50,
  );

  Product potatoes = Product(
    name: 'potatoes',
    category: 'vegetables',
    urlImage:
        'https://images.freeimages.com/images/small-previews/ee6/patatas-1-1576320.jpg',
    price: 22,
    metric: 'kg',
    currentStock: 50,
  );

  Product cucumbers = Product(
    name: 'cucumbers',
    category: 'vegetables',
    urlImage:
        'https://images.freeimages.com/images/small-previews/cc2/cucumber-1502107.jpg',
    price: 44,
    metric: 'kg',
    currentStock: 50,
  );

  Product beetroot = Product(
    name: 'beetroots',
    category: 'vegetables',
    urlImage:
        'https://images.freeimages.com/images/small-previews/a39/vegetables-1-1320310.jpg',
    price: 64,
    metric: 'kg',
    currentStock: 50,
  );

  Product apple = Product(
    name: 'apples',
    category: 'fruits',
    urlImage:
        'https://images.freeimages.com/images/small-previews/2b3/apple-1179663.jpg',
    price: 240,
    metric: 'dozen',
    currentStock: 50,
  );

  Product orange = Product(
    name: 'oranges',
    category: 'fruits',
    urlImage:
        'https://images.freeimages.com/images/small-previews/f40/oranges-1325500.jpg',
    price: 180,
    metric: 'kg',
    currentStock: 50,
  );

  Product banana = Product(
    name: 'bananas',
    category: 'fruits',
    urlImage:
        'https://images.freeimages.com/images/small-previews/4ec/banana-s-1326714.jpg',
    price: 80,
    metric: 'dozen',
    currentStock: 50,
  );

  Product watermelon = Product(
    name: 'watermelons',
    category: 'fruits',
    urlImage:
        'https://images.freeimages.com/images/small-previews/98c/watermelon-1506864.jpg',
    price: 58,
    metric: 'pc',
    currentStock: 50,
  );

  Product kiwi = Product(
    name: 'kiwis',
    category: 'fruits',
    urlImage:
        'https://images.freeimages.com/images/small-previews/d24/kiwi-1524179.jpg',
    price: 30,
    metric: 'pc',
    currentStock: 50,
  );
  List<Product>? getProductData() {
    listOfProducts.add(tomatoes);
    listOfProducts.add(onions);
    listOfProducts.add(cucumbers);
    listOfProducts.add(beetroot);
    listOfProducts.add(potatoes);
    listOfProducts.add(apple);
    listOfProducts.add(orange);
    listOfProducts.add(watermelon);
    listOfProducts.add(kiwi);
    listOfProducts.add(banana);
    print(listOfProducts);

    return listOfProducts;
  }
}
