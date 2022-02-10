import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voicewebapp/app/data/remote/provider/models/order.dart';
import 'package:voicewebapp/app/modules/cart/controllers/cart_controller.dart';
import 'package:voicewebapp/components/circular_loader.dart';
import 'package:voicewebapp/components/sized_box.dart';
import 'package:voicewebapp/components/snack_bar.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  CartController controller = Get.find<CartController>();
  var checkoutKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height / 1.5,
      width: Get.width / 2,
      child: SingleChildScrollView(
        child: Form(
          key: checkoutKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                controller: controller.flatNo,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Please enter flat number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blueGrey),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a flat number';
                  }
                  return null;
                },
              ),
              h(height: 20.h),
              TextFormField(
                controller: controller.apartMent,
                decoration: InputDecoration(
                  labelText: 'Please enter appartment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              h(height: 20.h),
              TextFormField(
                controller: controller.landmark,
                decoration: InputDecoration(
                  labelText: 'Please enter landmark',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              h(height: 20.h),
              TextFormField(
                controller: controller.city,
                decoration: InputDecoration(
                  labelText: 'Please enter a city',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              h(height: 20.h),
              TextFormField(
                controller: controller.state,
                decoration: InputDecoration(
                  labelText: 'Please enter state',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              h(height: 20.h),
              TextFormField(
                controller: controller.pincode,
                decoration: InputDecoration(
                  labelText: 'Please enter pincode',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              h(height: 40.h),
              Obx(() => controller.isOrderPlaced()
                  ? buildLoader()
                  : IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () async {
                        // var cart = await controller.firebaseHelper.getCart();

                        if (checkoutKey.currentState!.validate()) {
                          // controller.isOrderPlaced(true);
                          bool orderStatus =
                              await controller.firebaseHelper.checkOut(
                            controller.checkoutCart!,
                            Address(
                              flatNumber: controller.flatNo.text.trim(),
                              apartmentName: controller.apartMent.text.trim(),
                              city: controller.city.text.trim(),
                              pincode:
                                  int.parse(controller.pincode.text.trim()),
                              state: controller.state.text.trim(),
                              streetName: controller.landmark.text.trim(),
                            ),
                          );
                          print('ORDER STATUS:$orderStatus');
                          if (orderStatus) {
                            Get.back();
                            appSnackbar(
                                message: 'Order Placed Successfully',
                                snackbarState: SnackbarState.success);
                          } else {
                            Get.back();

                            appSnackbar(
                                message: 'Something went wrong',
                                snackbarState: SnackbarState.warning);
                          }
                          // controller.isOrderPlaced(false);
                        }
                      },
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
