import 'package:non_veg_city/features/auth/widgets/sign_up_widget.dart';
import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/images.dart';
import 'package:non_veg_city/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ResponsiveHelper.isDesktop(context) ? Colors.transparent : Theme.of(context).cardColor,
      body: SafeArea(child: Scrollbar(
        child: Center(
          child: Container(
            width: context.width > 700 ? 700 : context.width,
            padding: context.width > 700 ? const EdgeInsets.all(40) : const EdgeInsets.all(0),
            decoration: context.width > 700 ? BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ) : null,
            child: SingleChildScrollView(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Image.asset(Images.logo, width: 180),
                // const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                ResponsiveHelper.isDesktop(context) ? Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.clear),
                  ),
                ) : const SizedBox(),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                // Align(
                //   alignment: Alignment.topLeft,
                //   child: Text('sign_up'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                // ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                const SignUpWidget(),

              ]),
            ),
          ),
        ),
      )),
    );
  }

}

