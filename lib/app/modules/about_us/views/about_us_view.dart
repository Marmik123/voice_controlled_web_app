import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/about_us_controller.dart';

class AboutUsView extends GetView<AboutUsController> {
  const AboutUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AboutUsView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'AboutUsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
