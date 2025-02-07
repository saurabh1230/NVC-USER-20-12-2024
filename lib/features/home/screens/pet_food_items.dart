import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:non_veg_city/features/category/controllers/category_controller.dart';
import 'package:non_veg_city/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:non_veg_city/features/home/widgets/item_card_widget.dart';
import 'package:non_veg_city/helper/route_helper.dart';

import '../../../common/models/product_model.dart';
import '../../../common/models/restaurant_model.dart';
import '../../../helper/responsive_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../language/controllers/localization_controller.dart';

class PetFoodItems extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  final String categoryBanner;
  final String heading;

  const PetFoodItems({
    super.key,
    required this.categoryID,
    required this.categoryName, required this.categoryBanner, required this.heading,
  });

  @override
  State<PetFoodItems> createState() => _PetFoodItemsState();
}

class _PetFoodItemsState extends State<PetFoodItems> {

  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().getPetFoodProductList("69",1, '',false);

  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<CategoryController>(
      builder: (catController) {
        List<Product>? products;
        List<Restaurant>? restaurants;
        if(catController.petFoodList != null && catController.searchProductList != null) {
          products = [];
          if (catController.isSearching) {
            products.addAll(catController.searchProductList!);
          } else {
            products.addAll(catController.petFoodList!);
          }
        }
        if(catController.categoryRestaurantList != null && catController.searchRestaurantList != null) {
          restaurants = [];
          if (catController.isSearching) {
            restaurants.addAll(catController.searchRestaurantList!);
          } else {
            restaurants.addAll(catController.categoryRestaurantList!);
          }
        }
        return Padding(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isMobile(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeExtraLarge,
              horizontal: ResponsiveHelper.isMobile(context)  ? Dimensions.paddingSizeDefault : 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Dimensions.paddingSizeDefault,),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal:ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nvc Pet Food", style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,color: Colors.black.withOpacity(0.80))),
                        // Text("Farm Fresh Meat At Your Door", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.black.withOpacity(0.80))),

                      ],
                    ),
                    const Spacer(),
                    ArrowIconButtonWidget(
                      onTap: () => Get.toNamed(
                          RouteHelper.getCategoryProductRoute(
                            69,
                            "Nvc Pet Food",

                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault,),
              // ParticularCategoryViewWidget(
              //   isRestaurant: false,
              //   products: products,
              //   restaurants: null,
              //   noDataText: 'no_category_food_found'.tr, categoryBanner: widget.categoryBanner,
              // ),
              catController.petFoodList !=null ? SizedBox(
                height: ResponsiveHelper.isMobile(context) ? 265 : 280,
                child: ListView.builder(
                  itemCount: products!.length > 8 ? 8 : products.length,
                  padding: EdgeInsets.only(right: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(left: (ResponsiveHelper.isDesktop(context) && index == 0 && Get.find<LocalizationController>().isLtr) ? 0 : Dimensions.paddingSizeDefault),
                      child: ItemCardWidget(
                        isBestItem: false, product: products![index],
                      ),
                    );
                  },
                ),
              ) : const ItemCardShimmer(isPopularNearbyItem: false),
            ],
          ),
        );
      },
    );
  }
}
