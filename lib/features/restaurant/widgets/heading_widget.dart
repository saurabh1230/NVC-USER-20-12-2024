import 'package:flutter/material.dart';
import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
class HeadingWidget extends StatelessWidget {
  final String title;
  final Function() tap;
  const HeadingWidget({super.key, required this.title, required this.tap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:  Container(
        color: Theme.of(context).colorScheme.background,
        padding:  EdgeInsets.symmetric(horizontal:ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title, style: robotoBold.copyWith(
              fontSize: ResponsiveHelper.isMobile(context) ? Dimensions.fontSizeDefault :Dimensions.fontSizeOverLarge,color: Colors.black.withOpacity(0.70))),
          // ArrowIconButtonWidget(onTap: tap
          // ),
          // Flexible(
          //   child: Text(
          //     '${restaurantController.productModel != null ? restaurantController.productModel!.totalSize : 0} ${'Food Items Available'}',
          //     maxLines: 1, overflow: TextOverflow.ellipsis,
          //     style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
          //   ),
          // ),
        ]),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.only(
    //     top:  Dimensions.paddingSizeOverLarge,
    //     // left:  Dimensions.paddingSizeExtraSmall,
    //     // right: Dimensions.paddingSizeExtraSmall,
    //     bottom: Dimensions.paddingSizeDefault,
    //   ),
    //   child:
    //   Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeDefault),
    //     child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Text(title,
    //             style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600)),
    //         ArrowIconButtonWidget(onTap: tap
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
