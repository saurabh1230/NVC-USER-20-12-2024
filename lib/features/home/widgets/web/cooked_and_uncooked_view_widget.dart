import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_shimmer.dart';
import 'package:stackfood_multivendor/common/widgets/hover_widgets/hover_zoom_widget.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/helper/responsive.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';

import '../../../../common/widgets/custom_button_widget.dart';

class CookedAndUnCookedView extends StatefulWidget {
  const CookedAndUnCookedView({super.key});

  @override
  State<CookedAndUnCookedView> createState() => _CookedAndUnCookedViewState();
}

class _CookedAndUnCookedViewState extends State<CookedAndUnCookedView> {

  // @override
  // void initState() {
  //   Get.find<CategoryController>().getFilCategoryList("1");
  //   Get.find<CategoryController>().getFilUncookedCategoryList("2");
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<CategoryController>(builder: (catController) {
      return   Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isTab(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeDefault),
        child: /* catController.cat != null ?*/
        Row(
          children: [

            Expanded(
              child: InkWell(highlightColor: Colors.transparent, // Remove the highlight color
                splashColor: Colors.transparent, // Remove the splash color
                hoverColor: Colors.transparent, // Re
                onTap: ()
                {Get.toNamed(RouteHelper.getCookedUnCookedCategoryProductRoute(
                          0, "cooked",));
                Get.find<RestaurantController>().clearRestaurantParticularProductList();
                        // Get.find<CategoryController>().getSubCategoryList(catController.cat![0].id.toString());
                        // Get.find<CategoryController>().getFilCategoryList("1");
                      },
                child: HoverZoom(
                  child: Column(
                    children: [
                      Container(clipBehavior: Clip.hardEdge,
                        height:  Responsive.isMobile(context) ?
                        130 : 250,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            image: const DecorationImage(image: AssetImage(Images.cookedCategoryBanner),fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(Dimensions.radiusLarge)
                        ),),
                      // const SizedBox(height: Dimensions.paddingSizeDefault,),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: Theme.of(context).primaryColor.withOpacity(0.1),
                      //     borderRadius: BorderRadius.circular(12)
                      //   ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 14),
                      //       child: Text("Cooked", style: robotoLight.copyWith(fontSize: Dimensions.fontSizeExtraLarge,color:Theme.of(context).primaryColor)),
                      //     )),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15,),
            Expanded(
              child: InkWell(highlightColor: Colors.transparent, // Remove the highlight color
                splashColor: Colors.transparent, // Remove the splash color
                hoverColor: Colors.transparent, // Remove the highlight color
                onTap: ()  {
                // String id = catController.unCookedCat![0].id.toString();
                  // Get.find<CategoryController>().getFilCategoryList("2");
                Get.toNamed(RouteHelper.getUnCookedCategoryProductRoute(
                0, "uncooked",
                ));
                Get.find<RestaurantController>().clearRestaurantParticularProductList();
                // Get.find<CategoryController>().getSubCategoryList(catController.unCookedCat![0].id.toString());

                },
                child: Column(
                  children: [
                    HoverZoom(
                      child: Container(clipBehavior: Clip.hardEdge,
                        height:   Responsive.isMobile(context) ?
                        130 : 250,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            image: const DecorationImage(image: AssetImage(Images.uncookedCategoryBanner),fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(Dimensions.radiusLarge)
                        ),
                      ),
                    ),
                    // const SizedBox(height: Dimensions.paddingSizeDefault,),
                    // Container(
                    //     decoration: BoxDecoration(
                    //         color: Theme.of(context).primaryColor.withOpacity(0.1),
                    //         borderRadius: BorderRadius.circular(12)
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 14),
                    //       child: Text("Uncooked", style: robotoLight.copyWith(fontSize: Dimensions.fontSizeExtraLarge,color:Theme.of(context).primaryColor)),
                    //     )),
                  ],
                ),
              ),
            ),
          ],
        )
        //     :
        // Row(
        //   children: [
        //     Expanded(
        //       child: Container(
        //         height:  Responsive.isLargeMobile(context) ?  150 :200,
        //         width: Get.size.width,
        //         clipBehavior: Clip.hardEdge,
        //         decoration: BoxDecoration(
        //           color: Colors.grey[300],
        //           borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        //         ),
        //
        //       ),
        //     ),
        //     const SizedBox(width: 15,),
        //     Expanded(
        //       child: Container(
        //         height:  Responsive.isLargeMobile(context) ?  150 :200,
        //         width: Get.size.width,
        //         clipBehavior: Clip.hardEdge,
        //         decoration: BoxDecoration(
        //           color: Colors.grey[300],
        //           borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      );
    });
  }
}