import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:stackfood_multivendor/common/widgets/rating_bar_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductShimmer extends StatelessWidget {
  final bool isEnabled;
  final bool isRestaurant;
  final bool hasDivider;
  const ProductShimmer({super.key, required this.isEnabled, required this.hasDivider, this.isRestaurant = false});
  @override
  Widget build(BuildContext context) {
    bool desktop = ResponsiveHelper.isDesktop(context);
    return Padding(
        padding: EdgeInsets.only(bottom: desktop ? 10 :10),
    child: Container(
    margin: desktop ? null : const EdgeInsets.only(bottom: 0),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
    color: Theme.of(context).cardColor,
    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1),
        spreadRadius: 1, blurRadius: 10, offset: const Offset(2, 5))],
    ),child:  ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      child: Padding(
        padding: desktop ? const EdgeInsets.all( Dimensions.paddingSizeSmall)
            : const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,
            vertical: Dimensions.paddingSizeExtraSmall),
        child: Column(
          children: [
            Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              color: Colors.grey[300],),
              height: desktop ? 130 : 100, width: desktop ? Get.size.width :  Get.size.width,
            ), const SizedBox(height: Dimensions.paddingSizeDefault,),
            const SizedBox(height: Dimensions.paddingSizeDefault,),
            Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Flexible(
                      child: Container(height: desktop ? 8 : 6, width: 40, color: Colors.grey[300]),
                    ),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Flexible(child: Container(height: desktop ? 8 : 6, width: 80, color: Colors.grey[300])),
                     ],
                   ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: RatingBarWidget(
                          rating: 0,  // Convert double? to int?
                          ratingCount: 5,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle,
                          border: Border.all(color:  Colors.grey.shade300,),
                        ),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        child: Icon(
                          Icons.add, size: 16, color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Container(height: desktop ? 8 : 6, width: 120, color: Colors.grey[300]),
                ]),
              ),
            ]),
          ],
        ),
      ),
    ),
    ),
    );
  }
}
