import 'package:non_veg_city/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:non_veg_city/features/home/widgets/restaurants_card_widget.dart';
import 'package:non_veg_city/features/restaurant/controllers/restaurant_controller.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/app_constants.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebNewOnNvcViewWidget extends StatelessWidget {
  final bool isLatest;
  const WebNewOnNvcViewWidget({super.key, required this.isLatest});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      return (restController.latestRestaurantList != null && restController.latestRestaurantList!.isEmpty) ? const SizedBox() : Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
        child: Container(
          width: Dimensions.webMaxWidth,
          color: Theme.of(context).primaryColor.withOpacity(0.1),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraLarge, left: Dimensions.paddingSizeExtraLarge, bottom: Dimensions.paddingSizeExtraLarge, right: 17),
                child: Row(children: [
                  Expanded(
                    child: Column(children: [
                      Text('${'new_on'.tr} ${AppConstants.appName}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).primaryColor)),
                    ],
                    ),
                  ),

                  ArrowIconButtonWidget(
                    onTap: () => Get.toNamed(RouteHelper.getAllRestaurantRoute(isLatest ? 'latest' : '')),
                  ),
                ],
                ),
              ),


              restController.latestRestaurantList != null ? GridView.builder(
                padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
                itemCount: restController.latestRestaurantList!.length > 6 ? 6 : restController.latestRestaurantList!.length,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: Dimensions.paddingSizeDefault, crossAxisSpacing: Dimensions.paddingSizeDefault,
                  mainAxisExtent: 130,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return RestaurantsCardWidget(
                    isNewOnnvcFood: true,
                    restaurant: restController.latestRestaurantList![index],
                  );
                },
              ) : const RestaurantsCardShimmer(isNewOnnvcFood: true),
            ],
          ),

        ),
      );
    }
    );
  }
}
