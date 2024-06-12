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

class CookedParticleViewWidget extends StatelessWidget {
  final bool isPopular;
  const CookedParticleViewWidget({super.key, required this.isPopular});

  @override
  Widget build(BuildContext context) {
    Get.find<CategoryController>().getCookedProductList(1, false, "cooked");
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
                Text('Trending Cooked Items', style: robotoMedium.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),

                const Spacer(),

                ArrowIconButtonWidget(
                  onTap: () => Get.toNamed(RouteHelper.getMainProductView()),
                ),
              ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),


            cookedController.cookedList !=null ? Expanded(
              child: SizedBox(
                height: ResponsiveHelper.isMobile(context) ? 240 : 255,
                child: ListView.builder(
                  itemCount:   cookedController.cookedList!.products!.length,
                  padding: EdgeInsets.only(right: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(left: (ResponsiveHelper.isDesktop(context) && index == 0 && Get.find<LocalizationController>().isLtr) ? 0 : Dimensions.paddingSizeDefault),
                      child: ItemCardWidget(
                        isBestItem: true, product:  cookedController.cookedList!.products![index],
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