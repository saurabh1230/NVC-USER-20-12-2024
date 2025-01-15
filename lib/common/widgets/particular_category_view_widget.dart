import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_shimmer_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/theme1/restaurant_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/web_restaurant_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/route_helper.dart';
import '../../util/images.dart';
import 'home_product_widget.dart';

class ParticularCategoryViewWidget extends StatelessWidget {
  final List<Product?>? products;
  final List<Restaurant?>? restaurants;
  final bool isRestaurant;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String? noDataText;
  final bool isCampaign;
  final bool inRestaurantPage;
  final bool showTheme1Restaurant;
  final bool? isWebRestaurant;
  final String categoryBanner;
  final bool isCooked;
  final bool? isActive;
  const ParticularCategoryViewWidget({
    super.key,
    required this.restaurants,
    required this.products,
    required this.isRestaurant,
    this.isScrollable = false,
    this.shimmerLength = 6,
    this.padding = const EdgeInsets.all(Dimensions.paddingSizeSmall),
    this.noDataText,
    this.isCampaign = false,
    this.inRestaurantPage = false,
    this.showTheme1Restaurant = false,
    this.isWebRestaurant = false,
    required this.categoryBanner, this.isCooked = false, this.isActive
  });

  @override
  Widget build(BuildContext context) {
    print('check bool isRestaurant');
    print(isRestaurant);
    bool isNull = true;
    int length = 0;
    if (isRestaurant) {
      isNull = restaurants == null;
      if (!isNull) {
        length = restaurants!.length;
      }
    } else {
      isNull = products == null;
      if (!isNull) {
        length = products!.length;
      }
    }
    print('check');
    print(isRestaurant);

    int displayLength = length > 6 ? 6 : length; // Limit the number of items to 6

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            ResponsiveHelper.isMobile(context) ? const SizedBox() :
            ResponsiveHelper.isTab(context) ? const SizedBox() :
            isCooked ?
            Expanded(
              child: CustomInkWellWidget(
                onTap: () =>
                    Get.toNamed(
                        RouteHelper.getCookedUnCookedCategoryProductRoute(
                          1,
                          "cooked",
                        )),
                child: Container(
                  height: 565,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    image:  const DecorationImage(image: AssetImage(Images.foodTypeCookedBanner), fit: BoxFit.cover),
                  ),
                ),
              ),
            ) :
            Expanded(
              child: CustomInkWellWidget(
                onTap: () => Get.toNamed(RouteHelper.getUnCookedCategoryProductRoute(
                  1, "uncooked",
                )),
                child: Container(
                  height: 565,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    image:  const DecorationImage(image: AssetImage(Images.foodTypeUncookedBanner), fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            ResponsiveHelper.isMobile(context) ? const SizedBox() :
            ResponsiveHelper.isTab(context) ? const SizedBox() :
            const SizedBox(width: Dimensions.paddingSizeDefault,),
            Expanded(
              flex: 3,
              child: !isNull ? displayLength > 0 ? GridView.builder(
                key: UniqueKey(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: Dimensions.paddingSizeLarge,
                  mainAxisSpacing: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? Dimensions.paddingSizeLarge : isWebRestaurant! ? Dimensions.paddingSizeLarge : 0.01,
                  mainAxisExtent: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? ResponsiveHelper.isMobile(context) ? 200 : ResponsiveHelper.isTab(context) ? 240 : 280 : isWebRestaurant! ? 280 : showTheme1Restaurant ? 200 : 280,
                  crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : ResponsiveHelper.isTab(context) ? 3 : 3,
                ),
                physics: isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                shrinkWrap: isScrollable ? false : true,
                itemCount: displayLength,
                padding: padding,
                itemBuilder: (context, index) {
                  return showTheme1Restaurant ? RestaurantWidget(restaurant: restaurants![index], index: index, inStore: inRestaurantPage)
                      : isWebRestaurant! ? WebRestaurantWidget(restaurant: restaurants![index]) :
                  HomeProductWidget(
                    fromHomeProduct: true,
                    isActive: isActive,
                    isRestaurant: isRestaurant,
                    product:  products![index],
                    restaurant: null,
                    index: index,
                    length: displayLength,
                    isCampaign: isCampaign,
                    inRestaurant: inRestaurantPage,
                  );
                },
              ) : NoDataScreen(
                isRestaurant: isRestaurant,
                title: noDataText ?? (isRestaurant ? 'no_restaurant_available'.tr : 'no_food_available'.tr),
              ) : GridView.builder(
                key: UniqueKey(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: Dimensions.paddingSizeLarge,
                  mainAxisSpacing: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? Dimensions.paddingSizeLarge : isWebRestaurant! ? Dimensions.paddingSizeLarge : 0.01,
                  mainAxisExtent: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? ResponsiveHelper.isMobile(context) ? 200 : ResponsiveHelper.isTab(context) ? 240 : 280 : isWebRestaurant! ? 280 : showTheme1Restaurant ? 200 : 280,
                  crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : ResponsiveHelper.isTab(context) ? 3 : 3,
                ),
                physics: isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                shrinkWrap: isScrollable ? false : true,
                itemCount: shimmerLength,
                padding: padding,
                itemBuilder: (context, index) {
                  return showTheme1Restaurant ? RestaurantShimmer(
                      isEnable: isNull)
                      : isWebRestaurant! ? const WebRestaurantShimmer() : ProductShimmer(isEnabled: isNull, isRestaurant: isRestaurant, hasDivider: index != shimmerLength - 1);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
