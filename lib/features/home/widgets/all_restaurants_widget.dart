import 'package:stackfood_multivendor/common/widgets/home_category_product_view.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/home/widgets/restaurants_view_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/common/widgets/paginated_list_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/all_restaurant_screen.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/cooked_uncooked_home_products.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

import 'arrow_icon_button_widget.dart';
import 'home_all_product_view_widget.dart';
// class AllRestaurantsWidget extends StatelessWidget {
//   final ScrollController scrollController;
//   const AllRestaurantsWidget({super.key, required this.scrollController});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<RestaurantController>(builder: (restaurantController) {
//       return PaginatedListViewWidget(
//         scrollController: scrollController,
//         totalSize: restaurantController.restaurantModel?.totalSize,
//         offset: restaurantController.restaurantModel?.offset,
//         onPaginate: (int? offset) async => await restaurantController.getRestaurantList(offset!, false),
//         productView: RestaurantsViewWidget(restaurants: restaurantController.restaurantModel?.restaurants),
//       );
//     });
//   }
// }
//
class AllFoodWidget extends StatelessWidget {
  final ScrollController scrollController;
  final String? categoryName;
  const AllFoodWidget({super.key, required this.scrollController, this.categoryName});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<CategoryController>(builder: (categoryController) {
      return PaginatedListViewWidget(
        scrollController: scrollController,
        totalSize: categoryController.productModel?.totalSize,
        offset: categoryController.productModel?.offset,
        onPaginate: (int? offset) async => await categoryController.getAllProductList(offset!, false,categoryController.mainCategoryType),
        productView: HomeAllProductViewWidget(
          isRestaurant: false,
          products: categoryController.productModel?.products,
          restaurants: null,
          noDataText: 'No Food Found', categoryBanner: '',
        ),
      );
    });
  }
}

class AllRestaurantsWidget extends StatelessWidget {
  final ScrollController scrollController;
  final String? categoryName;
  const AllRestaurantsWidget({super.key, required this.scrollController, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      return PaginatedListViewWidget(
        scrollController: scrollController,
        totalSize: categoryController.productModel?.totalSize,
        offset: categoryController.productModel?.offset,
        onPaginate: (int? offset) async => await categoryController.getCookedProductList(offset!, false,categoryName),
        productView: HomeAllProductViewWidget(
          isRestaurant: false,
          products: categoryController.productModel?.products,
          restaurants: null,
          noDataText: 'No Food Found', categoryBanner: '',
        ),
      );
    });
  }
}

class AllVendorsWidget extends StatelessWidget {
  // final ScrollController scrollController;
  const AllVendorsWidget({super.key, /*required this.scrollController*/});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isMobile(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge),
        child: SizedBox(
          /* height: ResponsiveHelper.isMobile(context) ? 300 : 332, */width: Dimensions.webMaxWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Dimensions.paddingSizeDefault,),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal:ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Top Rated Vendors", style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,color: Colors.black.withOpacity(0.80))),
                          const Spacer(),
                          ArrowIconButtonWidget(
                            onTap: () => Get.toNamed(RouteHelper.getAllRestaurantRoute("all")),
                          ),
                        ],
                      ),
                      // Text("Top Rated Food Items Near You", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.black.withOpacity(0.80))),

                    ],
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault,),
                RestaurantsViewWidget(restaurants: restaurantController.restaurantModel?.restaurants),
                // ResponsiveHelper.isDesktop(context) ?  Padding(
                //   padding: const EdgeInsets.only(bottom: 45),
                //   child: Text('popular_foods_nearby'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                // ): Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeLarge),
                //   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                //     Text('popular_foods_nearby'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                //     ArrowIconButtonWidget(onTap: () => Get.toNamed(RouteHelper.getPopularFoodRoute(true))),
                //   ],
                // )),


              ],
            )
        ),
      );
      // return RestaurantsViewWidget(restaurants: restaurantController.restaurantModel?.restaurants);
      // return PaginatedListViewWidget(
      //   scrollController: scrollController,
      //   totalSize: restaurantController.restaurantModel?.totalSize,
      //   offset: restaurantController.restaurantModel?.offset,
      //   onPaginate: (int? offset) async => await restaurantController.getRestaurantList(offset!, false),
      //   productView: RestaurantsViewWidget(restaurants: restaurantController.restaurantModel?.restaurants),
      // );
    });
  }
}


