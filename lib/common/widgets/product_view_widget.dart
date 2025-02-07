import 'package:non_veg_city/common/models/product_model.dart';
import 'package:non_veg_city/common/models/restaurant_model.dart';
import 'package:non_veg_city/common/widgets/home_product_widget.dart';
import 'package:non_veg_city/common/widgets/no_data_screen_widget.dart';
import 'package:non_veg_city/common/widgets/product_shimmer_widget.dart';
import 'package:non_veg_city/common/widgets/product_widget.dart';
import 'package:non_veg_city/features/cart/controllers/cart_controller.dart';
import 'package:non_veg_city/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:non_veg_city/features/home/widgets/theme1/restaurant_widget.dart';
import 'package:non_veg_city/features/restaurant/controllers/restaurant_controller.dart';
import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/common/widgets/web_restaurant_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:non_veg_city/util/styles.dart';

class ProductViewWidget extends StatelessWidget {
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
  final bool? isTitle;
  final bool? isRestaurantCategoryProducts;
  final Restaurant? restaurant;
  final bool? isActive;

  const ProductViewWidget({super.key, required this.restaurants, required this.products, required this.isRestaurant, this.isScrollable = false,
    this.shimmerLength = 20, this.padding = const EdgeInsets.all(Dimensions.paddingSizeSmall), this.noDataText,
    this.isCampaign = false, this.inRestaurantPage = false, this.showTheme1Restaurant = false, this.isWebRestaurant = false, this.isTitle = false, this.isRestaurantCategoryProducts = false, this.restaurant, this.isActive});

  @override
  Widget build(BuildContext context) {
    bool isNull = true;
    // bool isAvailable;
    int length = 0;
    if(isRestaurant) {
      print('isRestaurant');
      isNull = restaurants == null;
      if(!isNull) {
        length = restaurants!.length;
      }
    }else {
      print('products');
      isNull = products == null;
      if(!isNull) {
        length = products!.length;
      }
    }

    return Column(children: [
      isTitle! ?
      Column(
        children: [
          const SizedBox(height: Dimensions.paddingSizeDefault,),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal:ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text("All Food Items", style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,color: Colors.black.withOpacity(0.85))),
                  ],
                ),
                // Text("Farm Fresh Meat At Your Door", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.black.withOpacity(0.80))),

              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault,),
        ],
      ) : const SizedBox(),

      !isNull ? length > 0 ? GridView.builder(
        key: UniqueKey(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: Dimensions.paddingSizeLarge,
          mainAxisSpacing: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? Dimensions.paddingSizeLarge : isWebRestaurant! ? Dimensions.paddingSizeLarge : 0.01,
          //childAspectRatio: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? 3 : isWebRestaurant! ? 1.5 : showTheme1Restaurant ? 1.9 : 3.3,
          mainAxisExtent: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? ResponsiveHelper.isMobile(context) ? 200 : ResponsiveHelper.isTab(context) ? 240 : 280 : isWebRestaurant! ? 280 : showTheme1Restaurant ? 200 : 280,
          crossAxisCount: ResponsiveHelper.isMobile(context) && !isWebRestaurant! ? 2 : isWebRestaurant! ? 4 : 4,
        ),
        physics: isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
        shrinkWrap: isScrollable ? false : true,
        itemCount: length,
        padding: padding,
        itemBuilder: (context, index) {
          return showTheme1Restaurant ? RestaurantWidget(restaurant: restaurants![index], index: index, inStore: inRestaurantPage)
          : isWebRestaurant! ? WebRestaurantWidget(restaurant: restaurants![index]) :
          HomeProductWidget(
            isActive:isActive,
            isRestaurant: isRestaurant,
            product: isRestaurant ? null : products![index],
            restaurant: isRestaurant ? restaurants![index] : null,
            index: index,
            length: length,
            isCampaign: isCampaign,
            inRestaurant: inRestaurantPage,
          );
          // ProductWidget(
          //   isRestaurant: isRestaurant, product: isRestaurant ? null : products![index],
          //   restaurant: isRestaurant ? restaurants![index] : null, index: index, length: length, isCampaign: isCampaign,
          //   inRestaurant: inRestaurantPage,
          // );
        },
      ) : NoDataScreen(
        isRestaurant: isRestaurant,
        title: noDataText ?? (isRestaurant ? 'no_restaurant_available'.tr : 'no_food_available'.tr),
      ) : GridView.builder(
        key: UniqueKey(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: Dimensions.paddingSizeLarge,
          mainAxisSpacing: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? Dimensions.paddingSizeLarge : isWebRestaurant! ? Dimensions.paddingSizeLarge : 0.01,
          //childAspectRatio: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? 3 : isWebRestaurant! ? 1.5 : showTheme1Restaurant ? 1.9 : 3.3,
          mainAxisExtent: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? ResponsiveHelper.isMobile(context) ? 200 : ResponsiveHelper.isTab(context) ? 240 : 280 : isWebRestaurant! ? 280 : showTheme1Restaurant ? 200 : 280,
          crossAxisCount: ResponsiveHelper.isMobile(context) && !isWebRestaurant! ? 2 : isWebRestaurant! ? 4 : 4,
        ),
        physics: isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
        shrinkWrap: isScrollable ? false : true,
        itemCount: shimmerLength,
        padding: padding,
        itemBuilder: (context, index) {
          return showTheme1Restaurant ? RestaurantShimmer(isEnable: isNull)
              : isWebRestaurant! ? const WebRestaurantShimmer() :
          ProductShimmer(isEnabled: isNull, isRestaurant: isRestaurant, hasDivider: index != shimmerLength-1);
        },
      ),

    ]);
  }
}
