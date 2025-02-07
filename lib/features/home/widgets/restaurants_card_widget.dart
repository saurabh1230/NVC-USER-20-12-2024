import 'package:non_veg_city/common/widgets/custom_ink_well_widget.dart';
import 'package:non_veg_city/common/widgets/hover_widgets/hover_zoom_widget.dart';
import 'package:non_veg_city/features/home/widgets/icon_with_text_row_widget.dart';
import 'package:non_veg_city/features/home/widgets/overflow_container_widget.dart';
import 'package:non_veg_city/features/restaurant/controllers/restaurant_controller.dart';
import 'package:non_veg_city/features/splash/controllers/splash_controller.dart';
import 'package:non_veg_city/features/splash/controllers/theme_controller.dart';
import 'package:non_veg_city/common/models/restaurant_model.dart';
import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/images.dart';
import 'package:non_veg_city/util/styles.dart';
import 'package:non_veg_city/common/widgets/custom_image_widget.dart';
import 'package:non_veg_city/common/widgets/not_available_widget.dart';
import 'package:non_veg_city/features/restaurant/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../common/widgets/custom_snackbar_widget.dart';
import '../../restaurant/screens/restaurant_screen_web.dart';

class RestaurantsCardWidget extends StatelessWidget {
  final Restaurant restaurant;
  final bool? isNewOnnvcFood;
  const RestaurantsCardWidget({super.key, this.isNewOnnvcFood, required this.restaurant});


