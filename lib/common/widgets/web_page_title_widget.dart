import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/styles.dart';
import 'package:flutter/material.dart';
import '../../features/home/widgets/arrow_icon_button_widget.dart';


class WebScreenTitleWidget extends StatelessWidget {
  final String title;
  final Function()? tap;
  final Color? color;
  // final bool isBackButton;
  const WebScreenTitleWidget({super.key, required this.title,  this.tap, this.color,  /*this.isBackButton = true*/});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context) ? Container(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular( Dimensions.paddingSizeSmall),
        color: Theme.of(context).primaryColor.withOpacity(0.10),
      ),


      child: Center(child: SizedBox(width: Dimensions.webMaxWidth,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (ResponsiveHelper.isDesktop(context))
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: ArrowIconButtonWidget(
                        isLeft: true,
                        paddingLeft: Dimensions.paddingSizeSmall,
                        onTap:tap ?? () {
                          Get.toNamed(RouteHelper.getMainRoute(1.toString()));
                        },
                      ),
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),

                const SizedBox(width: Dimensions.paddingSizeDefault,),

                Expanded(
                  flex: 2, // Giving more space to the text to ensure it is centered
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeOverLarge,
                        color:color?? Colors.black.withOpacity(0.80),
                      ),
                    ),
                  ),
                ),

                const Expanded(child: SizedBox()),
              ],
            )
          ],
        ),
      )),
    ) : const SizedBox();
  }
}
