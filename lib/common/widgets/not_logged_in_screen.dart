
import 'package:non_veg_city/features/auth/widgets/sign_in_widget.dart';
import 'package:non_veg_city/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:non_veg_city/features/order/controllers/order_controller.dart';
import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/images.dart';
import 'package:non_veg_city/util/styles.dart';
import 'package:non_veg_city/common/widgets/custom_button_widget.dart';
import 'package:non_veg_city/common/widgets/footer_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotLoggedInScreen extends StatelessWidget {
  final Function(bool success) callBack;
  final bool isBackButton;

  const NotLoggedInScreen({super.key, required this.callBack,  this.isBackButton = false });

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return SingleChildScrollView(
      controller: scrollController,
      child: FooterViewWidget(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: SizedBox(width: Dimensions.webMaxWidth,
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                isBackButton ?
                Align(alignment: Alignment.topLeft,
                  child: ArrowIconButtonWidget(isLeft: true,
                    paddingLeft: Dimensions.paddingSizeSmall,
                    onTap: () {
                      Get.toNamed(RouteHelper.getMainRoute(1.toString()));
                    },
                  ),
                ): SizedBox(),
                Image.asset(
                  Images.guest,
                  width: MediaQuery.of(context).size.height*0.25,
                  height: MediaQuery.of(context).size.height*0.25,
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.01),

                Text(
                  'sorry'.tr,
                  style: robotoBold.copyWith(fontSize: MediaQuery.of(context).size.height*0.023, color: Theme.of(context).primaryColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.01),

                Text(
                  'you_are_not_logged_in'.tr,
                  style: robotoRegular.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175, color: Theme.of(context).disabledColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.04),

                SizedBox(
                  width: 200,
                  child: CustomButtonWidget(buttonText: 'login_to_continue'.tr, /*height: 40,*/ onPressed: () async {

                    if(!ResponsiveHelper.isDesktop(context)) {
                      await Get.toNamed(RouteHelper.getSignInRoute(Get.currentRoute));
                    }else{
                      Get.dialog(const Center(child: SignInWidget(exitFromApp: false, backFromThis: false))).then((value) => callBack(true));
                      // Get.dialog(const SignInScreen(exitFromApp: false, backFromThis: true)).then((value) => callBack(true));
                    }
                    if(Get.find<OrderController>().showBottomSheet) {
                      Get.find<OrderController>().showRunningOrders();
                    }
                    callBack(true);

                  }),
                ),

              ]),
            ),
          ),
        ),
      ),
    );
  }
}
