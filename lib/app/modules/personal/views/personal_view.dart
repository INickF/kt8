import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/personal_controller.dart';

class PersonalView extends GetView<PersonalController> {
  const PersonalView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PersonalView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
              controller.userPerosnalInfo,
              style: const TextStyle(fontSize: 20),
            )),
            ElevatedButton(onPressed: () => controller.getPersonal(), child: const Text("Обновить"),),
          ],
        ),
      ),
    );
  }
}
