import 'package:stackfood_multivendor/common/widgets/rating_bar_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductShimmer extends StatelessWidget {
  final bool isEnabled;
  final bool isRestaurant;
  final bool hasDivider;
  const ProductShimmer({super.key, required this.isEnabled, required this.hasDivider, this.isRestaurant = false});

  @override
  Widget build(BuildContext context) {
    bool desktop = ResponsiveHelper.isDesktop(context);

    return Padding(
      padding: EdgeInsets.only(bottom: desktop ? 0 :Dimensions.paddingSizeSmall),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          color: Theme.of(context).cardColor,
          boxShadow: ResponsiveHelper.isDesktop(context) ? [BoxShadow(
            color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 1, blurRadius: 5,
          )] : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(children: [

                Container(
                  height:  230, width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [

                    // Container(height: desktop ? 20 : 10, width: double.maxFinite, color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Container(
                      height: desktop ? 15 : 10, width: double.maxFinite, color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                      margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Container(
                      height: desktop ? 15 : 8, width: 50, color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                      margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    // SizedBox(height: isRestaurant ? Dimensions.paddingSizeSmall : 0),

                    !isRestaurant ? RatingBarWidget(rating: 0, size: desktop ? 15 : 12, ratingCount: 0) : const SizedBox(),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    isRestaurant ? RatingBarWidget(
                      rating: 0, size: desktop ? 15 : 12,
                      ratingCount: 0,
                    ) : Row(children: [
                      Container(height: desktop ? 20 : 10, width: 30, color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Container(height: desktop ? 15 : 10, width: 20, color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Container(height: desktop ? 20 : 6, width: double.maxFinite, color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Container(margin: EdgeInsets.only(right: Dimensions.paddingSizeExtraLarge),
                        height: desktop ? 20 : 6, width: double.maxFinite, color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Container(margin: EdgeInsets.only(right: 40),
                        height: desktop ? 20 : 6, width: double.maxFinite, color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]),





                  ]),


                ),

                Column(mainAxisAlignment: isRestaurant ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween, children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: desktop ? Dimensions.paddingSizeSmall : 0),
                    child: Icon(
                      Icons.favorite_border,  size: desktop ? 30 : 25,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),

                  !isRestaurant ? Padding(
                    padding: EdgeInsets.symmetric(vertical: desktop ? Dimensions.paddingSizeSmall : 0),
                    child: Icon(Icons.add, size: desktop ? 30 : 25),
                  ) : const SizedBox(),
                ]),

              ]),
            ),
            // desktop ? const SizedBox() : Padding(
            //   padding: EdgeInsets.only(left: desktop ? 130 : 90),
            //   child: Divider(color: hasDivider ? Theme.of(context).disabledColor : Colors.transparent),
            // ),
          ],
        ),
      ),
    );
  }
}
