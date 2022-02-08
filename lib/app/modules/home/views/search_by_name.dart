import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voicewebapp/app/modules/home/controllers/home_controller.dart';
import 'package:voicewebapp/components/circular_loader.dart';
import 'package:voicewebapp/components/product_card.dart';
import 'package:voicewebapp/components/sized_box.dart';
import 'package:voicewebapp/components/text_field.dart';
import 'package:voicewebapp/controller/firebase_helper.dart';
import 'package:voicewebapp/utils/app_colors.dart';

class SearchByName extends GetView<HomeController> {
  FirebaseHelper firebaseHelper = FirebaseHelper();

  SearchByName({Key? key}) : super(key: key);

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
            Row(
              children: [
                Text(
                  'Searched Product Here',
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 100.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                w(width: 15.w),
                textField(
                  initialValue: '',
                  controller: controller.searchBarCtrl,
                  prefixText: '',
                  hintText: 'Search',
                  onTap: () {
                    // controller.tabIndex(0);
                  },
                  context: context,
                  height: 150.h,
                  width: 200.w,
                  suffixIcon: controller.searchBarCtrl.text.trim().isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                          color: AppColors.k6886A0,
                          //padding: const EdgeInsets.only(top: 15),
                          alignment: Alignment.center,
                          iconSize: 60.r,
                          tooltip: 'Clear Text',
                          splashRadius: 1,
                          icon: const Icon(
                            Icons.clear,
                          ),
                          onPressed: () {
                            controller.searchBarCtrl.clear();
                          },
                        ),
                  textAction: TextInputAction.search,
                  keyBoardType: TextInputType.text,
                  textStyle: TextStyle(
                    color: AppColors.k6886A0,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Gilroy',
                    fontSize: 60.sp,
                  ),
                  hintStyle: TextStyle(
                    color: AppColors.k6886A0,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Gilroy',
                    fontSize: 60.sp,
                  ),
                  contentPadding: EdgeInsets.only(top: 26.h),
                  /* onChanged: (value) async {
                    controller.isLoading(true);
                    controller.searchedProduct!(await controller.firebaseHelper
                        .getProductsBySearch(
                            controller.searchBarCtrl.text.trim()));
                    controller.isLoading(false);
                  },*/
                  onFieldSubmitted: (value) async {
                    if (value.isNotEmpty) {
                      controller.isLoading(true);
                      // controller.isSearched(true);
                      // controller.isLoading(true);
                      controller.searchedResult!(await controller.firebaseHelper
                          .getProductsBySearch(
                              controller.searchBarCtrl.text.trim()));
                      controller.isLoading(false);

                      // if (value.trim().isEmpty) {
                      //   controller.isSearched(false);
                    }
                  },
                ),
              ],
            ),
            h(height: 60.h),
            Expanded(
              child: Obx(
                () => controller.isLoading()
                    ? Center(child: buildLoader())
                    : controller.searchedResult!.isEmpty
                        ? Center(child: const Text('No Item Exist'))
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.5,
                              mainAxisSpacing: 35,
                              crossAxisSpacing: 25,
                            ),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.searchedResult?.length ?? 0,
                            scrollDirection: Axis.horizontal,
                            //TODO: ROMIL's TASK Integrate Snacks category below.
                            itemBuilder: (context, itemIndex) {
                              print(
                                  'searched RESI:${controller.searchedResult}');
                              return ProductCard(
                                name: controller
                                        .searchedResult?[itemIndex].name ??
                                    '-',
                                imgUrl: controller
                                        .searchedResult?[itemIndex].urlImage ??
                                    'https://picsum.photos/200',
                                metric: controller
                                        .searchedResult?[itemIndex].metric ??
                                    '-',
                                price: controller
                                        .searchedResult?[itemIndex].price ??
                                    0,
                              );
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