class AllUncookedVendorsWidget extends StatelessWidget {
  const AllUncookedVendorsWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    Get.find<CategoryController>().getUncookedRestaurantList(1, "2", false,);
    return GetBuilder<CategoryController>(builder: (restaurantController) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isMobile(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge),
        child: SizedBox(
          /* height: ResponsiveHelper.isMobile(context) ? 300 : 332, */ width: Dimensions.webMaxWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Dimensions.paddingSizeDefault,),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal:ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Popular Shop & Vendors", style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,color: Colors.black.withOpacity(0.80))),
                          const Spacer(),
                          ArrowIconButtonWidget(
                            onTap: () =>
                                // Get.to(const AllRestaurantScreen(isCooked: false, isPopular: false, isRecentlyViewed: false, isOrderAgain: false, isUncooked: true,))
                                Get.toNamed(RouteHelper.getAllRestaurantRoute("isUncooked")),
                          ),
                        ],
                      ),
                      // Text("Top Rated Food Items Near You", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.black.withOpacity(0.80))),

                    ],
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault,),
                HomeCookedUncookedProducts(restaurants: restaurantController.uncookedRestaurantList),
                // ResponsiveHelper.isDesktop(context) ?  Padding(
                //   padding: const EdgeInsets.only(bottom: 45),
                //   child: Text('popular_foods_nearby'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                // ): Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeLarge),
                //   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                //     Text('popular_foods_nearby'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                //     ArrowIconButtonWidget(onTap: () => Get.toNamed(RouteHelper.getPopularFoodRoute(true))),
                //   ],
                // )),


              ],
            )
        ),
      );
      // return RestaurantsViewWidget(restaurants: restaurantController.restaurantModel?.restaurants);
      // return PaginatedListViewWidget(
      //   scrollController: scrollController,
      //   totalSize: restaurantController.restaurantModel?.totalSize,
      //   offset: restaurantController.restaurantModel?.offset,
      //   onPaginate: (int? offset) async => await restaurantController.getRestaurantList(offset!, false),
      //   productView: RestaurantsViewWidget(restaurants: restaurantController.restaurantModel?.restaurants),
      // );
    });
  }
}


class AllCookedVendorsWidget extends StatelessWidget {
  const AllCookedVendorsWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    Get.find<CategoryController>().getFilterRestaurantList(1, "1", false,);
    return GetBuilder<CategoryController>(builder: (restaurantController) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isMobile(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge),
        child: SizedBox(
          /* height: ResponsiveHelper.isMobile(context) ? 300 : 332, */width: Dimensions.webMaxWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Dimensions.paddingSizeDefault,),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal:ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Popular Restaurants & Cloud Kitchen", style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,color: Colors.black.withOpacity(0.80))),
                          const Spacer(),
                          ArrowIconButtonWidget(
                            onTap: () =>
                                // Get.to(const AllRestaurantScreen(isCooked: true, isPopular: false, isRecentlyViewed: false, isOrderAgain: false, isUncooked: false,))
                                Get.toNamed(RouteHelper.getAllRestaurantRoute("isCooked")),
                          ),
                        ],
                      ),
                      // Text("Top Rated Food Items Near You", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.black.withOpacity(0.80))),
                    ],
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault,),
                HomeCookedUncookedProducts(restaurants: restaurantController.categoryRestaurantList),
                // ResponsiveHelper.isDesktop(context) ?  Padding(
                //   padding: const EdgeInsets.only(bottom: 45),
                //   child: Text('popular_foods_nearby'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                // ): Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeLarge),
                //   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                //     Text('popular_foods_nearby'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                //     ArrowIconButtonWidget(onTap: () => Get.toNamed(RouteHelper.getPopularFoodRoute(true))),
                //   ],
                // )),


              ],
            )
        ),
      );
      // return RestaurantsViewWidget(restaurants: restaurantController.restaurantModel?.restaurants);
      // return PaginatedListViewWidget(
      //   scrollController: scrollController,
      //   totalSize: restaurantController.restaurantModel?.totalSize,
      //   offset: restaurantController.restaurantModel?.offset,
      //   onPaginate: (int? offset) async => await restaurantController.getRestaurantList(offset!, false),
      //   productView: RestaurantsViewWidget(restaurants: restaurantController.restaurantModel?.restaurants),
      // );
    });
  }
}