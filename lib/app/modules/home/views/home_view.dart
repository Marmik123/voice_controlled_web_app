import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voicewebapp/app/modules/home/views/all_categories.dart';
import 'package:voicewebapp/app/modules/home/views/beverages.dart';
import 'package:voicewebapp/app/modules/home/views/fruits_view.dart';
import 'package:voicewebapp/app/modules/home/views/search_by_name.dart';
import 'package:voicewebapp/app/modules/home/views/vegetables.dart';
import 'package:voicewebapp/app/routes/app_pages.dart';
import 'package:voicewebapp/components/appBar_Component.dart';
import 'package:voicewebapp/components/divider.dart';
import 'package:voicewebapp/components/fab.dart';
import 'package:voicewebapp/components/sized_box.dart';
import 'package:voicewebapp/utils/material_prop_ext.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  HomeController hCtrl = Get.put(HomeController());

  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FAB(),
      appBar: AppBar(
        leading: Container(),
        toolbarHeight: 70,
        leadingWidth: 25,
        backgroundColor: Theme.of(context).bottomAppBarColor,
        elevation: 5,
        title: Row(
          children: [
            Text(
              "Voice Controlled Web App",
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 120.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            //SEARCH PRODUCT.
          ],
        ),
        /*Container(
                    margin: EdgeInsets.only(top: 5),
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      controller: userCtrl.searchField,
                      onChanged: (value) {
                        print(value);
                      },
                      cursorColor: Colors.white,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.search_sharp,
                            color: theme.accentColor,
                          ),
                        ),
                        hintText: "Search Here",
                        hintStyle: kInterText.copyWith(
                          color: theme.accentColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: theme.primaryColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  )
*/
        actions: controller.appBarItems.entries
            .map(
              (appBarItem) => appBarComponent(
                iconButton: IconButton(
                  icon: appBarItem.key, //key= Icon
                  iconSize: 130.r,
                  color: theme.primaryColor,
                  onPressed: () {
                    switch (appBarItem.value) {
                      case 'Cart':
                        Get.toNamed(Routes.CART);
                        break;
                      case 'Logout':
                        hCtrl.signOut();
                        Get.offAllNamed(Routes.SIGN_IN);
                        break;
                    }
                  },
                  // tooltip: "Home",
                ),
                belowText: appBarItem.value, //value=appBarItem Text.
              ),
            )
            .toList(),
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Row(
          children: [
            Obx(() => NavigationRail(
                  extended: false,
                  minExtendedWidth: 100.w,
                  onDestinationSelected: (int index) {
                    controller.tabIndex(index);
                    // print('###selected tab index $index');
                  },
                  minWidth: 50.w,
                  backgroundColor: Colors.blueGrey[280],
                  elevation: 15,
                  labelType: NavigationRailLabelType.all,
                  leading: SizedBox(
                    height: 0.2.sh,
                    width: 0.15.sw,
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            // hCtrl.drawerExpanded(!hCtrl.drawerExpanded());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.restaurant_menu,
                                size: 80.r,
                              ),
                              w(width: 5.w),
                              Text(
                                'Categories',
                                style: TextStyle(
                                  fontSize: 75.sp,
                                  color: theme.primaryColor,
                                ),
                              )
                            ],
                          ),
                          style: ButtonStyle(
                            padding: EdgeInsets.all(20.w).msp,
                          ),
                        ),
                        buildDivider(
                          leftIndent: 4.w,
                          rightIndent: 4.w,
                        ),
                      ],
                    ),
                  ),
                  destinations: [
                    //TODO: ROMIL's TASK =>Already Made a Component for below widget just want you to add selectedIcon property inside controller naviagtionRailComponent and made it in a similar way like appBarComponent using .map().toList().
                    const NavigationRailDestination(
                      icon: Icon(Icons.search),
                      label: Text(
                        "Search by name",
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.home_filled,
                        color: theme.disabledColor,
                      ),
                      label: const Text(
                        "Groceries",
                      ),
                      selectedIcon: Icon(
                        Icons.home_filled,
                        color: theme.colorScheme.secondary,
                        semanticLabel: 'Home',
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.dashboard_sharp,
                        color: theme.disabledColor,
                      ),
                      label: const Text(
                        "Beverages",
                      ),
                      selectedIcon: Icon(
                        Icons.dashboard_sharp,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.category_rounded,
                        color: theme.disabledColor,
                      ),
                      label: const Text(
                        "Vegetables",
                      ),
                      selectedIcon: Icon(
                        Icons.category_rounded,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.category_rounded,
                        color: theme.disabledColor,
                      ),
                      label: const Text(
                        "Fruits",
                      ),
                      selectedIcon: Icon(
                        Icons.category_rounded,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    /*NavigationRailDestination(
                      icon: Icon(
                        Icons.supervised_user_circle_sharp,
                        color: theme.disabledColor,
                      ),
                      label: const Text(
                        "FoodGrains",
                      ),
                      selectedIcon: Icon(
                        Icons.supervised_user_circle_sharp,
                        color: theme.colorScheme.secondary,
                      ),
                    ),*/
                  ],
                  selectedIndex: controller.tabIndex(),
                  selectedLabelTextStyle: TextStyle(
                    color: theme.colorScheme.secondary,
                  ),
                )),
            const VerticalDivider(thickness: 1, width: 3),
            Obx(
              () => controller.tabIndex() == 1
                  ? Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: AllCategories(),
                      ),
                    )
                  : controller.tabIndex() == 2
                      ? Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Beverages(),
                          ),
                        )
                      : controller.tabIndex() == 3
                          ? Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: VegetableView(),
                              ),
                            )
                          : controller.tabIndex() == 4
                              ? Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    child: FruitsView(),
                                  ),
                                )
                              : controller.tabIndex() == 0
                                  ? Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        child: SearchByName(),
                                      ),
                                    )
                                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
