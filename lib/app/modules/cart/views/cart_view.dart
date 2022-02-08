import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voicewebapp/app/data/remote/provider/models/cart.dart';
import 'package:voicewebapp/app/routes/app_pages.dart';
import 'package:voicewebapp/components/circular_loader.dart';
import 'package:voicewebapp/components/divider.dart';
import 'package:voicewebapp/components/elevated_button.dart';
import 'package:voicewebapp/components/sized_box.dart';

import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    controller.getCartTotal();
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              },
            ),
            title: const Text('Your Cart'),
            actions: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Get.offAndToNamed(Routes.HOME);
                },
              )
            ],
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
                            child: FutureBuilder(
                              future: controller.firebaseHelper.getCart(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<Cart?> snapShot) {
                                if (snapShot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(child: buildLoader());
                                } else if (snapShot.hasData) {
                                  if (snapShot.data!.products.isNotEmpty) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Cart',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 125.sp,
                                              ),
                                            ),
                                            Text(
                                              'Total: ${snapShot.data!.amount.toString()}',
                                              style: TextStyle(
                                                fontSize: 80.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        buildDivider(),
                                        ListView.separated(
                                          itemBuilder: (context, index) {
                                            return SizedBox(
                                              height: 0.15.sh,
                                              width: 0.25.sw,
                                              child: ListTile(
                                                contentPadding:
                                                    EdgeInsets.only(top: 50.h),
                                                tileColor: Colors.white24,
                                                leading: Image.network(
                                                    'https://picsum.photos/200/300'),
                                                title: Text(snapShot.data!
                                                    .products[index].productName
                                                    .toString()),
                                                subtitle: Row(
                                                  children: [
                                                    Text(
                                                        'Rs. ${snapShot.data!.products[index].price}/${snapShot.data!.products[index].metric}'),
                                                    w(width: 25.w),
                                                    Text(
                                                        'Quantity. ${snapShot.data!.products[index].quantity}'),
                                                  ],
                                                ),
                                                trailing: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: FittedBox(
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        IconButton(
                                                            hoverColor:
                                                                Colors.white,
                                                            alignment: Alignment
                                                                .center,
                                                            icon: Icon(
                                                              Icons
                                                                  .remove_circle,
                                                              size: 95.r,
                                                              color: Colors
                                                                  .grey, //quantity == 1 ? Colors.grey : Colors.white,
                                                            ),
                                                            onPressed: () {
                                                              // quantity > 1
                                                              if (false) {
                                                                // quantity--
                                                                /* setState(() {
                                                        quantity--;
                                                      });
                                                   */
                                                              } else {
                                                                Get.rawSnackbar(
                                                                  message:
                                                                      'Minimum order quantity is 1',
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .warning),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .orangeAccent,
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .BOTTOM,
                                                                  overlayBlur:
                                                                      1,
                                                                  borderRadius:
                                                                      10,
                                                                  snackStyle:
                                                                      SnackStyle
                                                                          .FLOATING,
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                );
                                                              }
                                                            }),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width: 10.r,
                                                            ),
                                                          ),
                                                          child: RichText(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      '0', //'$quantity',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        65.sp,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      'kg', //' ${widget.metric}',
                                                                  style: GoogleFonts
                                                                      .sourceSansPro(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        45.sp,
                                                                  ),
                                                                ),
                                                              ],
                                                              style: GoogleFonts
                                                                  .sourceSansPro(
                                                                color: const Color(
                                                                    0xff000000),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 35.sp,
                                                              ),
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          alignment:
                                                              Alignment.center,
                                                          icon: Icon(
                                                            Icons.add_circle,
                                                            size: 95.r,
                                                            color: theme
                                                                .primaryColor,
                                                          ),
                                                          onPressed: () {
                                                            //quantity
                                                            // hCtrl.productQuantity(quantity + 1);
                                                            /*setState(() {
                                                    quantity++;
                                                  });*/
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount:
                                              snapShot.data!.products.length,
                                          shrinkWrap: true,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  buildDivider(
                                                      leftIndent: 2,
                                                      rightIndent: 5),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return const Center(
                                      child: Text('No item exist'),
                                    );
                                  }
                                } else {
                                  return const Center(
                                    child: Text('No item exist'),
                                  );
                                }
                              },
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
                              leading: Text(
                                'TOTAL',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: Obx(() => controller.isLoading()
                                  ? buildLoader()
                                  : Text(
                                      '${controller.cartTotal()}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),
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
