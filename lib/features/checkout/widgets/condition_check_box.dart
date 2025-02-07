import 'package:non_veg_city/features/splash/controllers/splash_controller.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutCondition extends StatelessWidget {
  const CheckoutCondition({super.key});

  @override
  Widget build(BuildContext context) {
    bool activeRefund = Get.find<SplashController>().configModel!.refundPolicyStatus == 1;
    return Row(children: [
      Expanded(
        child: RichText(text: TextSpan(children: [
          TextSpan(
            text: '${'i_have_read_and_agreed_with'.tr} ',
            style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
          TextSpan(
            text: 'privacy_policy'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.toNamed(RouteHelper.getHtmlRoute('privacy-policy')),
          ),
          activeRefund ? TextSpan(
            text: ', ',
            style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
          ) : TextSpan(
            text: ' ${'and'.tr} ',
            style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
          TextSpan(
            text: 'terms_conditions'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.toNamed(RouteHelper.getHtmlRoute('terms-and-condition')),
          ),
          activeRefund ? TextSpan(text: ' ${'and'.tr} ', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)) : const TextSpan(),

          activeRefund ? TextSpan(
            text: 'refund_policy'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.toNamed(RouteHelper.getHtmlRoute('refund-policy')),
          ) : const TextSpan(),
        ]), textAlign: TextAlign.start, maxLines: 3),
      ),
    ]);
  }
}
