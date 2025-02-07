import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:non_veg_city/features/auth/controllers/auth_controller.dart';
import 'package:non_veg_city/features/profile/controllers/profile_controller.dart';
import 'package:non_veg_city/features/profile/widgets/profile_button_widget.dart';
import 'package:non_veg_city/features/profile/widgets/profile_card_widget.dart';
import 'package:non_veg_city/features/splash/controllers/splash_controller.dart';
import 'package:non_veg_city/helper/date_converter.dart';
import 'package:non_veg_city/helper/extensions.dart';
import 'package:non_veg_city/helper/price_converter.dart';
import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/images.dart';
import 'package:non_veg_city/util/styles.dart';
import 'package:non_veg_city/common/widgets/confirmation_dialog_widget.dart';
import 'package:non_veg_city/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/widgets/arrow_icon_button_widget.dart';

class WebProfileWidget extends StatelessWidget {
  const WebProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (profileController) {
      bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
      final splashController = Get.find<SplashController>();
      final configModel = splashController.configModel;
      final userInfo = profileController.userInfoModel;
      
      return SizedBox(
        width: Dimensions.webMaxWidth,
        child: Column(children: [
          SizedBox(
            height: 243,
            child: Stack(children: [
              Container(
                height: 162,
                width: Dimensions.webMaxWidth,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.10),
                  image: const DecorationImage(
                      image: AssetImage(Images.profileBackground),
                      fit: BoxFit.fitWidth),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: ArrowIconButtonWidget(
                            isLeft: true,
                            paddingLeft: Dimensions.paddingSizeSmall,
                            onTap: () {
                              Get.toNamed(RouteHelper.getMainRoute('1'));
                            },
                          ),
                        ),
                        Text('profile'.tr,
                            style: robotoLight.copyWith(
                                fontSize: Dimensions.fontSizeOverLarge)),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 96,
                left: (Dimensions.webMaxWidth / 2) - 60,
                child: ClipOval(
                  child: CustomImageWidget(
                    placeholder: Images.guestIcon,
                    image: '${configModel?.baseUrls?.customerImageUrl ?? ''}/${(userInfo != null && isLoggedIn) ? userInfo.image ?? '' : ''}',
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    isLoggedIn
                        ? '${userInfo?.fName?.toTitleCase() ?? ''} ${userInfo?.lName?.toTitleCase() ?? ''}'
                        : 'guest_user'.tr,
                    style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          GridView.count(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.all(16),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            childAspectRatio: 9,
            children: <Widget>[
              isLoggedIn
                  ? GetBuilder<AuthController>(builder: (authController) {
                      return ProfileButtonWidget(
                        icon: Icons.notifications,
                        title: 'notification'.tr,
                        isButtonActive: authController.notification,
                        onTap: () {
                          authController.setNotificationActive(
                              !authController.notification);
                        },
                      );
                    })
                  : const SizedBox(),
              // isLoggedIn && userInfo?.socialId == null
              //     ? ProfileButtonWidget(
              //         icon: Icons.lock,
              //         title: 'change_password'.tr,
              //         onTap: () {
              //           Get.toNamed(RouteHelper.getResetPasswordRoute(
              //               '', '', 'password-change'));
              //         },
              //       )
              //     : const SizedBox(),
              isLoggedIn
                  ? ProfileButtonWidget(
                      icon: Icons.edit,
                      title: 'edit_profile'.tr,
                      onTap: () {
                        Get.toNamed(RouteHelper.getUpdateProfileRoute());
                      },
                    )
                  : const SizedBox(),
            ],
          ),
          const SizedBox(height: 100)
        ]),
      );
    });
  }
}