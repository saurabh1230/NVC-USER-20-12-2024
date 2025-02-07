import 'package:non_veg_city/features/auth/controllers/auth_controller.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TramsConditionsCheckBoxWidget extends StatelessWidget {
  final AuthController authController;
  final bool fromSignUp;
  final bool fromDialog;
  const TramsConditionsCheckBoxWidget({super.key, required this.authController,  this.fromSignUp = false, this.fromDialog = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: fromSignUp ? MainAxisAlignment.center : MainAxisAlignment.center, children: [

          fromSignUp ? Checkbox(
            activeColor: Theme.of(context).primaryColor,
            value: authController.acceptTerms,
            onChanged: (bool? isChecked) => authController.toggleTerms(),
          ) : const SizedBox(),

          fromSignUp ? const SizedBox() : Text( '* ', style: robotoRegular),
          Text('By Signup I Agree With The All'.tr, style: robotoRegular.copyWith( fontSize: fromDialog ? Dimensions.fontSizeExtraSmall : null, color: Theme.of(context).hintColor)),

          // Expanded(
          //   child: InkWell(
          //     onTap: () => Get.toNamed(RouteHelper.getHtmlRoute('terms-and-condition')),
          //     child: Padding(
          //       padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          //       child: Text('terms_conditions'.tr, style: robotoMedium.copyWith( fontSize: fromDialog ? Dimensions.fontSizeExtraSmall : null, color: Theme.of(context).primaryColor )),
          //     ),
          //   ),
          // ),
        ]),
        InkWell(
          onTap: () => Get.toNamed(RouteHelper.getHtmlRoute('terms-and-condition')),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Text('terms_conditions'.tr, style: robotoMedium.copyWith( fontSize: fromDialog ? Dimensions.fontSizeExtraSmall : null, color: Theme.of(context).primaryColor )),
          ),
        ),
      ],
    );
  }
}
