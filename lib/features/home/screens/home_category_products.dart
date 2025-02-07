import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:non_veg_city/common/models/product_model.dart';
import 'package:non_veg_city/common/models/restaurant_model.dart';
import 'package:non_veg_city/common/widgets/custom_ink_well_widget.dart';
import 'package:non_veg_city/common/widgets/no_data_screen_widget.dart';
import 'package:non_veg_city/common/widgets/product_shimmer_widget.dart';
import 'package:non_veg_city/features/home/screens/home_category_view_products.dart';
import 'package:non_veg_city/features/home/widgets/theme1/restaurant_widget.dart';
import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/common/widgets/web_restaurant_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/home_product_widget.dart';
import '../../../helper/route_helper.dart';
import '../../../util/images.dart';



class HomeCategoryProduct extends StatelessWidget {
  final List<Product?>? products;
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

  const HomeCategoryProduct({
    super.key,
    required this.products,
    this.isScrollable = false,
    this.shimmerLength = 6,
    this.padding = const EdgeInsets.all(Dimensions.paddingSizeSmall),
    this.noDataText,
    this.isCampaign = false,
    this.inRestaurantPage = false,
    this.showTheme1Restaurant = false,
    this.isWebRestaurant = false,
    required this.categoryBanner,
    this.isCooked = false,
    this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    bool isNull = products == null;
    int length = isNull ? 0 : products!.length;
    int displayLength = length > 6 ? 6 : length; // Limit the number of items to 6

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            if (!ResponsiveHelper.isMobile(context) && !ResponsiveHelper.isTab(context))
              Expanded(
                child: CustomInkWellWidget(
                  onTap: () => Get.toNamed(
                    isCooked
                        ? RouteHelper.getCookedUnCookedCategoryProductRoute(1, "cooked")
                        : RouteHelper.getUnCookedCategoryProductRoute(1, "uncooked"),
                  ),
                  child: Container(
                    height: 565,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      image: DecorationImage(
                        image: AssetImage(
                          isCooked ? Images.foodTypeCookedBanner : Images.foodTypeUncookedBanner,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(width: Dimensions.paddingSizeDefault),
            Expanded(
              flex: 3,
              child: !isNull
                  ? displayLength > 0
                  ? GridView.builder(
                key: UniqueKey(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: Dimensions.paddingSizeLarge,
                  mainAxisSpacing: isWebRestaurant! ? Dimensions.paddingSizeLarge : 0.01,
                  mainAxisExtent: showTheme1Restaurant ? 200 : 280,
                  crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : 3,
                ),
                physics: isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                shrinkWrap: !isScrollable,
                itemCount: displayLength,
                padding: padding,
                itemBuilder: (context, index) {
                  return HomeCategoryViewProductWidget(
                    isActive: isActive,
                    product: products![index],
                    index: index,
                    length: displayLength,
                    isCampaign: isCampaign,
                    inRestaurant: inRestaurantPage,
                    isRestaurant: false,
                    restaurant: null,
                  );
                },
              )
                  : NoDataScreen(
                title: noDataText ?? 'no_food_available'.tr,
              )
                  : GridView.builder(
                key: UniqueKey(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: Dimensions.paddingSizeLarge,
                  mainAxisSpacing: isWebRestaurant! ? Dimensions.paddingSizeLarge : 0.01,
                  mainAxisExtent: showTheme1Restaurant ? 200 : 280,
                  crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : 3,
                ),
                physics: isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                shrinkWrap: !isScrollable,
                itemCount: shimmerLength,
                padding: padding,
                itemBuilder: (context, index) {
                  return ProductShimmer(
                    isEnabled: isNull,
                    hasDivider: index != shimmerLength - 1,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

