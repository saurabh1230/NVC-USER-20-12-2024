import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/paginated_list_view_widget.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/home/screens/home_all_product_widget.dart';

class UNCookedProductViewWidget extends StatelessWidget {
  // final ProductModel productModel;
  // final ScrollController scrollController;
  UNCookedProductViewWidget({super.key,  /*required this.scrollController*/});

  final ScrollController _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    Get.find<CategoryController>().getUnCookedProductList(1, false, "uncooked");
    return Scaffold(
      appBar: const CustomAppBarWidget(title: "UnCooked Items"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GetBuilder<CategoryController>(builder: (cookedController) {
              return PaginatedListViewWidget(
                scrollController: _scrollController,
                totalSize: cookedController.uncooked!.totalSize,
                offset: cookedController.uncooked!.offset,
                onPaginate: (int? offset) async => await cookedController.getCookedProductList(offset!, false,""),
                productView: HomeAllProductViewWidget(
                  isRestaurant: false,
                  products: cookedController.uncooked?.products,
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
