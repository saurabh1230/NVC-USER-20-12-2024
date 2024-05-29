import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/features/search/controllers/search_controller.dart' as search;
import 'package:stackfood_multivendor/features/search/widgets/custom_check_box_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FilterWidget extends StatelessWidget {
  final double? maxValue;
  final bool isRestaurant;
  const FilterWidget({super.key, required this.maxValue, required this.isRestaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      constraints: BoxConstraints(maxHeight: context.height * 0.7, minHeight: context.height * 0.5),
      decoration: ResponsiveHelper.isMobile(context)
          ? BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusLarge),
          topRight: Radius.circular(Dimensions.radiusLarge),
        ),
      )
          : null,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: GetBuilder<search.SearchController>(builder: (searchController) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(context),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Flexible(
              child: ListView(
                children: [
                  buildFilterOptions(context, searchController),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  if (!isRestaurant) buildPriceFilter(context, searchController),
                ],
              ),
            ),
            const SizedBox(height: 30),
            buildFooter(context, searchController),
          ],
        );
      }),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Icon(Icons.close, color: Theme.of(context).disabledColor),
          ),
        ),
      ],
    );
  }

  Widget buildFilterOptions(BuildContext context, search.SearchController searchController) {
    final SplashController splashController = Get.find<SplashController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('filter_by'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        if (splashController.configModel!.toggle_cooked_uncooked!)
          CustomCheckBoxWidget(
            title: 'Cooked'.tr,
            value: isRestaurant ? searchController.restaurantVeg : searchController.veg,
            onClick: () {
              if (isRestaurant) {
                searchController.toggleResVeg();
              } else {
                searchController.toggleVeg();
              }
            },
          ),
        if (splashController.configModel!.toggle_cooked_uncooked!)
          CustomCheckBoxWidget(
            title: 'Uncooked'.tr,
            value: isRestaurant ? searchController.restaurantNonVeg : searchController.nonVeg,
            onClick: () {
              if (isRestaurant) {
                searchController.toggleResNonVeg();
              } else {
                searchController.toggleNonVeg();
              }
            },
          ),
        CustomCheckBoxWidget(
          title: isRestaurant ? 'currently_opened_restaurants'.tr : 'currently_available_foods'.tr,
          value: isRestaurant ? searchController.isAvailableRestaurant : searchController.isAvailableFoods,
          onClick: () {
            if (isRestaurant) {
              searchController.toggleAvailableRestaurant();
            } else {
              searchController.toggleAvailableFoods();
            }
          },
        ),
        CustomCheckBoxWidget(
          title: isRestaurant ? 'discounted_restaurants'.tr : 'discounted_foods'.tr,
          value: isRestaurant ? searchController.isDiscountedRestaurant : searchController.isDiscountedFoods,
          onClick: () {
            if (isRestaurant) {
              searchController.toggleDiscountedRestaurant();
            } else {
              searchController.toggleDiscountedFoods();
            }
          },
        ),
      ],
    );
  }
  Widget buildPriceFilter(BuildContext context, search.SearchController searchController) {
    final List<RangeValues> predefinedRanges = [
      const RangeValues(0, 100),
      const RangeValues(100, 200),
      const RangeValues(200, 300),
      const RangeValues(300, 400),
      const RangeValues(400, 500),
      const RangeValues(500, 600),
      const RangeValues(600, 2000),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('price'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
        Wrap(
          spacing: 6.0,
          runSpacing: 4.0,
          children: predefinedRanges.map((range) {
            return ActionChip(
              backgroundColor: Theme.of(context).primaryColor,
              label: Text(
                '${range.start.toInt()}-${range.end.toInt()}',
                style: robotoMedium.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
              ),
              shape: const StadiumBorder(
                side: BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
              ),
              onPressed: () {
                searchController.setLowerAndUpperValue(range.start, range.end);
              },
            );
          }).toList(),
        ),
        RangeSlider(
          values:  RangeValues(
          searchController.lowerValue.clamp(0, maxValue!.toDouble()), // Ensure lowerValue is within bounds
    searchController.upperValue.clamp(0, maxValue!.toDouble()), // Ensure upperValue is within bounds
    ),
          max: maxValue!.toInt().toDouble(),
          min: 0,
          divisions: maxValue!.toInt(),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: Theme.of(context).primaryColor.withOpacity(0.3),
          labels: RangeLabels(
            searchController.lowerValue.toStringAsFixed(1),
            searchController.upperValue.toStringAsFixed(1),
          ),
          onChanged: (RangeValues rangeValues) {
            searchController.setLowerAndUpperValue(rangeValues.start, rangeValues.end);
          },
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),
      ],
    );
  }

  // Widget buildPriceFilter(BuildContext context, search.SearchController searchController) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('price'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
  //
  //       CustomButtonWidget(
  //           buttonText: "0-100",
  //           width: 80,height: 30,
  //           onPressed: () {
  //             searchController.setLowerAndUpperValue(0, 100);
  //           },
  //       ),
  //       RangeSlider(
  //         values: RangeValues(searchController.lowerValue, searchController.upperValue),
  //         max: maxValue!.toInt().toDouble(),
  //         min: 0,
  //         divisions: maxValue!.toInt(),
  //         activeColor: Theme.of(context).primaryColor,
  //         inactiveColor: Theme.of(context).primaryColor.withOpacity(0.3),
  //         labels: RangeLabels(
  //             searchController.lowerValue.toStringAsFixed(1),
  //             searchController.upperValue.toStringAsFixed(1)
  //         ),
  //         onChanged: (RangeValues rangeValues) {
  //           searchController.setLowerAndUpperValue(rangeValues.start, rangeValues.end);
  //         },
  //       ),
  //       const SizedBox(height: Dimensions.paddingSizeLarge),
  //     ],
  //   );
  // }

  Widget buildFooter(BuildContext context, search.SearchController searchController) {
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: CustomButtonWidget(
              color: Theme.of(context).disabledColor.withOpacity(0.5),
              textColor: Theme.of(context).textTheme.bodyLarge!.color,
              onPressed: () {
                if (isRestaurant) {
                  searchController.resetRestaurantFilter();
                } else {
                  searchController.resetFilter();
                }
              },
              buttonText: 'reset'.tr,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
            flex: 2,
            child: CustomButtonWidget(
              buttonText: 'apply'.tr,
              onPressed: () {
                if (isRestaurant) {
                  searchController.sortRestSearchList();
                } else {
                  searchController.sortFoodSearchList();
                }
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }
}
