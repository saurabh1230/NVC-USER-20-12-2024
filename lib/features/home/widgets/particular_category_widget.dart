import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:non_veg_city/common/widgets/footer_view_widget.dart';
import 'package:non_veg_city/common/widgets/particular_category_view_widget.dart';
import 'package:non_veg_city/common/widgets/product_view_widget.dart';
import 'package:non_veg_city/features/category/controllers/category_controller.dart';
import 'package:non_veg_city/features/category/screens/home_food_type_products.dart';
import 'package:non_veg_city/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:non_veg_city/helper/route_helper.dart';

import '../../../common/models/product_model.dart';
import '../../../common/widgets/home_category_product_view.dart';
import '../../../helper/responsive_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';

class ParticularCategoryWidget extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  final String categoryBanner;
  final String heading;
  // final bool isCooked;

  const ParticularCategoryWidget({
    Key? key,
    required this.categoryID,
    required this.categoryName,
    required this.categoryBanner,
    required this.heading,
    // required this.isCooked,
  }) : super(key: key);

  @override
  State<ParticularCategoryWidget> createState() => _ParticularCategoryWidgetState();
}

class _ParticularCategoryWidgetState extends State<ParticularCategoryWidget> {

  @override
  void initState() {
    super.initState();
    // Get.find<CategoryController>().getAllUncookedProducts(1, widget.categoryName);


    Get.find<CategoryController>().getPopularUncookedTypeProducts(1,false, widget.categoryName);
    // _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    // Get.find<CategoryController>().getSubCategoryList("12");
    // // scrollController.addListener(() {
    //   if (Get.find<CategoryController>().categoryProductList != null
    //       && !Get.find<CategoryController>().isLoading) {
    //     int pageSize = (Get.find<CategoryController>().pageSize! / 10).ceil();
    //     if (Get.find<CategoryController>().offset < pageSize) {
    //       debugPrint('end of the page');
    //       Get.find<CategoryController>().showBottomLoader();
    //       Get.find<CategoryController>().getAllUncookedProducts( Get.find<CategoryController>().offset+1, true);
    //     }
    //   }
    // });
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
                padding:  EdgeInsets.symmetric(horizontal:ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Trending Uncooked", style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,color: Colors.black.withOpacity(0.80))),
                        Text("Farm Fresh Meat At Your Door", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.black.withOpacity(0.75))),
                      ],
                    ),
                    // const Spacer(),
                    ArrowIconButtonWidget(
                      onTap: () {
                        Get.toNamed(RouteHelper.getUnCookedCategoryProductRoute(
                          catController.uncookedProducts!.products![0].id, "uncooked",
                        ));
                      }
                      //     Get.toNamed(RouteHelper.getUnCookedCategoryProductRoute(
                      //   1, "uncooked",
                      // )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault,),

              // const SizedBox(height: Dimensions.paddingSizeLarge,),
              // ParticularCategoryViewWidget(
              //   isRestaurant: false,
              //   products: catController.uncookedModel,
              //   restaurants: null,
              //   noDataText: 'no_category_food_found'.tr, categoryBanner: widget.categoryBanner,
              // ),
              HomeFoodTypeProducts(
                isCooked: false,
                isRestaurant: false,
                products: catController.uncookedProducts?.products ?? [],
                restaurants: null,
                noDataText: 'no_category_food_found'.tr,
                categoryBanner: widget.categoryBanner,
              ),



            ],
          ),
        );
      },
    );
  }
}
