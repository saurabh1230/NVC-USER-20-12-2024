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

class BestReviewItemViewWidget extends StatelessWidget {
  final bool isPopular;
  const BestReviewItemViewWidget({super.key, required this.isPopular});

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    return GetBuilder<ReviewController>(builder: (reviewController) {
      return (reviewController.reviewedProductList !=null && reviewController.reviewedProductList!.isEmpty) ? const SizedBox() : Padding(
        padding:  EdgeInsets.symmetric(vertical: ResponsiveHelper.isMobile(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge),
        child: SizedBox(
          height: ResponsiveHelper.isMobile(context) ? 340 : 360, width: Dimensions.webMaxWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: Dimensions.paddingSizeDefault,),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal:ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeDefault),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Popular Food Items", style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,color: Colors.black.withOpacity(0.90))),
                      Text("Top Rated Food Items", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.black.withOpacity(0.80))),

                    ],
                  ),
              // ArrowIconButtonWidget(
              //           onTap: () => Get.toNamed(RouteHelper.getPopularFoodRoute(isPopular)),
              //         ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault,),

            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
            //   child: Row(children: [
            //       Text('Popular Food Items', style: robotoMedium.copyWith(fontSize: 18, fontWeight: FontWeight.w600,color: Theme.of(context).primaryColor)),
            //
            //       const Spacer(),
            //
            //       ArrowIconButtonWidget(
            //         onTap: () => Get.toNamed(RouteHelper.getPopularFoodRoute(isPopular)),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: Dimensions.paddingSizeDefault),


            reviewController.reviewedProductList !=null ? Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: ResponsiveHelper.isMobile(context) ? 250 : 265,
                      child: ListView.builder(
                        itemCount: reviewController.reviewedProductList!.length,
                        padding: EdgeInsets.only(right: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(left: (ResponsiveHelper.isDesktop(context) && index == 0 && Get.find<LocalizationController>().isLtr) ? 0 : Dimensions.paddingSizeDefault),
                            child: ItemCardWidget(
                              isBestItem: true, product: reviewController.reviewedProductList![index],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
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