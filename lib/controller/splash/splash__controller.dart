
import 'dart:async';

import 'package:get/get.dart';

import '../../services/splash_services.dart';


class SplashController extends GetxController
{
  final splashService=SplashServices();



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
   splashService.isLogin();

  }




}