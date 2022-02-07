import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voicewebapp/app/modules/home/views/all_categories.dart';
import 'package:voicewebapp/app/modules/home/views/beverages.dart';
import 'package:voicewebapp/app/modules/home/views/fruits_view.dart';
import 'package:voicewebapp/app/modules/home/views/vegetables.dart';
import 'package:voicewebapp/app/routes/app_pages.dart';
import 'package:voicewebapp/components/appBar_Component.dart';
import 'package:voicewebapp/components/divider.dart';
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
      /*floatingActionButton: GetBuilder(
        builder: (GetxController c) => FloatingActionButton(
          onPressed:
              //If not yet listening for speech start, otherwise stop
              hCtrl.speechToText.isNotListening
                  ? hCtrl.startListening
                  : hCtrl.stopListening,
          tooltip: 'Listen',
          child: Icon(
              hCtrl.speechToText.isNotListening ? Icons.mic_off : Icons.mic,),
        ),
      ),*/
      appBar: AppBar(
        leading: Container(),
        toolbarHeight: 70,
        leadingWidth: 25,
        backgroundColor: Theme.of(context).bottomAppBarColor,
        elevation: 5,
        title: GestureDetector(
          onTap: () {
            // Get.toNamed(Routes.SIGN_IN);
            // Get.back();
          },
          child: Text(
            "Voice Controlled Web App",
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 120.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
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
            .map((appBarItem) => appBarComponent(
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
                  belowText: '${appBarItem.value}', //value=appBarItem Text.
                ))
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
                  groupAlignment: 0,
                  backgroundColor: Colors.blueGrey[280],
                  elevation: 15,
                  labelType: NavigationRailLabelType.all,
                  leading: SizedBox(
                    height: 0.1.sh,
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
                      label: Text(
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
                    NavigationRailDestination(
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
                    ),
                  ],
                  selectedIndex: controller.tabIndex(),
                  selectedLabelTextStyle: TextStyle(
                    color: theme.colorScheme.secondary,
                  ),
                )),
            const VerticalDivider(thickness: 1, width: 3),
            Obx(
              () => controller.tabIndex() == 0
                  ? Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: AllCategories(),
                        /*Text(
                        // If listening is active show the recognized words
                        controller.speechToText.isListening
                            ? controller.lastWords()
                            // If listening isn't active but could be tell the user
                            // how to start it, otherwise indicate that speech
                            // recognition is not yet ready or not supported on
                            // the target device
                            : controller.speechEnabled()
                                ? 'Tap the microphone to start listening...'
                                : 'Speech not available',
                      )*/
                      ),
                    )
                  : controller.tabIndex() == 1
                      ? Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Beverages(),
                          ),
                        )
                      : controller.tabIndex() == 2
                          ? Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: VegetableView(),
                              ),
                            )
                          : controller.tabIndex() == 3
                              ? Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    child: FruitsView(),
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
/*Container(
            margin: const EdgeInsets.only(right: 20),
            child: AvatarGlow(
              endRadius: 100,
              animate: false,
              duration: const Duration(milliseconds: 2000),
              glowColor: Colors.white,
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: const Duration(milliseconds: 50),
              child: IconButton(
                icon: const Icon(Icons.mic),
                iconSize: 30,
                onPressed: () {
                  hCtrl.speechToText.isNotListening
                      ? hCtrl.startListening()
                      : hCtrl.stopListening();
                },
                tooltip: "Microphone",
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: const Icon(Icons.security_rounded),
              iconSize: 30,
              onPressed: () {},
              tooltip: "Reset Password",
              color: theme.colorScheme.secondary,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.home),
                  iconSize: 30,
                  onPressed: () {},
                  tooltip: "Home",
                  color: theme.colorScheme.secondary,
                ),
                Text(
                  'Home',
                  style: TextStyle(fontSize: 23.sp),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: const Icon(Icons.login_outlined),
              iconSize: 30,
              onPressed: () {
                // Get.back();
              },
              tooltip: "Logout",
              color: theme.colorScheme.secondary,
            ),
          ),*/
