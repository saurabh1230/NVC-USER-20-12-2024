import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/particular_category_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/category/screens/home_food_type_products.dart';
import 'package:stackfood_multivendor/features/home/screens/home_category_products.dart';
import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';

import '../../../common/models/product_model.dart';
import '../../../common/widgets/home_category_product_view.dart';
import '../../../common/widgets/home_product_widget.dart';
import '../../../helper/responsive_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';

class ParticularUnCookedCategoryWidget extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  final String categoryBanner;
  final String heading;
  // final bool isCooked;

  const ParticularUnCookedCategoryWidget({
    Key? key,
    required this.categoryID,
    required this.categoryName,
    required this.categoryBanner,
    required this.heading,
    // required this.isCooked,
  }) : super(key: key);

  @override
  State<ParticularUnCookedCategoryWidget> createState() => _ParticularUnCookedCategoryWidgetState();
}

class _ParticularUnCookedCategoryWidgetState extends State<ParticularUnCookedCategoryWidget> {

  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().getPopularCookedTypeProducts(1,false, widget.categoryName);
    // Get.find<CategoryController>().getAllCookedProducts(1, widget.categoryName);
  }


  @override
  Widget build(BuildContext context) {

    return GetBuilder<CategoryController>(
      builder: (catController) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isMobile(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeExtraLarge,
              horizontal: Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Dimensions.paddingSizeDefault,),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal:ResponsiveHelper.isMobile(context) ? 0 : 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Trending Cooked", style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,color: Colors.black.withOpacity(0.80))),
                        Text("Hot and Fresh Food At Your Door", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.black.withOpacity(0.75))),
                      ],
                    ),
                    // const Spacer(),
                    ArrowIconButtonWidget(
                        onTap: () {
                          Get.toNamed(RouteHelper.getCookedUnCookedCategoryProductRoute(
                            catController.cookedProducts!.products![0].id,
                                "cooked",
                              ));
                        }
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault,),
              HomeFoodTypeProducts(
                isCooked: true,
                isRestaurant: false,
                products: catController.cookedProducts?.products ?? [],
                restaurants: null,
                noDataText: 'no_category_food_found'.tr,
                categoryBanner: widget.categoryBanner,
              ),
              // const SizedBox(height: Dimensions.paddingSizeLarge,),
              // ),
              // ParticularCategoryViewWidget(
              //   isCooked: false,
              //   isRestaurant: false,
              //   products: catController.cookedModel,
              //   restaurants: null,
              //   noDataText: 'no_category_food_found'.tr,
              //   categoryBanner: widget.categoryBanner,
              // ),
              // HomeCategoryProduct(
              //   isCooked: true,
              //   // isRestaurant: false,
              //   products: catController.cookedModel,
              //   // restaurants: null,
              //   noDataText: 'no_category_food_found'.tr, categoryBanner: widget.categoryBanner,),
              // ParticularCategoryViewWidget(
              //   isCooked: true,
              //   isRestaurant: false,
              //   products: catController.cookedModel,
              //   restaurants: null,
              //   noDataText: 'no_category_food_found'.tr, categoryBanner: widget.categoryBanner,
              // ),
            ],
          ),
        );
      },
    );
  }
}
