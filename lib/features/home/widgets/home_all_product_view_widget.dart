import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:non_veg_city/common/models/product_model.dart';
import 'package:non_veg_city/common/models/restaurant_model.dart';
import 'package:non_veg_city/common/widgets/no_data_screen_widget.dart';
import 'package:non_veg_city/common/widgets/product_shimmer_widget.dart';
import 'package:non_veg_city/features/home/widgets/theme1/restaurant_widget.dart';
import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/common/widgets/web_restaurant_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/home_product_widget.dart';


class HomeAllProductViewWidget extends StatelessWidget {
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
  const HomeAllProductViewWidget({super.key, required this.restaurants, required this.products, required this.isRestaurant, this.isScrollable = false,
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

    return SizedBox(width:Dimensions.webMaxWidth,
      child: Column(mainAxisAlignment: MainAxisAlignment.start,
        children: [

          !isNull ? length > 0 ? GridView.builder(
            key: UniqueKey(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: Dimensions.paddingSizeLarge,
              mainAxisSpacing: Dimensions.paddingSizeDefault,
              //childAspectRatio: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? 3 : isWebRestaurant! ? 1.5 : showTheme1Restaurant ? 1.9 : 3.3,
              // mainAxisExtent: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? ResponsiveHelper.isMobile(context) ? 200 : ResponsiveHelper.isTab(context) ? 240 : 280 : isWebRestaurant! ? 280 : showTheme1Restaurant ? 200 : 280,
              crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : ResponsiveHelper.isTab(context) ? 3 : 4,
              mainAxisExtent: ResponsiveHelper.isMobile(context) ? 240: ResponsiveHelper.isTab(context) ? 240 : 280,
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
              mainAxisSpacing: Dimensions.paddingSizeDefault,
              //childAspectRatio: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? 3 : isWebRestaurant! ? 1.5 : showTheme1Restaurant ? 1.9 : 3.3,
              // mainAxisExtent: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? ResponsiveHelper.isMobile(context) ? 200 : ResponsiveHelper.isTab(context) ? 240 : 280 : isWebRestaurant! ? 280 : showTheme1Restaurant ? 200 : 280,
              crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : ResponsiveHelper.isTab(context) ? 3 : 4,
              mainAxisExtent: ResponsiveHelper.isMobile(context) ? 240: ResponsiveHelper.isTab(context) ? 240 : 280,
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
        ],
      ),
    );
  }
}
