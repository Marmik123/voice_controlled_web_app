import 'cart.dart';

class Order {
  Cart? cart;
  String? date; //TODO: ID:Timestamp, changed timestamp to String.
  String? address;

  Order({this.cart, this.date, this.address});
}

class Address {
  String flatNumber;
  String apartmentName;
  String streetName;
  int pincode;
  String city;
  String state;

  Address(this.flatNumber, this.apartmentName, this.streetName, this.pincode,
      this.city, this.state);
}