  @override
  Widget build(BuildContext context) {
    bool isAvailable = restaurant.open == 1 && restaurant.active! ;
    double distance = Get.find<RestaurantController>().getRestaurantDistance(
      LatLng(double.parse(restaurant.latitude!), double.parse(restaurant.longitude!)),
    );
    return HoverZoom(
      child: Container(
        width: isNewOnnvcFood! ? ResponsiveHelper.isMobile(context) ? 350 : 380  : ResponsiveHelper.isMobile(context) ? 330: 355,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: CustomInkWellWidget(
          onTap: () {
            String slug = restaurant.name!.toLowerCase().replaceAll(' ', '-');
            if(restaurant.restaurantStatus == 1){

              ResponsiveHelper.isMobile(context) ? Get.toNamed(RouteHelper.getRestaurantRoute(slug,restaurant.id!), arguments: RestaurantScreen(restaurant: restaurant)):
              Get.toNamed(RouteHelper.getRestaurantWebRoute(restaurant.id), arguments: RestaurantScreenWeb(restaurant: restaurant));
            } else if(restaurant.restaurantStatus == 0) {
              showCustomSnackBar('restaurant_is_not_available'.tr);
            }
            // Get.toNamed(
            //   RouteHelper.getRestaurantRoute(restaurant.id),
            //   arguments: RestaurantScreen(restaurant: restaurant),
            // );
          },
          radius: Dimensions.radiusDefault,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                    Stack(
                      children: [
                        HoverZoom(
                          child: Container(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            height: isNewOnnvcFood! ? 98 : 78, width: isNewOnnvcFood! ? 98 : 78,
                            decoration:  BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              child:  CustomImageWidget(
                                placeholder: Images.placeholder,
                                image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantCoverPhotoUrl}'
                                    '/${restaurant.coverPhoto}',
                                    fit: BoxFit.cover, height: isNewOnnvcFood! ? 98 : 78, width: isNewOnnvcFood! ? 98 : 78,
                              ),
                            ),
                          ),
                        ),

                        isAvailable ? const SizedBox() : const NotAvailableWidget(isRestaurant: true),

                      ],
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            restaurant.name!,
                            overflow: TextOverflow.ellipsis, maxLines: 1,
                            style: robotoMedium.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Text(
                            restaurant.address!,
                            overflow: TextOverflow.ellipsis, maxLines: 1,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                            isNewOnnvcFood! ? restaurant.freeDelivery! ? ImageWithTextRowWidget(
                              widget: Image.asset(Images.deliveryIcon, height: 20, width: 20),
                              text: 'free'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                            ) : const SizedBox() : IconWithTextRowWidget(
                              icon: Icons.star_border, text: restaurant.avgRating!.toStringAsFixed(1),
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall)
                            ),
                            isNewOnnvcFood! ? const SizedBox(width : Dimensions.paddingSizeExtraSmall) : const SizedBox(width: Dimensions.paddingSizeSmall),

                            isNewOnnvcFood! ? ImageWithTextRowWidget(
                              widget: Image.asset(Images.distanceKm, height: 20, width: 20),
                              text: '${distance > 100 ? '100+' : distance.toStringAsFixed(2)} ${'km'.tr}',
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                            ) : restaurant.freeDelivery! ? ImageWithTextRowWidget(widget: Image.asset(Images.deliveryIcon, height: 20, width: 20),
                                text: 'free'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)) : const SizedBox(),
                            isNewOnnvcFood! ? const SizedBox(width : Dimensions.paddingSizeExtraSmall) : restaurant.freeDelivery! ? const SizedBox(width: Dimensions.paddingSizeSmall) : const SizedBox(),

                          /*  isNewOnnvcFood! ? ImageWithTextRowWidget(
                                widget: Image.asset(Images.itemCount, height: 20, width: 20),
                                text: '${restaurant.foodsCount} + ${'item'.tr}',
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)
                            ) : IconWithTextRowWidget(
                              icon: Icons.access_time_outlined,
                              text: restaurant.deliveryTime!,
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                            ),*/

                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
                isNewOnnvcFood!? const SizedBox() : const SizedBox(height: Dimensions.paddingSizeSmall),

                isNewOnnvcFood! ? const SizedBox() : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  restaurant.foods != null && restaurant.foods!.isNotEmpty ? Expanded(
                    child: Stack(children: [

                      OverFlowContainerWidget(image: restaurant.foods![0].image ?? ''),

                      restaurant.foods!.length > 1 ? Positioned(
                        left: 22, bottom: 0,
                        child: OverFlowContainerWidget(image: restaurant.foods![1].image ?? ''),
                      ) : const SizedBox(),

                      restaurant.foods!.length > 2 ? Positioned(
                        left: 42, bottom: 0,
                        child: OverFlowContainerWidget(image: restaurant.foods![2].image ?? ''),
                      ) : const SizedBox(),

                      Positioned(
                        left: 82, bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          height: 30, width: 80,
                          decoration:  BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${restaurant.foodsCount! > 20 ? '19 +' : restaurant.foodsCount!}',
                                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                              ),
                              Text('items'.tr, style: robotoRegular.copyWith(fontSize: 10, color: Theme.of(context).primaryColor)),
                            ],
                          ),
                        ),
                      ),

                      restaurant.foods!.length > 3 ?  Positioned(
                        left: 62, bottom: 0,
                        child: OverFlowContainerWidget(image: restaurant.foods![3].image ?? ''),
                      ) : const SizedBox(),
                    ]),
                  ) : const SizedBox(),

                  Icon(Icons.arrow_forward, color: Theme.of(context).primaryColor, size: 20),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class RestaurantsCardShimmer extends StatelessWidget {
  final bool? isNewOnnvcFood;
  const RestaurantsCardShimmer({super.key, this.isNewOnnvcFood});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isNewOnnvcFood! ? 300 : ResponsiveHelper.isDesktop(context) ? 160 : 130,
      child: isNewOnnvcFood! ? GridView.builder(
        padding: const EdgeInsets.only(left: 17, right: 17, bottom: 17),
        itemCount: 6,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisSpacing: 17, crossAxisSpacing: 17,
          mainAxisExtent: 130,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: true,
              child: Container(
                width: 380, height: 80,
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            height: 80, width: 80,
                            decoration:  BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              child:  Container(
                                color: Colors.grey[300],
                                height: 80, width: 80,
                              ),
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeDefault),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 15, width: 100,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                Container(
                                  height: 15, width: 200,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 15, width: 50,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(width: Dimensions.paddingSizeSmall),

                                    Container(
                                      height: 15, width: 50,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(width: Dimensions.paddingSizeSmall),

                                    Container(
                                      height: 15, width: 50,
                                      color: Colors.grey[300],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                    ]
                ),
              ),
            ),
          );
        },
      ) : ListView.builder(
        itemCount: 3,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: true,
              child: Container(
                width: 355, height: 80,
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          height: 80, width: 80,
                          decoration:  BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            child:  Container(
                              color: Colors.grey[300],
                            height: 80, width: 80,
                            ),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeDefault),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 15, width: 100,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Container(
                                height: 15, width: 200,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 15, width: 50,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                  Container(
                                    height: 15, width: 50,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                  Container(
                                    height: 15, width: 50,
                                    color: Colors.grey[300],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //const SizedBox(height: Dimensions.paddingSizeSmall),
                  ]
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
