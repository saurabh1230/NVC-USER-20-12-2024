import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class CookedAndUncookedBannerWidget extends StatelessWidget {
  const CookedAndUncookedBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      return Padding(
        padding:  const EdgeInsets.only(left: Dimensions.paddingSizeDefault,right: Dimensions.paddingSizeDefault,bottom: 0,top: Dimensions.paddingSizeDefault),
        child: Row(children: [
          Expanded(
              child: InkWell(
                onTap: () {
                  // Get.find<CategoryController>().getAllProductList(1, true,"cooked");
                  Get.toNamed(RouteHelper.getCookedCategoryProductRoute(
                    categoryController.cat![0].id,
                    "cooked",));
                  },
                child: Column(
                  children: [
                    Container(height: 100,
                        width: Get.size.width,
                        clipBehavior: Clip.hardEdge,
                        decoration :  BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                        child: Image.asset(Images.foodTypeCookedBanner,fit: BoxFit.cover,)),
                    // const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                    // Text('Cooked', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600)),
                  ],
                ),
              )),
          const SizedBox(width: Dimensions.paddingSizeDefault,),
          Expanded(child: InkWell(
            onTap: () {

              // Get.find<CategoryController>().getAllProductList(1, true,"uncooked");
              // Get.find<CategoryController>().getFilCategoryList("1");

              Get.toNamed(RouteHelper.getUnCookedCategoryProductRoute(
                categoryController.unCookedCat![0].id, "uncooked",
              ));
              // Get.find<CategoryController>().getSubCategoryList(categoryController.unCookedCat![0].id.toString());
            },
            child: Column(
              children: [
                Container(
                    height: 100,
                    width: Get.size.width,
                    clipBehavior: Clip.hardEdge,
                    decoration :  BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
                    ),
                    child: Image.asset(Images.foodTypeUncookedBanner,fit: BoxFit.cover,)),
                // const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                // Text('UnCooked', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600)),
              ],
            ),
          )),
        ],),
      );
    });

  }
}
