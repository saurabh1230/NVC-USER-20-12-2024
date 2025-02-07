import 'package:flutter/widgets.dart';
import 'package:non_veg_city/common/widgets/custom_image_widget.dart';
import 'package:non_veg_city/common/widgets/custom_snackbar_widget.dart';
import 'package:non_veg_city/features/auth/controllers/auth_controller.dart';
import 'package:non_veg_city/features/auth/widgets/sign_in_widget.dart';
import 'package:non_veg_city/features/cart/controllers/cart_controller.dart';
import 'package:non_veg_city/features/profile/controllers/profile_controller.dart';
import 'package:non_veg_city/features/splash/controllers/splash_controller.dart';
import 'package:non_veg_city/features/location/controllers/location_controller.dart';
import 'package:non_veg_city/helper/address_helper.dart';
import 'package:non_veg_city/helper/extensions.dart';
import 'package:non_veg_city/helper/responsive.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/images.dart';
import 'package:non_veg_city/util/styles.dart';
import 'package:non_veg_city/common/widgets/hover_widgets/text_hover_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class WebSearchMenuBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget searchField;
  WebSearchMenuBar({super.key, required this.searchField});

  final TextEditingController _searchController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    return Material(
      elevation: 4,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Center(
                child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Get.toNamed(RouteHelper.getInitialRoute()),
                        child: SizedBox(
                            height: Responsive.isMobile(context) ? 40 : 60,
                            child: Image.asset(Images.webLogo, )),
                      ),
                      const SizedBox(width: 10),
                      Responsive.isMobile(context) ? const SizedBox() : SizedBox(
                        width: 300,
                        child: AddressHelper.getAddressFromSharedPref() != null ? InkWell(
                          onTap: () => Get.find<SplashController>().navigateToLocationScreen('home'),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            child: GetBuilder<LocationController>(builder: (locationController) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        AddressHelper.getAddressFromSharedPref()!.addressType == 'home' ? CupertinoIcons.house_alt_fill
                                            : AddressHelper.getAddressFromSharedPref()!.addressType == 'office' ? CupertinoIcons.bag_fill : CupertinoIcons.location_solid,
                                        size: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                      Text(
                                        '${AddressHelper.getAddressFromSharedPref()!.addressType!.tr}: ',
                                        style: robotoMedium.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: Dimensions.fontSizeExtraSmall,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Flexible(
                                    child: Text(
                                      AddressHelper.getAddressFromSharedPref()!.address!,
                                      style: robotoRegular.copyWith(
                                        color: Theme.of(context).textTheme.bodyLarge!.color,
                                        fontSize: Dimensions.fontSizeExtraSmall,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ) : const SizedBox(),
                      ),
                      searchField,
                      const SizedBox(width: 20),
                      Responsive.isLargeMobile(context) ? const SizedBox() :
                      MenuIconButton(icon: Icons.shopping_cart, color: Theme.of(context).primaryColor, isCart: true, onTap: () => Get.toNamed(RouteHelper.getCartRoute())),
                      Responsive.isLargeMobile(context) ? const SizedBox() :
                      GetBuilder<AuthController>(builder: (authController) {
                        return InkWell(
                          onTap: () {
                            if (authController.isLoggedIn()) {
                              final address = AddressHelper.getAddressFromSharedPref();
                              if (address == null || address.address == null || address.address!.isEmpty) {
                                print('Address is null or empty');
                                showCustomSnackBar('Please Select Delivery Address to continue');
                              } else {
                                Get.toNamed(RouteHelper.getProfileRoute());
                              }
                            } else {
                              Get.dialog(const Center(child: SignInWidget(exitFromApp: false, backFromThis: true)));
                            }
                          },

                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: CustomImageWidget(
                                    placeholder: Images.guestIcon,
                                    image: '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}'
                                        '/${(Get.find<ProfileController>().userInfoModel != null && isLoggedIn) ? Get.find<ProfileController>().userInfoModel!.image : ''}',
                                    height: 32,
                                    width: 32,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeSmall),
                                GetBuilder<ProfileController>(
                                  builder: (profileController) {
                                    bool isLoggedIn = authController.isLoggedIn();
                                    String displayName = '';
                                    if (isLoggedIn) {
                                      var userInfo = Get.find<ProfileController>().userInfoModel;
                                      if (userInfo != null && userInfo.fName != null) {
                                        displayName = userInfo.fName!;
                                      }
                                    } else {
                                      displayName = 'sign_in'.tr;
                                    }

                                    return Text(
                                      displayName.toTitleCase(),
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeExtraSmall,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    );
                                  },
                                ),

                                // GetBuilder<ProfileController>(builder: (profileController) {
                                //  return  Text(authController.isLoggedIn() ? '${Get.find<ProfileController>().userInfoModel!.fName != null ? Get.find<ProfileController>().userInfoModel!.fName :""  }' : 'sign_in'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, fontWeight: FontWeight.w100));
                                // }, ),

                              ],
                            ),
                          ),
                        );
                      }),
                      Responsive.isLargeMobile(context) ? const SizedBox() :
                      MenuIconButton(icon: Icons.menu, onTap: () {
                        Scaffold.of(context).openEndDrawer();
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size(Dimensions.webMaxWidth, 90);
}

class MenuButtonWithText extends StatelessWidget {
  final String title;
  final Function onTap;
  final IconData icon;
  const MenuButtonWithText({super.key, required this.title, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: Theme.of(context).cardColor,
              ),
              const SizedBox(width: 5),
              Text(title, style: robotoRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeExtraSmall, fontWeight: FontWeight.w100)),
            ],
          ),
        ],
      ),
    );
  }
}

class MenuIconButton extends StatelessWidget {
  final IconData icon;
  final bool isCart;
  final Function onTap;
  final Color? color;
  const MenuIconButton({super.key, required this.icon, this.isCart = false, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return TextHoverWidget(builder: (hovered) {
      return IconButton(
        onPressed: onTap as void Function()?,
        icon: GetBuilder<CartController>(builder: (cartController) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                color: hovered ? Theme.of(context).primaryColor : color ?? Theme.of(context).textTheme.bodyLarge!.color,
              ),
              (isCart && cartController.cartList.isNotEmpty) ? Positioned(
                top: -5,
                right: -5,
                child: Container(
                  height: 15,
                  width: 15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                  child: Text(
                    cartController.cartList.length.toString(),
                    style: robotoRegular.copyWith(fontSize: 12, color: Theme.of(context).cardColor),
                  ),
                ),
              ) : const SizedBox(),
            ],
          );
        }),
      );
    });
  }
}
