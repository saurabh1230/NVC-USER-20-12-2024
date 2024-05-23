import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/paginated_list_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';

class CookedProductViewWidget extends StatelessWidget {
  final ScrollController scrollController;
  final String cookedUncookedType;
  const CookedProductViewWidget({super.key, required this.scrollController, required this.cookedUncookedType});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      return PaginatedListViewWidget(
        scrollController: scrollController,
        totalSize: categoryController.productModel?.totalSize,
        offset: categoryController.productModel?.offset,
        onPaginate: (int? offset) async => await categoryController.getAllProductList(offset!, false,cookedUncookedType),
        productView:    ProductViewWidget(
          isScrollable: false,
          isRestaurant: false, products: categoryController.productModel?.products, restaurants: null, noDataText: 'no_category_food_found'.tr,
        ),

        // RestaurantsViewWidget(restaurants: restaurantController.restaurantModel?.restaurants),
      );
    });
  }
}
