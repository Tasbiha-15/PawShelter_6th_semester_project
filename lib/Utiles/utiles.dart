

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../resources/colors/app_colors.dart';



class Utils {

  static void fieldFocousChange(BuildContext context,FocusNode current,FocusNode nextFocus){

    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);

  }


  static void toastMesseges(String messege){
    Fluttertoast.showToast(
        msg: messege,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor:Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static toastMessegessuccess(String messege){
    Fluttertoast.showToast(
        msg: messege,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static void ShowSnackbar(String messege){

    Get.snackbar(
         "try", //title_text=>Text for customization
        messege,

        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        backgroundGradient: LinearGradient(
            colors: [
              Colors.teal,
              Colors.tealAccent
            ]
        ),
        icon: Icon(Icons.access_time_outlined,
          color: Colors.white,
        ),
        colorText: Colors.white,
        shouldIconPulse: true,
        margin: EdgeInsets.symmetric(horizontal: 8,vertical: 80),
        borderRadius: 8,
        snackStyle: SnackStyle.FLOATING,
        barBlur: 3

    );

  }



}