import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_screen_controller.dart';

class LoginScreenView extends GetView<LoginScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LoginScreenView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'LoginScreenView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
