import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/item_card_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/review/controllers/review_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UNCookedParticleViewWidget extends StatelessWidget {
  final bool isPopular;
  const UNCookedParticleViewWidget({super.key, required this.isPopular});

  @override
  Widget build(BuildContext context) {
    Get.find<CategoryController>().getUnCookedProductList(1, false, "uncooked");
    return GetBuilder<CategoryController>(builder: (cookedController) {
      return  Padding(
        padding:  EdgeInsets.symmetric(vertical: ResponsiveHelper.isMobile(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge),
        child: SizedBox(
          height: ResponsiveHelper.isMobile(context) ? 300 : 315, width: Dimensions.webMaxWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [

            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
              child: Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Trending UnCooked Items', style: robotoMedium.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
                    Text("Farm Fresh Meat At Your Door", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.black.withOpacity(0.75))),

                  ],
                ),

                const Spacer(),

                ArrowIconButtonWidget(
                  onTap: () {
                    Get.toNamed(RouteHelper.getUnCookedCategoryProductRoute(
                      cookedController.unCookedCat![0].id, "uncooked",
                    ));
                    Get.find<CategoryController>().getSubCategoryList(cookedController.unCookedCat![0].id.toString());
                  },
                ),
              ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),


            cookedController.uncooked !=null ? Expanded(
              child: SizedBox(
                height: ResponsiveHelper.isMobile(context) ? 240 : 255,
                child: ListView.builder(
                  itemCount:  cookedController.uncooked!.products!.length > 8 ? 8 :  cookedController.uncooked!.products!.length,
                  // itemCount:   cookedController.uncooked!.products!.length,
                  padding: EdgeInsets.only(right: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(left: (ResponsiveHelper.isDesktop(context) && index == 0 && Get.find<LocalizationController>().isLtr) ? 0 : Dimensions.paddingSizeDefault),
                      child: ItemCardWidget(
                        isBestItem: true, product:  cookedController.uncooked!.products![index],
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
