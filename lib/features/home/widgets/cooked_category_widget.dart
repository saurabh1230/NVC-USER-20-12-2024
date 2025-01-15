import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';

import '../../../common/models/product_model.dart';
import '../../../common/widgets/home_category_product_view.dart';
import '../../../helper/responsive_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';

class CookedCategoryWidget extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  final String categoryBanner;

  const CookedCategoryWidget({
    Key? key,
    required this.categoryID,
    required this.categoryName, required this.categoryBanner,
  }) : super(key: key);

  @override
  State<CookedCategoryWidget> createState() => _CookedCategoryWidgetState();
}

class _CookedCategoryWidgetState extends State<CookedCategoryWidget> {

  @override
  void initState() {
    super.initState();

    // _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    Get.find<CategoryController>().getSubCategoryList("7");
    // scrollController.addListener(() {
    if (
    Get.find<CategoryController>().categoryProductList != null
        && !Get.find<CategoryController>().isLoading) {
      int pageSize = (Get.find<CategoryController>().pageSize! / 10).ceil();
      if (Get.find<CategoryController>().offset < pageSize) {
        debugPrint('end of the page');
        Get.find<CategoryController>().showBottomLoader();
        Get.find<CategoryController>().getCategoryProductList(
          Get.find<CategoryController>().subCategoryIndex == 0 ? "7"
              : Get.find<CategoryController>().subCategoryList![Get.find<CategoryController>().subCategoryIndex].id.toString(),
          Get.find<CategoryController>().offset+1, Get.find<CategoryController>().type, false,
        );
      }
    }
    // });

  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<CategoryController>(
      builder: (catController) {
        List<Product>? products;
        // products?.addAll(catController.categoryProductList ?? []);
        // products = [];
        // products.addAll(catController.searchProductList ?? []);
        // products.addAll(catController.categoryProductList ?? []);


        if (catController.categoryProductList != null ) {
          products = [];
          products.addAll(catController.categoryProductList!);
          /*if (catController.isSearching) {
            products.addAll(catController.searchProductList ?? []);
          } else {
            products.addAll(catController.categoryProductList!);
          }*/
        }

        return Padding(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isMobile(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeExtraLarge),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Trendy UnCooked Items'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).primaryColor)),

              HomeProductViewWidget(
                isRestaurant: false,
                products: products,
                restaurants: null,
                noDataText: 'no_category_food_found'.tr, categoryBanner: widget.categoryBanner,
              ),
            ],
          ),
        );
      },
    );
  }
}
