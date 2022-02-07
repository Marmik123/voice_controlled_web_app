import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voicewebapp/app/data/remote/provider/models/product.dart';
import 'package:voicewebapp/app/modules/home/controllers/home_controller.dart';
import 'package:voicewebapp/components/circular_loader.dart';
import 'package:voicewebapp/components/product_card.dart';
import 'package:voicewebapp/components/sized_box.dart';
import 'package:voicewebapp/controller/firebase_helper.dart';

class Beverages extends GetView<HomeController> {
  FirebaseHelper firebaseHelper = FirebaseHelper();

  Beverages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Beverages',
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 100.sp,
                fontWeight: FontWeight.w400,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            h(height: 60.h),
            Expanded(
              child: Obx(
                () => controller.isLoading()
                    ? Center(child: buildLoader())
                    : FutureBuilder(
                        future:
                            firebaseHelper.getProductsByCategory('beverages'),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Product>?> snapShot) {
                          print('@@@$snapShot');
                          if (snapShot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: buildLoader());
                          } else if (snapShot.hasData) {
                            if (snapShot.data!.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No item exist',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            } else {
                              return GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.5,
                                  mainAxisSpacing: 35,
                                  crossAxisSpacing: 25,
                                ),
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapShot.data?.length ?? 0,
                                scrollDirection: Axis.horizontal,
                                //TODO: ROMIL's TASK Integrate Snacks category below.
                                itemBuilder: (context, itemIndex) =>
                                    ProductCard(
                                  name: snapShot.data?[itemIndex].name ?? '-',
                                  imgUrl: snapShot.data?[itemIndex].urlImage ??
                                      'https://picsum.photos/200',
                                  metric:
                                      snapShot.data?[itemIndex].metric ?? '-',
                                  price: snapShot.data?[itemIndex].price ?? 0,
                                ),
                              );
                            }
                          } else {
                            return const Center(
                              child: Text(
                                'Something went wrong',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          }
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
