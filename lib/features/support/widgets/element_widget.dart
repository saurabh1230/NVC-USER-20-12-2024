import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/styles.dart';
import 'package:flutter/material.dart';
class ElementWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  final Function() onTap;
  const ElementWidget({super.key, required this.image, required this.title, required this.subTitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return InkWell(
      onTap: onTap,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(image, height: isDesktop ? 70 : 45, width: isDesktop ? 70 : 45, fit: BoxFit.cover),
        SizedBox(height: isDesktop ? Dimensions.paddingSizeExtraLarge : 0),
        Text(title, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault,
        color: Theme.of(context).primaryColor),textAlign: TextAlign.center,),
        // SizedBox(height: isDesktop ? Dimensions.paddingSizeExtraLarge : 0),
         Divider(color: Colors.black.withOpacity(0.80),),

        Text(
          subTitle,
          textAlign: TextAlign.center,
          style: robotoMedium.copyWith(fontSize: isDesktop ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault, color: Colors.black),
        ),

      ]),
    );
  }
}
