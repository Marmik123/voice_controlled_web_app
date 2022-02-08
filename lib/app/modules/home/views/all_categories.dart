import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voicewebapp/app/modules/home/controllers/home_controller.dart';
import 'package:voicewebapp/components/circular_loader.dart';
import 'package:voicewebapp/components/product_card.dart';
import 'package:voicewebapp/components/sized_box.dart';
import 'package:voicewebapp/controller/firebase_helper.dart';

class AllCategories extends GetView {
  FirebaseHelper firebaseHelper = FirebaseHelper();
  HomeController hCtrl = Get.find<HomeController>();

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
            GestureDetector(
              onTap: () {},
              child: Text(
                'Groceries',
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 100.sp,
                  fontWeight: FontWeight.w400,
                ),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            h(height: 30),
            Expanded(
              child: Obx(() => hCtrl.isLoading()
                  ? Center(child: buildLoader())
                  : buildGridView()),
            ),
          ],
        ),
      ),
    );
  }

  GridView buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        mainAxisSpacing: 35,
        crossAxisSpacing: 25,
      ),
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: hCtrl.products?.length ?? 0,
      scrollDirection: Axis.horizontal,
      //TODO: ROMIL's TASK Integrate Snacks category below.
      itemBuilder: (context, itemIndex) => ProductCard(
        name: hCtrl.products?[itemIndex].name ?? '-',
        imgUrl:
            hCtrl.products?[itemIndex].urlImage ?? 'https://picsum.photos/200',
        metric: hCtrl.products?[itemIndex].metric ?? '-',
        price: hCtrl.products?[itemIndex].price ?? 0,
        currentStock: hCtrl.products?[itemIndex].currentStock ?? 0,
      ),
    );
  }
}
