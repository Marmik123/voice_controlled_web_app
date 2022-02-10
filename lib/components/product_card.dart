import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voicewebapp/app/data/remote/provider/models/cartProduct.dart';
import 'package:voicewebapp/app/modules/home/controllers/home_controller.dart';
import 'package:voicewebapp/components/circular_loader.dart';
import 'package:voicewebapp/components/sized_box.dart';
import 'package:voicewebapp/components/snack_bar.dart';
import 'package:voicewebapp/utils/app_colors.dart';
import 'package:voicewebapp/utils/material_prop_ext.dart';

class ProductCard extends StatefulWidget {
  final String? imgUrl;
  final String? name;
  final String? metric;
  final int? price;
  final int? currentStock;
  final Function? addToCart;

  const ProductCard(
      {Key? key,
      this.imgUrl,
      this.name,
      this.metric,
      this.price,
      this.addToCart,
      this.currentStock})
      : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 1;
  int modifiedQuantity = 1;
  bool cardStatus = false;
  bool addToCartLoading = false;
  HomeController hCtrl = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: const LinearGradient(
          colors: [
            AppColors.kproductCard1,
            AppColors.kproductCard2,
          ],
        ),
      ),
      width: 120.w,
      height: 700.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                cardStatus = false;
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: SizedBox(
                width: Get.width / 4,
                height: Get.height / 7,
                child: Image(
                  fit: BoxFit.fill,
                  semanticLabel: 'Snacks image',
                  image: NetworkImage(
                    widget.imgUrl!,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0.w),
            child: Text(
              '${widget.name}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 75.sp,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Text(
              'Rs: ${widget.price}/${widget.metric}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 55.sp,
              ),
            ),
          ),
          /*hCtrl.addToCartButton()
              ?*/
          if (cardStatus)
            Expanded(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            hoverColor: Colors.white,
                            alignment: Alignment.center,
                            icon: Icon(
                              Icons.remove_circle,
                              size: 35.w,
                              color: quantity == 1 ? Colors.grey : Colors.white,
                            ),
                            onPressed: () {
                              if (modifiedQuantity > 0) {
                                // quantity--
                                setState(() {
                                  modifiedQuantity--;
                                });
                                // cartUpdate(quantity+1);
                              } else {
                                Get.rawSnackbar(
                                  message: 'Minimum order quantity is 1',
                                  icon: const Icon(Icons.warning),
                                  backgroundColor: Colors.orangeAccent,
                                  snackPosition: SnackPosition.BOTTOM,
                                  overlayBlur: 1,
                                  borderRadius: 10,
                                  snackStyle: SnackStyle.FLOATING,
                                  margin: const EdgeInsets.all(10),
                                );
                              }
                            }),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '$modifiedQuantity',
                                  style: TextStyle(
                                    fontSize: 65.sp,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${widget.metric}',
                                  style: GoogleFonts.sourceSansPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 45.sp,
                                  ),
                                ),
                              ],
                              style: GoogleFonts.sourceSansPro(
                                color: const Color(0xff000000),
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
                            size: 35.w,
                            color: AppColors.kffffff,
                          ),
                          onPressed: () {
                            //quantity
                            // hCtrl.productQuantity(quantity + 1);
                            setState(() {
                              modifiedQuantity++;
                            });
                            // cartUpdate(quantity-1);
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: ElevatedButton(
                        onPressed: () async {},
                        style: ButtonStyle(
                          elevation: 10.0.msp,
                          padding: const EdgeInsets.all(8).msp,
                        ),
                        child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: TextButton(
                              onPressed: () {
                                cartUpdate(modifiedQuantity, quantity);
                                setState(() {
                                  quantity = modifiedQuantity;
                                });
                                if (modifiedQuantity == 0) {
                                  setState(() {
                                    cardStatus = false;
                                  });
                                }
                              },
                              child: const Text(
                                'Modify',
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.all(8.0.w),
              child: ElevatedButton(
                onPressed: () async {
                  print('onPressed Called');
                  if (quantity <= widget.currentStock!) {
                    setState(() {
                      addToCartLoading = true;
                    });
                    print('product is available');
                    var addedToCart =
                        await hCtrl.firebaseHelper.addProductToCart(
                      CartProduct(
                        productName: widget.name,
                        quantity: quantity,
                        price: widget.price,
                        metric: widget.metric,
                        img: widget.imgUrl,
                      ),
                    );
                    print('!!!${addedToCart}');
                    setState(() {
                      cardStatus = true;
                      quantity = addedToCart[0];
                      modifiedQuantity = addedToCart[0];
                      if (addedToCart[1]) {
                        setState(() {
                          addToCartLoading = false;
                        });
                        appSnackbar(
                          message: 'Added To Cart Successfully',
                          snackbarState: SnackbarState.success,
                        );
                      }
                    });
                  }

                  // hCtrl.addToCartButton(true);
                },
                style: ButtonStyle(
                  elevation: 10.0.msp,
                  padding: const EdgeInsets.all(8).msp,
                ),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Add to cart'),
                      addToCartLoading
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildLoader(
                                color: AppColors.kffffff,
                              ),
                            )
                          : IconButton(
                              alignment: Alignment.center,
                              icon: Icon(
                                Icons.add_circle,
                                size: 35.w,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                //quantity++
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          h(height: 25.h),
        ],
      ),
    );
  }

  // Row(
  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  // children: [
  // const Text('Modify'),
  // IconButton(
  // alignment: Alignment.center,
  // icon: Icon(
  // Icons.edit,
  // size: 35.w,
  // color: Colors.white,
  // ),
  // onPressed: () {
  // cartUpdate(modifiedQuantity, quantity);
  // },
  // ),
  // ],
  // ),
  Future<void> cartUpdate(int modifiedQuantity, int previousQuantity) async {
    print(modifiedQuantity);
    print(previousQuantity);
    var cardUpdate = await hCtrl.firebaseHelper.modifyCart(
        CartProduct(
            productName: widget.name,
            quantity: quantity,
            price: widget.price,
            metric: widget.metric,
            img: widget.imgUrl),
        modifiedQuantity,
        previousQuantity);
    if (cardUpdate) {
      appSnackbar(
          message: 'Cart Updated Succesfully',
          snackbarState: SnackbarState.success);
    }
  }
}

/*
Widget productCard({
  String? imgUrl,
  String? name,
  String? metric,
  int? price,
}) {
  HomeController hCtrl = Get.find<HomeController>();
  return Container(
    decoration: const BoxDecoration(
      // borderRadius: BorderRadius.circular(15),
      gradient: LinearGradient(
        colors: [
          AppColors.kproductCard1,
          AppColors.kproductCard2,
        ],
      ),
    ),
    width: 190.w,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FittedBox(
          fit: BoxFit.fill,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              height: 250.h,
              width: 250.w,
              semanticLabel: 'Snacks image',
              image: NetworkImage(
                imgUrl!,
              ),
            ),
          ),
        ),
        Text('Rs: ${price}/${metric}'),
        hCtrl.addToCartButton()
            ? Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        hoverColor: Colors.white,
                        alignment: Alignment.center,
                        icon: Icon(
                          Icons.remove_circle,
                          size: 35.w,
                          color: quantity <= 1
                              ? Colors.grey
                              : Colors.white,
                        ),
                        onPressed: () {
                          if (hCtrl.productQuantity() > 1) {
                            // quantity--
                            hCtrl.productQuantity(hCtrl.productQuantity() - 1);
                          } else {
                            Get.rawSnackbar(
                              message: 'Minimum order quantity is 1',
                              icon: const Icon(Icons.warning),
                              backgroundColor: Colors.orangeAccent,
                              snackPosition: SnackPosition.BOTTOM,
                              overlayBlur: 1,
                              borderRadius: 10,
                              snackStyle: SnackStyle.FLOATING,
                              margin: const EdgeInsets.all(10),
                            );
                          }
                        }),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: Obx(() => RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${hCtrl.productQuantity()}',
                                  style: TextStyle(
                                    fontSize: 65.sp,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${metric}',
                                  style: GoogleFonts.sourceSansPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 45.sp,
                                  ),
                                ),
                              ],
                              style: GoogleFonts.sourceSansPro(
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.bold,
                                fontSize: 35.sp,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          )),
                    ),
                    IconButton(
                      alignment: Alignment.center,
                      icon: Icon(
                        Icons.add_circle,
                        size: 35.w,
                        color: AppColors.kffffff,
                      ),
                      onPressed: () {
                        //quantity
                        hCtrl.productQuantity(hCtrl.productQuantity() + 1);
                      },
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    hCtrl.addToCartButton(true);
                  },
                  style: ButtonStyle(
                    elevation: 10.0.msp,
                    padding: const EdgeInsets.all(8).msp,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Add to cart'),
                      IconButton(
                        alignment: Alignment.center,
                        icon: Icon(
                          Icons.add_circle,
                          size: 35.w,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          //quantity++
                        },
                      )
                    ],
                  ),
                ),
              ),
        h(height: 25.h),
      ],
    ),
  );
}
*/
