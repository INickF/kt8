import 'package:authexample/app/data/network_statuses.dart/network_status.dart';
import 'package:authexample/app/data/services/personal_info_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class PersonalController extends GetxController {
  final _personalService = Get.find<PersonalInfoService>();

  final _userPesonalInfo = "UNKNOWN".obs;
  final _status = NetworkStatus.init.obs;

  NetworkStatus get status => _status.value;
  String get userPerosnalInfo => _userPesonalInfo.value;
  
  @override
  void onInit() {
    getPersonal();
    super.onInit();
    FlutterNativeSplash.remove();
  }
  
  void getPersonal() async {
    _status.value = NetworkStatus.loading;
    String? newInfo = await _personalService.getPersonalInfo();
    if (newInfo == null) {
      Get.snackbar("Ошибка", "Не удалось получить данные");
      _status.value = NetworkStatus.loading;
      return;
    }

    _userPesonalInfo.value = newInfo;
    Get.snackbar("Успешно", "Данные получены");
    _status.value = NetworkStatus.finished;
  }
}
