import 'package:authexample/app/data/models/user/user_info.dart';
import 'package:authexample/app/data/network_statuses.dart/network_status.dart';
import 'package:authexample/app/data/services/storage_service.dart';
import 'package:authexample/app/data/services/user_service.dart';
import 'package:authexample/app/routes/app_pages.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final _userService = Get.find<UserService>();

  final nameController = TextEditingController();
  final passController = TextEditingController();

  final _status = NetworkStatus.init.obs;

  NetworkStatus get status => _status.value;

  @override
  void onInit() async {
    if (await Get.find<StorageService>().readTokens() != null) Get.offAndToNamed(Routes.PERSONAL);
    super.onInit();
    FlutterNativeSplash.remove();
  }

  void login() async {
    _status.value = NetworkStatus.loading;
    final nickname = nameController.text;
    final password = passController.text;

    if (nickname.isEmpty || password.isEmpty) {
      Get.snackbar("Ошибка", "Логин / Пароль не может быть пустым");
      _status.value = NetworkStatus.error;
      return;
    }

    UserInfo credentials = UserInfo(email: nickname, password: password);

    if (await _userService.login(credentials)) {
      _status.value = NetworkStatus.finished;
      Get.offAndToNamed(Routes.PERSONAL);
      Get.snackbar("Успешно", "Вы вошли в аккаунт");
    } else {
      Get.snackbar("Ошибка", "Проверьте логин/пароль");
      _status.value = NetworkStatus.error;
    }
  }
}
