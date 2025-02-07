import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:non_veg_city/common/widgets/confirmation_dialog_widget.dart';
import 'package:non_veg_city/common/widgets/custom_snackbar_widget.dart';
import 'package:non_veg_city/common/widgets/hover_widgets/hover_zoom_widget.dart';
import 'package:non_veg_city/features/category/controllers/category_controller.dart';
import 'package:non_veg_city/features/restaurant/controllers/restaurant_controller.dart';
import 'package:non_veg_city/helper/responsive.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';

import '../../../util/images.dart';
import '../../../util/styles.dart';

class PetFoodAndMasalaParticle extends StatelessWidget {
  const PetFoodAndMasalaParticle({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      return  Padding(
        padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                highlightColor: Colors.transparent, // Remove the highlight color
                splashColor: Colors.transparent, // Remove the splash color
                hoverColor: Colors.transparent,
                onTap: () {
                  // categoryController.selectCategory(89);
                  Get.find<RestaurantController>().clearRestaurantParticularProductList();
                  categoryController.getCategoryRestaurantList(89.toString(), 1, '', true,);

                  categoryController.categoryName = 'Pet Food';
                  categoryController.categoryId = 89.toString();
                  Get.toNamed(RouteHelper.getPetFoodProductRoute(89 ,"Pet Food & Bakery"));
                  categoryController.getCategoryRestaurantList(
                    89.toString(), 1, '', true,
                  );
                },
                child: HoverZoom(
                  child: Column(
                    children: [
                      Container( height:  Responsive.isLargeMobile(context) ?  130 : 250,
                          width: Get.size.width,
                          clipBehavior: Clip.hardEdge,
                          decoration :  BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                          child: Image.asset(Images.petFoodParticleImage,fit: BoxFit.cover,)),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                      Text("NVC Pet Food & Bakery!", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault,),
            Expanded(
              child: InkWell(
                highlightColor: Colors.transparent, // Remove the highlight color
                splashColor: Colors.transparent, // Remove the splash color
                hoverColor: Colors.transparent,
                onTap: () {
                  Get.find<RestaurantController>().clearRestaurantParticularProductList();
                  categoryController.getCategoryRestaurantList(91.toString(), 1, '', true,);
                  categoryController.categoryName = 'Nvc Masala';
                  categoryController.categoryId = 91.toString();
                  Get.toNamed(RouteHelper.getPetFoodProductRoute(91 ,"Nvc Masala"));
                  // showCustomSnackBar('NVC Masala & Pickle Coming Soon!',isError: false);
                },
                child: HoverZoom(
                  child: Column(
                    children: [
                      Container(height:  Responsive.isLargeMobile(context) ?  130 : 250,
                          width: Get.size.width,
                          clipBehavior: Clip.hardEdge,
                          decoration :  BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                          child: Image.asset(Images.masalaParticleImage,fit: BoxFit.cover,)),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                      Text("NVC Masala & Pickles", textAlign: TextAlign.center,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });

  }
}
