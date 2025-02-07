import 'package:non_veg_city/features/category/controllers/category_controller.dart';
import 'package:non_veg_city/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:non_veg_city/features/home/widgets/item_card_widget.dart';
import 'package:non_veg_city/features/language/controllers/localization_controller.dart';
import 'package:non_veg_city/features/review/controllers/review_controller.dart';
import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/styles.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CookedParticleViewWidget extends StatelessWidget {
  final bool isPopular;
  const CookedParticleViewWidget({super.key, required this.isPopular});

  @override
  Widget build(BuildContext context) {
    // Get.find<CategoryController>().getAllCookedProducts(1, 'cooked');
    Get.find<CategoryController>().getPopularCookedTypeProducts(1,false, 'cooked');
    return GetBuilder<CategoryController>(builder: (catController) {
      return  Padding(
        padding:  EdgeInsets.symmetric(vertical: ResponsiveHelper.isMobile(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge),
        child: SizedBox(
          height: ResponsiveHelper.isMobile(context) ? 315 : 315, width: Dimensions.webMaxWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
              child: Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Trending Cooked Items', style: robotoMedium.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
                    Text("Hot And Fresh Food At Your Doorstep", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.black.withOpacity(0.75))),
                  ],
                ),

                const Spacer(),

                ArrowIconButtonWidget(
                  onTap: () {
                    // Get.find<CategoryController>().getAllProductList(1, true,"cooked");
                    Get.toNamed(
                        RouteHelper.getCookedUnCookedCategoryProductRoute(
                          catController.cookedProducts!.products![0].id,
                          "cooked",
                        ));

                  },
                ),
              ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),


            catController.cookedProducts !=null ? Expanded(
              child: SizedBox(
                height: ResponsiveHelper.isMobile(context) ? 250 : 255,
                child: ListView.builder(
                  itemCount: catController.cookedProducts!.products!.length > 8 ? 8 : catController.cookedProducts!.products!.length,
                  // itemCount:   cookedController.cookedList!.products!.length,
                  padding: EdgeInsets.only(right: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(left: (ResponsiveHelper.isDesktop(context) && index == 0 && Get.find<LocalizationController>().isLtr) ? 0 : Dimensions.paddingSizeDefault),
                      child: ItemCardWidget(
                        isBestItem: true, product:  catController.cookedProducts!.products![index],
                      ),
                    );
                  },
                ),
              ),
            ) : const ItemCardShimmer(isPopularNearbyItem: false),
          ],
          ),

        ),
      );
    }
    );
  }
}
