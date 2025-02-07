import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String? message, {bool isError = true, showToaster = false}) {
  if(message != null && message.isNotEmpty) {

    // if(showToaster && !GetPlatform.isWeb){
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity:  ToastGravity.TOP , // Use TOP_RIGHT for non-web platforms
        timeInSecForIosWeb: 1,
        // backgroundColor: Theme.of(context).primaryColor,
        textColor: Colors.white,
        webBgColor: isError ? "linear-gradient(to right, #ff0000, #ff7373)" : "linear-gradient(to right,#006400, #32CD32)",
        webPosition: "top_right", // Specify custom position for web
        fontSize: 16.0,
      );
    // } else {
    //   ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    //     dismissDirection: DismissDirection.horizontal,
    //     margin: EdgeInsets.only(
    //       right: ResponsiveHelper.isDesktop(Get.context) ? Get.context!.width*0.7 : Dimensions.paddingSizeSmall,
    //       top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall,
    //     ),
    //     duration: const Duration(seconds: 3),
    //     backgroundColor: isError ? Colors.red : Colors.green,
    //     behavior: SnackBarBehavior.floating,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
    //     content: Text(message, style: robotoMedium.copyWith(color: Colors.white)),
    //   ));
    // }

  }
}