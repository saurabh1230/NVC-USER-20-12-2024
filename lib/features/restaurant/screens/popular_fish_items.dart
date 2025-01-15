import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/particular_category_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/item_card_widget.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';

import '../../../common/models/product_model.dart';
import '../../../common/models/restaurant_model.dart';
import '../../../common/widgets/home_category_product_view.dart';
import '../../../helper/responsive_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../language/controllers/localization_controller.dart';

class PopularFishItems extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  final String categoryBanner;
  final String heading;

  const PopularFishItems({
    Key? key,
    required this.categoryID,
    required this.categoryName, required this.categoryBanner, required this.heading,
  }) : super(key: key);

  @override
  State<PopularFishItems> createState() => _PopularFishItemsState();
}

class _PopularFishItemsState extends State<PopularFishItems> {

  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().getCategoryProductList("14",1, '',false);
    // _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    // Get.find<CategoryController>().getSubCategoryList("12");
    // // scrollController.addListener(() {
    //   if (Get.find<CategoryController>().categoryProductList != null
    //       && !Get.find<CategoryController>().isLoading) {
    //     int pageSize = (Get.find<CategoryController>().pageSize! / 10).ceil();
    //     if (Get.find<CategoryController>().offset < pageSize) {
    //       debugPrint('end of the page');
    //       Get.find<CategoryController>().showBottomLoader();
    //       Get.find<CategoryController>().getAllUncookedProducts( Get.find<CategoryController>().offset+1, true);
    //     }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<CategoryController>(
      builder: (catController) {
        List<Product>? products;
        List<Restaurant>? restaurants;
        if(catController.categoryProductList != null && catController.searchProductList != null) {
          products = [];
          if (catController.isSearching) {
            products.addAll(catController.searchProductList!);
          } else {
            products.addAll(catController.categoryProductList!);
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
              horizontal:ResponsiveHelper.isMobile(context)  ? Dimensions.paddingSizeDefault : 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Dimensions.paddingSizeDefault,),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal:ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Popular Fish Items Nearby", style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,color: Colors.black.withOpacity(0.80))),
                        // Text("Farm Fresh Meat At Your Door", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.black.withOpacity(0.80))),

                      ],
                    ),
                    // const Spacer(),
                    ArrowIconButtonWidget(
                      onTap: () => Get.toNamed(
                          RouteHelper.getCategoryProductRoute(
                            14,
                            "Fish",

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
              catController.categoryProductList !=null ? SizedBox(
                height: ResponsiveHelper.isMobile(context) ? 265 : 280,
                child: ListView.builder(
                  itemCount: products!.length > 8 ? 8 : products.length,
                  // itemCount: products!.length,
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
