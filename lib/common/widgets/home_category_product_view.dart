import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:non_veg_city/common/models/product_model.dart';
import 'package:non_veg_city/common/models/restaurant_model.dart';
import 'package:non_veg_city/common/widgets/custom_button_widget.dart';
import 'package:non_veg_city/common/widgets/custom_ink_well_widget.dart';
import 'package:non_veg_city/common/widgets/hover_widgets/hover_zoom_widget.dart';
import 'package:non_veg_city/common/widgets/no_data_screen_widget.dart';
import 'package:non_veg_city/common/widgets/product_shimmer_widget.dart';
import 'package:non_veg_city/common/widgets/product_widget.dart';
import 'package:non_veg_city/features/home/widgets/theme1/restaurant_widget.dart';
import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/common/widgets/web_restaurant_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helper/route_helper.dart';

import 'home_product_widget.dart';

class HomeProductViewWidget extends StatelessWidget {
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
  const HomeProductViewWidget({super.key, required this.restaurants, required this.products, required this.isRestaurant, this.isScrollable = false,
    this.shimmerLength = 6, this.padding = const EdgeInsets.all(Dimensions.paddingSizeSmall), this.noDataText,
    this.isCampaign = false, this.inRestaurantPage = false, this.showTheme1Restaurant = false, this.isWebRestaurant = false, required this.categoryBanner});

  @override
  Widget build(BuildContext context) {
    bool isNull = true;
    int length = 0;
    if(isRestaurant) {
      isNull = restaurants == null;
      if(!isNull) {
        length = restaurants!.length;
      }
    }else {
      isNull = products == null;
      if(!isNull) {
        length = products!.length;
      }
    }

    return Column(mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(children: [
          ResponsiveHelper.isMobile(context) ? const SizedBox():
          ResponsiveHelper.isTab(context) ? const SizedBox() : Expanded(
            child: CustomInkWellWidget(onTap: () => Get.toNamed(RouteHelper.getCategoryProductRoute(
              8, "unCooked",
            )),
              child: Container(height: 560,decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
              image: DecorationImage(image: AssetImage(categoryBanner),fit: BoxFit.cover)),
                ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeDefault,),

          Expanded(
            flex: 3,
            child: !isNull ? length > 0 ? GridView.builder(
              key: UniqueKey(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: Dimensions.paddingSizeLarge,
                mainAxisSpacing: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? Dimensions.paddingSizeLarge : isWebRestaurant! ? Dimensions.paddingSizeLarge : 0.01,
                mainAxisExtent: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? ResponsiveHelper.isMobile(context) ? 200 : ResponsiveHelper.isTab(context) ? 240 : 280 : isWebRestaurant! ? 280 : showTheme1Restaurant ? 200 : 280,
                crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : ResponsiveHelper.isTab(context) ? 3 : 3,
              ),
              physics: isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
              shrinkWrap: isScrollable ? false : true,
              itemCount: length,
              padding: padding,
              itemBuilder: (context, index) {
                return showTheme1Restaurant ? RestaurantWidget(restaurant: restaurants![index], index: index, inStore: inRestaurantPage)
                    : isWebRestaurant! ? WebRestaurantWidget(restaurant: restaurants![index]) :

                HomeProductWidget(
                  isRestaurant: isRestaurant, product: isRestaurant ? null : products![index],
                  restaurant: isRestaurant ? restaurants![index] : null, index: index, length: length, isCampaign: isCampaign,
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
                mainAxisExtent: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? 280 : isWebRestaurant! ? 280 : showTheme1Restaurant ? 200 : 122,
                crossAxisCount: ResponsiveHelper.isMobile(context) && !isWebRestaurant! ? 1 : isWebRestaurant! ? 4 : 4,
              ),
              physics: isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
              shrinkWrap: isScrollable ? false : true,
              itemCount: shimmerLength,
              padding: padding,
              itemBuilder: (context, index) {
                return showTheme1Restaurant ? RestaurantShimmer(isEnable: isNull)
                    : isWebRestaurant! ? const WebRestaurantShimmer() : ProductShimmer(isEnabled: isNull, isRestaurant: isRestaurant, hasDivider: index != shimmerLength-1);
              },
            ),
          ),

        ]),
      ],
    );
  }
}
