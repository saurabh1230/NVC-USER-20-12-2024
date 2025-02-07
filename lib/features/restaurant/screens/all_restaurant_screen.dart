import 'package:non_veg_city/common/models/response_model.dart';
import 'package:non_veg_city/common/models/restaurant_model.dart';
import 'package:non_veg_city/common/widgets/paginated_list_view_widget.dart';
import 'package:non_veg_city/features/category/controllers/category_controller.dart';
import 'package:non_veg_city/features/restaurant/controllers/restaurant_controller.dart';
import 'package:non_veg_city/util/app_constants.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/common/widgets/custom_app_bar_widget.dart';
import 'package:non_veg_city/common/widgets/footer_view_widget.dart';
import 'package:non_veg_city/common/widgets/menu_drawer_widget.dart';
import 'package:non_veg_city/common/widgets/product_view_widget.dart';
import 'package:non_veg_city/common/widgets/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/widgets/restaurants_view_widget.dart';

class AllRestaurantScreen extends StatefulWidget {
  final bool isPopular;
  final bool isRecentlyViewed;
  final bool isOrderAgain;
  final bool isCooked;
  final bool isUncooked;

  const AllRestaurantScreen({super.key, required this.isPopular, required this.isRecentlyViewed, required this.isOrderAgain, required this.isCooked, required this.isUncooked, });

  @override
  State<AllRestaurantScreen> createState() => _AllRestaurantScreenState();
}

class _AllRestaurantScreenState extends State<AllRestaurantScreen> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    if(widget.isPopular) {
      print('isPopular');
      Get.find<RestaurantController>().getPopularRestaurantList(false, 'all', false);
    }else if(widget.isRecentlyViewed){
      print('isRecentlyViewed');
      Get.find<RestaurantController>().getRecentlyViewedRestaurantList(false, 'all', false);
    } else if(widget.isOrderAgain) {
      print('isOrderAgain');
      Get.find<RestaurantController>().getOrderAgainRestaurantList(false);
    }  else if(widget.isCooked) {
      print('isCooked');
      Get.find<CategoryController>().getFilterRestaurantList(1, "1", false,);
    } else if(widget.isUncooked) {
      print('isUncooked');
      Get.find<CategoryController>().getUncookedRestaurantList(1, "2", false,);
    }else{
      print('check else');
      Get.find<RestaurantController>().getLatestRestaurantList(false, 'uncooked', false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<CategoryController>(builder: (categoryController) {
      return   GetBuilder<RestaurantController>(
          builder: (restController) {
            return Scaffold(
              appBar: CustomAppBarWidget(
                title: widget.isPopular ? 'popular_restaurants'.tr : widget.isRecentlyViewed
                    ? 'recently_viewed_restaurants'.tr : widget.isOrderAgain ? 'order_again'.tr
                    : '${'new_on'.tr} ${AppConstants.appName}',
                type: restController.type,
                onVegFilterTap: widget.isOrderAgain ? null : (String type) {
                  if(widget.isPopular) {
                    restController.getPopularRestaurantList(true, type, true);
                  }else {
                    if(widget.isRecentlyViewed){
                      restController.getRecentlyViewedRestaurantList(true, type, true);
                    }else{
                      restController.getLatestRestaurantList(true, type, true);
                    }
                  }
                },
              ),
              endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
              body: RefreshIndicator(
                onRefresh: () async {
                  if(widget.isPopular) {
                    await Get.find<RestaurantController>().getPopularRestaurantList(
                      true, Get.find<RestaurantController>().type, false,
                    );
                  } else if(widget.isRecentlyViewed){
                    Get.find<RestaurantController>().getRecentlyViewedRestaurantList(true, Get.find<RestaurantController>().type, false);
                  } else if(widget.isOrderAgain) {
                    Get.find<RestaurantController>().getOrderAgainRestaurantList(false);
                  } else{
                    await Get.find<RestaurantController>().getLatestRestaurantList(true, Get.find<RestaurantController>().type, false);
                  }
                },
                child: Scrollbar(controller: scrollController, child: SingleChildScrollView(controller: scrollController, child: FooterViewWidget(
                  child: Column(
                    children: [
                      WebScreenTitleWidget(title: 'All Vendors & Restaurants',tap: () {
                        Get.back();
                      },),
                      const SizedBox(height: Dimensions.paddingSizeDefault,),

                      GetBuilder<RestaurantController>(builder: (restaurantController) {
                        return PaginatedListViewWidget(
                          scrollController: scrollController,
                          totalSize: widget.isUncooked ? categoryController.unCookedPageSize :  restaurantController.restaurantModel?.totalSize,
                          offset: widget.isUncooked ? categoryController.uncookedoffSet : restaurantController.restaurantModel?.offset,
                          onPaginate: (int? offset) async =>  widget.isUncooked ? categoryController.getUncookedRestaurantList(offset!, "2", false,) : await restaurantController.getRestaurantList(offset!, false),
                          productView: RestaurantsViewWidget(
                              restaurants: widget.isUncooked ? categoryController.uncookedRestaurantList : restaurantController.restaurantModel?.restaurants),
                        );
                        // return PaginatedListViewWidget(
                        //   scrollController: scrollController,
                        //   totalSize: restaurantController.restaurantModel?.totalSize,
                        //   offset: restaurantController.restaurantModel?.offset,
                        //   onPaginate: (int? offset) async => await restaurantController.getRestaurantList(offset!, false),
                        //   productView: RestaurantsViewWidget(isAll: true,
                        //       restaurants: restaurantController.restaurantModel?.restaurants),
                        // );
                      }),
                    ],
                  ),
                ))),
              ),
            );
          }
      );

    });




  }
}
