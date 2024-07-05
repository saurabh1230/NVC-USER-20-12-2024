import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/dimensions.dart';

class CheckoutCondition extends StatelessWidget {
  const CheckoutCondition({super.key});

  @override
  Widget build(BuildContext context) {
    bool activeRefund = Get.find<SplashController>().configModel!.refundPolicyStatus == 1;
    return Column(children: [
      // SizedBox(
      //   width: 24.0,
      //   height: 24.0,
      //   child: Checkbox(
      //     activeColor: Theme.of(context).primaryColor,
      //     value: isParcel ? parcelController.acceptTerms : orderController.acceptTerms,
      //     onChanged: (bool? isChecked) => isParcel ? parcelController.toggleTerms() : orderController.toggleTerms(),
      //   ),
      // ),
      // const SizedBox(width: Dimensions.paddingSizeSmall),
      Text('Please review your order and address details carefully to ensure smooth delivery and avoid any cancellations',
      style: robotoBold,),
      const SizedBox(height: Dimensions.paddingSizeDefault,),

      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, spreadRadius: 1, offset: const Offset(1, 2))],
        ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text:  TextSpan(
                text: 'Note : ',
                style: robotoBold.copyWith(color: Theme.of(context).primaryColor),
                children: <TextSpan>[
                  TextSpan(
                    text: 'The refund amount for a canceled order will vary based on the specific food items in your order.',
                    style: robotoMedium.copyWith(color: Colors.black,fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault,),
            Text('Read Cancellation Policy',
              style: robotoBold.copyWith(color: Theme.of(context).primaryColor.withOpacity(0.70),
                decoration: TextDecoration.underline,decorationColor:  Theme.of(context).primaryColor,),

            ),
          ],
        ),
      ),



      // Expanded(
      //   child: RichText(text: TextSpan(children: [
      //     TextSpan(
      //       text: 'Please review your order and address details carefully to ensure smooth delivery and avoid any cancellations ',
      //       style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
      //     ),
      //     TextSpan(
      //       text: 'privacy_policy'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
      //       recognizer: TapGestureRecognizer()
      //         ..onTap = () => Get.toNamed(RouteHelper.getHtmlRoute('privacy-policy')),
      //     ),
      //     activeRefund ? TextSpan(
      //       text: ', ',
      //       style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
      //     ) : TextSpan(
      //       text: ' ${'and'.tr} ',
      //       style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
      //     ),
      //     TextSpan(
      //       text: 'terms_conditions'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
      //       recognizer: TapGestureRecognizer()
      //         ..onTap = () => Get.toNamed(RouteHelper.getHtmlRoute('terms-and-condition')),
      //     ),
      //     activeRefund ? TextSpan(text: ' ${'and'.tr} ', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)) : const TextSpan(),
      //
      //     activeRefund ? TextSpan(
      //       text: 'refund_policy'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
      //       recognizer: TapGestureRecognizer()
      //         ..onTap = () => Get.toNamed(RouteHelper.getHtmlRoute('refund-policy')),
      //     ) : const TextSpan(),
      //   ]), textAlign: TextAlign.start, maxLines: 3),
      // ),
    ]);
  }
}
