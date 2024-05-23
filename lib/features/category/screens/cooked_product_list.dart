import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/paginated_list_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/category/screens/cooked_product_widget.dart';

import '../../search/widgets/item_view_widget.dart';

class CookedProductScreen extends StatelessWidget {
  final String? number;
   CookedProductScreen({super.key, required this.number});
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent
          && Get.find<CategoryController>().productModel != null
          && !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().productModel!.totalSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          debugPrint('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getAllProductList(
            Get.find<CategoryController>().offset+1,true,number.toString()
          );
        }
      }
    });

    return  Scaffold(
      appBar:  CustomAppBarWidget(title: capitalizeFirst(number!)),
      body:  SingleChildScrollView(
        child: GetBuilder<CategoryController>(builder: (catController) {
          return ProductViewWidget(
            isScrollable: false,
            isRestaurant: false, products: catController.productModel?.products, restaurants: null, noDataText: 'no_category_food_found'.tr,
          );
        }),

        // child: CookedProductViewWidget(scrollController: _scrollController, cookedUncookedType: number.toString(),),
      )

    );
  }
  String capitalizeFirst(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
