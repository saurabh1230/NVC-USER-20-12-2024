import 'package:flutter/widgets.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
class RestaurantViewAllCategoryProducts extends StatelessWidget {
  final Restaurant? restaurant;
  final String slug;
  final Product? product;
  final String categoryName;
  final String categoryID;

  const RestaurantViewAllCategoryProducts({
    Key? key,
    required this.restaurant,
    this.slug = '',
    required this.product,
    required this.categoryName,
    required this.categoryID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<RestaurantController>().getRestaurantParticularProductList(
      restaurant!.id ?? Get.find<RestaurantController>().restaurant!.id!,
      1,
      int.parse(categoryID),
      'all',
      false,
    );

    return Scaffold(
      appBar: CustomAppBarWidget(title: "All $categoryName Items"),
      body: GetBuilder<RestaurantController>(builder: (restController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
              child: Text(
                'Looking For "$categoryName" (${restController.categoryRestaurantProductList != null ? restController.categoryRestaurantProductList!.length : 0})',
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
            ),
            Expanded(
                child:
                SingleChildScrollView(
                  child: ProductViewWidget(
                    isRestaurant: false,
                    restaurants: null,
                    products: restController.categoryRestaurantProductList,
                    inRestaurantPage: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeSmall,
                      vertical: Dimensions.paddingSizeLarge,
                    ),
                  ),
                ),
            ),
          ],
        );
      }),

    );
  }
}
