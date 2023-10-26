import 'package:authexample/app/data/models/user/user_info.dart';
import 'package:authexample/app/data/network_statuses.dart/network_status.dart';
import 'package:authexample/app/data/services/user_service.dart';
import 'package:authexample/app/routes/app_pages.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  final _userService = Get.find<UserService>();

  final nameController = TextEditingController();
  final passController = TextEditingController();

  final _status = NetworkStatus.init.obs;

  NetworkStatus get status => _status.value;
  
  void register() async {
    _status.value = NetworkStatus.loading;
    final nickname = nameController.text;
    final password = passController.text;

    if (nickname.isEmpty || password.isEmpty) {
      Get.snackbar("Ошибка", "Логин / Пароль не может быть пустым");
      _status.value = NetworkStatus.error;
      return;
    }

    UserInfo credentials = UserInfo(email: nickname, password: password);

    if (await _userService.register(credentials)) {
      _status.value = NetworkStatus.finished;
      Get.offAndToNamed(Routes.PERSONAL);
      Get.snackbar("Успешно", "Вы зарегистрированы");
    } else {
      Get.snackbar("Ошибка", "Ошибка регистрации");
      _status.value = NetworkStatus.error;
    }
  }
}
