import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/paginated_list_view_widget.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/home/screens/home_all_product_widget.dart';

class MainProductViewWidget extends StatelessWidget {
  // final ProductModel productModel;
  // final ScrollController scrollController;
   MainProductViewWidget({super.key,  /*required this.scrollController*/});

  final ScrollController _scrollController = ScrollController();
  

  @override
  Widget build(BuildContext context) {
    Get.find<CategoryController>().getCookedProductList(1, false, "cooked");
    return Scaffold(
      appBar: const CustomAppBarWidget(title: "Cooked Items"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GetBuilder<CategoryController>(builder: (cookedController) {
              return PaginatedListViewWidget(
                scrollController: _scrollController,
                totalSize: cookedController.cookedList!.totalSize,
                offset: cookedController.cookedList!.offset,
                onPaginate: (int? offset) async => await cookedController.getCookedProductList(offset!, false,"cooked"),
                productView: HomeAllProductViewWidget(
                  isRestaurant: false,
                  products: cookedController.cookedList?.products,
                  restaurants: null,
                  noDataText: 'No Food Found', categoryBanner: '',
                ),
                // RestaurantsViewWidget(restaurants: restaurantController.restaurantModel?.restaurants),
              );
            }),
          ],
        ),
      ),
    );
  }
}
