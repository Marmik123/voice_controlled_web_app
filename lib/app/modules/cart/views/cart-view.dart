import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voicewebapp/app/data/remote/provider/models/cart.dart';
import 'package:voicewebapp/app/data/remote/provider/models/cartProduct.dart';
import 'package:voicewebapp/app/routes/app_pages.dart';
import 'package:voicewebapp/components/circular_loader.dart';
import 'package:voicewebapp/components/divider.dart';
import 'package:voicewebapp/components/elevated_button.dart';
import 'package:voicewebapp/components/sized_box.dart';
import 'package:voicewebapp/controller/firebase_helper.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  Cart cart = Cart([], 0);
  FirebaseHelper helper = FirebaseHelper();
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCart();
  }

  void getCart() async {
    cart = (await helper.getCart())!;
  }

  @override
  Widget build(BuildContext context) {
    List<CartProduct> listOfCartProducts = cart.products;
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Get.back();
                Get.offAndToNamed(Routes.HOME);
              },
            ),
            title: const Text('Your Cart'),
            // actions: [
            //   IconButton(
            //     icon: Icon(Icons.home),
            //     onPressed: () {
            //       Get.offAndToNamed(Routes.HOME);
            //     },
            //   )
            // ],
          ),
          body: SizedBox(
            // height: 0.95.sh,
            child: Padding(
              padding: EdgeInsets.only(top: 250.h),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    w(width: 60.w),
                    SizedBox(
                      width: Get.width * 0.65, //0.65.sw,
                      height: Get.height * 0.80, // 0.80.sh,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          h(height: 40.h),
                          Expanded(
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  height: 0.15.sh,
                                  width: 0.25.sw,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.only(top: 50.h),
                                    tileColor: Colors.white24,
                                    leading: Image.network(
                                        listOfCartProducts[index]
                                            .img
                                            .toString()),
                                    title: Text(listOfCartProducts[index]
                                        .productName
                                        .toString()),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                            'Rs. ${listOfCartProducts[index].price}/${listOfCartProducts[index].metric}'),
                                        w(width: 25.w),
                                        Text(
                                            'Quantity. ${listOfCartProducts[index].quantity}'),
                                      ],
                                    ),
                                    trailing: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FittedBox(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            IconButton(
                                                hoverColor: Colors.white,
                                                alignment: Alignment.center,
                                                icon: Icon(
                                                  Icons.remove_circle,
                                                  size: 95.r,
                                                  color: Colors
                                                      .grey, //quantity == 1 ? Colors.grey : Colors.white,
                                                ),
                                                onPressed: () async {
                                                  var modifyStatus =
                                                      await helper.modifyCart(
                                                          listOfCartProducts[
                                                              index],
                                                          (listOfCartProducts[
                                                                          index]
                                                                      .quantity ??
                                                                  0) -
                                                              1,
                                                          (listOfCartProducts[
                                                                      index]
                                                                  .quantity ??
                                                              0));
                                                  print(
                                                      'modified:${(listOfCartProducts[index].quantity ?? 0) - 1}');
                                                  print(
                                                      'modified:${(listOfCartProducts[index].quantity)}');

                                                  print(
                                                      "modifystatus:${modifyStatus}");
                                                  Cart? temp =
                                                      await helper.getCart();
                                                  setState(() {
                                                    cart = temp!;
                                                  });

                                                  // quantity > 1
                                                  //             if (false) {

                                                  //               // quantity--
                                                  //               /* setState(() {
                                                  //       quantity--;
                                                  //     });
                                                  //  */
                                                  //             } else {
                                                  //               Get.rawSnackbar(
                                                  //                 message:
                                                  //                     'Minimum order quantity is 1',
                                                  //                 icon: const Icon(
                                                  //                     Icons
                                                  //                         .warning),
                                                  //                 backgroundColor:
                                                  //                     Colors
                                                  //                         .orangeAccent,
                                                  //                 snackPosition:
                                                  //                     SnackPosition
                                                  //                         .BOTTOM,
                                                  //                 overlayBlur:
                                                  //                     1,
                                                  //                 borderRadius:
                                                  //                     10,
                                                  //                 snackStyle:
                                                  //                     SnackStyle
                                                  //                         .FLOATING,
                                                  //                 margin:
                                                  //                     const EdgeInsets
                                                  //                         .all(10),
                                                  //               );
                                                  //             }
                                                }),
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  width: 10.r,
                                                ),
                                              ),
                                              child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: listOfCartProducts[
                                                              index]
                                                          .quantity
                                                          .toString(), //'$quantity',
                                                      style: TextStyle(
                                                        fontSize: 65.sp,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: listOfCartProducts[
                                                              index]
                                                          .metric
                                                          .toString(), //' ${widget.metric}',
                                                      style: GoogleFonts
                                                          .sourceSansPro(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 45.sp,
                                                      ),
                                                    ),
                                                  ],
                                                  style:
                                                      GoogleFonts.sourceSansPro(
                                                    color:
                                                        const Color(0xff000000),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 35.sp,
                                                  ),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            IconButton(
                                              alignment: Alignment.center,
                                              icon: Icon(
                                                Icons.add_circle,
                                                size: 95.r,
                                                color: theme.primaryColor,
                                              ),
                                              onPressed: () async {
                                                var modifyStatus =
                                                    await helper.modifyCart(
                                                        listOfCartProducts[
                                                            index],
                                                        (listOfCartProducts[
                                                                        index]
                                                                    .quantity ??
                                                                0) +
                                                            1,
                                                        (listOfCartProducts[
                                                                    index]
                                                                .quantity ??
                                                            0));
                                                print(
                                                    "modifystatus:${modifyStatus}");
                                                //quantity
                                                // hCtrl.productQuantity(quantity + 1);
                                                /*setState(() {
                                                    quantity++;
                                                  });*/
                                                Cart? temp =
                                                    await helper.getCart();
                                                setState(() {
                                                  cart = temp!;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: listOfCartProducts.length,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              separatorBuilder: (BuildContext context,
                                      int index) =>
                                  buildDivider(leftIndent: 2, rightIndent: 5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    w(width: 60.w),
                    Container(
                      width: Get.width * 0.25, //0.25.sw,
                      height: Get.height * 0.50, //0.50.sh,
                      // alignment: Alignment.,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 3.r,
                            color: Colors.grey,
                            offset: const Offset(7, 7),
                            blurRadius: 100.r,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15.r),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment Details',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 125.sp,
                              ),
                            ),
                            ListTile(
                              hoverColor: Colors.blueGrey,
                              contentPadding: EdgeInsets.zero,
                              leading: const Text(
                                'TOTAL',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: Text(
                                cart.amount.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              // mainAxisAlignment: MainAxisAlignment.start,
                            ),
                            h(height: 50.h),
                            button(
                              btnText: 'Place Order',
                              onPressed: () {},
                              // cartAmount: controller.
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
