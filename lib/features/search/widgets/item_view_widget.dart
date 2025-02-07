import 'package:non_veg_city/features/restaurant/controllers/restaurant_controller.dart';
import 'package:non_veg_city/features/restaurant/screens/restaurant_horizontal_view_widget.dart';

import 'package:non_veg_city/features/search/controllers/search_controller.dart' as search;
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/common/widgets/footer_view_widget.dart';
import 'package:non_veg_city/common/widgets/product_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemViewWidget extends StatelessWidget {
  final bool isRestaurant;
  const ItemViewWidget({super.key, required this.isRestaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<search.SearchController>(builder: (searchController) {
        return SingleChildScrollView(
          child: FooterViewWidget(
            child: Center(child: SizedBox(width: Dimensions.webMaxWidth, child: ProductViewWidget(
              isRestaurant: isRestaurant, products: searchController.searchProductList, restaurants: searchController.searchRestList,
            ))),
          ),
        );
      }),
    );
  }
}


class ItemRestaurantViewWidget extends StatelessWidget {
  final bool isRestaurant;
  const ItemRestaurantViewWidget({super.key, required this.isRestaurant});

  @override
  Widget build(BuildContext context) {
    Get.find<RestaurantController>().clearRestaurantParticularProductList();
    return Scaffold(
      body: GetBuilder<search.SearchController>(builder: (searchController) {
        return SingleChildScrollView(
          child: FooterViewWidget(
            child: Center(child:
            Container(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                width: Dimensions.webMaxWidth,
                child: RestaurantsViewHorizontalWidget(
                  /*isRestaurant: isRestaurant,*/ products: searchController.searchProductList, restaurants: searchController.searchRestList, categoryName: '', categoryId: '',
                ))),
          ),
        );
      }),
    );
  }
}
