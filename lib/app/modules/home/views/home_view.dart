import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  HomeController hCtrl = Get.put(HomeController());
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: GetBuilder(
        builder: (GetxController c) => FloatingActionButton(
          onPressed:
              // If not yet listening for speech start, otherwise stop
              hCtrl.speechToText.isNotListening ?? false
                  ? hCtrl.startListening
                  : hCtrl.stopListening,
          tooltip: 'Listen',
          child: Icon(hCtrl.speechToText?.isNotListening ?? false
              ? Icons.mic_off
              : Icons.mic),
        ),
      ),
      appBar: AppBar(
        leading: Container(),
        toolbarHeight: 70,
        leadingWidth: 25,
        backgroundColor: Theme.of(context).bottomAppBarColor,
        elevation: 5,
        title: Text(
          "Voice Controlled Web App",
          style: TextStyle(
            color: theme.colorScheme.secondary,
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
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
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: const Icon(Icons.mic_sharp),
              iconSize: 30,
              onPressed: () {},
              tooltip: "Microphone",
              color: theme.colorScheme.secondary,
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
            child: IconButton(
              icon: const Icon(Icons.login_outlined),
              iconSize: 30,
              onPressed: () {
                // Get.back();
              },
              tooltip: "Logout",
              color: theme.colorScheme.secondary,
            ),
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Obx(() => NavigationRail(
                  extended: false,
                  minExtendedWidth: 150,
                  onDestinationSelected: (int index) {
                    controller.tabIndex(index);
                    print('###selected tab index $index');
                  },
                  minWidth: 60,
                  groupAlignment: 0,
                  backgroundColor: Colors.grey[280],
                  elevation: 25,
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.home_filled,
                        color: theme.disabledColor,
                      ),
                      label: Text(
                        "Home",
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
                        "Products",
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
                        "About Us",
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
                      label: Text(
                        "Users",
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
            Obx(() => controller.tabIndex() == 0
                ? Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Text(
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
                      ),
                    ),
                  )
                : Container()),
          ],
        ),
      ),
    );
  }
}
