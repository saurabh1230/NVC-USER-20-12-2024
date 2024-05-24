import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/home/screens/home_all_product_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/restaurants_view_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/common/widgets/paginated_list_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class AllRestaurantsWidget extends StatelessWidget {
  final ScrollController scrollController;
  const AllRestaurantsWidget({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      return PaginatedListViewWidget(
        scrollController: scrollController,
        totalSize: categoryController.productModel?.totalSize,
        offset: categoryController.productModel?.offset,
        onPaginate: (int? offset) async => await categoryController.getAllProductList(offset!, false,""),
        productView: HomeAllProductViewWidget(
          isRestaurant: false,
          products: categoryController.productModel?.products,
          restaurants: null,
          noDataText: 'No Food Found', categoryBanner: '',
        ),
        // RestaurantsViewWidget(restaurants: restaurantController.restaurantModel?.restaurants),
      );
    });
  }
}
