import 'package:non_veg_city/common/widgets/custom_ink_well_widget.dart';
import 'package:non_veg_city/common/widgets/hover_widgets/hover_zoom_widget.dart';
import 'package:non_veg_city/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:non_veg_city/features/home/widgets/icon_with_text_row_widget.dart';
import 'package:non_veg_city/features/home/widgets/popular_restaurants_view_widget.dart';
import 'package:non_veg_city/features/home/widgets/what_on_your_mind_view_widget.dart';
import 'package:non_veg_city/features/restaurant/controllers/restaurant_controller.dart';
import 'package:non_veg_city/features/splash/controllers/splash_controller.dart';
import 'package:non_veg_city/common/models/restaurant_model.dart';
import 'package:non_veg_city/features/auth/controllers/auth_controller.dart';
import 'package:non_veg_city/features/favourite/controllers/favourite_controller.dart';
import 'package:non_veg_city/features/splash/controllers/theme_controller.dart';
import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/images.dart';
import 'package:non_veg_city/util/styles.dart';
import 'package:non_veg_city/common/widgets/custom_image_widget.dart';
import 'package:non_veg_city/common/widgets/custom_snackbar_widget.dart';
import 'package:non_veg_city/features/restaurant/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class RestaurantsViewHorizontalWidget extends StatelessWidget {
  final List<Restaurant?>? restaurants;
  const RestaurantsViewHorizontalWidget({super.key, this.restaurants, });

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top:  Dimensions.paddingSizeOverLarge,
            left:  Dimensions.paddingSizeExtraSmall,
            right: Dimensions.paddingSizeExtraSmall,
            bottom: Dimensions.paddingSizeDefault,
          ),
          child:
          Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeDefault),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Top Vendors", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600)),
                ArrowIconButtonWidget(onTap: () =>
                    Get.toNamed(RouteHelper.getAllRestaurantRoute('Top Vendors')),),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 172,
          child:
          restaurants != null
              ? restaurants!.isNotEmpty
              ?
          ListView.separated(
            itemCount: restaurants!.length,
            padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault,left: Dimensions.paddingSizeDefault),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return buildContainer(context, restaurants![index]!);
            }, separatorBuilder: (BuildContext context, int index) => const SizedBox(width: Dimensions.paddingSizeDefault,),
          ) :
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeOverLarge),
              child: Text('no_restaurant_available'.tr, style: robotoMedium),
            ),
          ) :
          const PopularRestaurantShimmer(),
          //     : ListView.builder(
          //   scrollDirection: Axis.horizontal,
          //   itemCount: 12,
          //   itemBuilder: (context, index) {
          //     return const WebWhatOnYourMindViewShimmer();
          //   },
          // ),
        ),
      ],
    );
  }

  Container buildContainer(BuildContext context, Restaurant restaurant) {
    bool isAvailable = restaurant.open == 1 && restaurant.active!;
    return Container(
      height: 172, width: 253,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: CustomInkWellWidget(
        onTap: () {
          String slug = restaurant.name!.toLowerCase().replaceAll(' ', '-');
          Get.toNamed(RouteHelper.getRestaurantRoute(slug,restaurant.id!),
            arguments: RestaurantScreen(restaurant: restaurant),
          );
        },
        // onTap: () => Get.toNamed(RouteHelper.getRestaurantRoute(slug,restaurant.id.toString()),
        //   arguments: RestaurantScreen(restaurant: restaurant),
        // ),
        radius: Dimensions.radiusDefault,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 85, width: 253,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                child: Stack(
                  children: [
                    CustomImageWidget(
                      placeholder: Images.placeholder,
                      image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantCoverPhotoUrl}/${restaurant.coverPhoto}',
                      fit: BoxFit.cover, height: 83, width: 253,
                    ),

                    !isAvailable ? Positioned(
                      top: 0, left: 0, right: 0, bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ) : const SizedBox(),
                  ],
                ),
              ),
            ),

            !isAvailable ? Positioned(top: 30, left: 60, child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(Dimensions.radiusLarge)
              ),
              padding: EdgeInsets.symmetric(horizontal: Dimensions.fontSizeExtraLarge, vertical: Dimensions.paddingSizeExtraSmall),
              child: Row(children: [
                Icon(Icons.access_time, size: 12, color: Theme.of(context).cardColor),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Text('closed_now'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall)),
              ]),
            )) : const SizedBox(),

            Positioned(
              top: 90, left: 75, right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( restaurant.name!,
                      overflow: TextOverflow.ellipsis, maxLines: 1, style: robotoMedium.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text( restaurant.address!,
                      overflow: TextOverflow.ellipsis, maxLines: 1,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                ],
              ),
            ),


            Positioned(
              bottom: 10, left: 0, right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconWithTextRowWidget(
                    icon: Icons.star_border,
                    text: restaurant.avgRating!.toStringAsFixed(1),
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  restaurant.freeDelivery! ? ImageWithTextRowWidget(
                    widget: Image.asset(Images.deliveryIcon, height: 20, width: 20),
                    text: 'free'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ): const SizedBox(),
                  restaurant.freeDelivery! ? const SizedBox(width: Dimensions.paddingSizeDefault) : const SizedBox(),

                  IconWithTextRowWidget(
                    icon: Icons.access_time_outlined,
                    text: '${restaurant.deliveryTime}',
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),

                ],
              ),
            ),


            Positioned(
              top: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
              child: GetBuilder<FavouriteController>(builder: (favouriteController) {
                bool isWished = favouriteController.wishRestIdList.contains(restaurant.id);
                return InkWell(
                  onTap: () {
                    if(Get.find<AuthController>().isLoggedIn()) {
                      isWished ? favouriteController.removeFromFavouriteList(restaurant.id, true)
                          : favouriteController.addToFavouriteList(null, restaurant, true);
                    }else {
                      showCustomSnackBar('you_are_not_logged_in'.tr);
                    }
                  },
                  child: Icon(isWished ? Icons.favorite : Icons.favorite_border,
                      color: isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, size: 20),
                );
              }
              ),
            ),





            Positioned(
              top: 60, left: Dimensions.paddingSizeSmall,
              child: Container(
                height: 58, width: 58,
                decoration:  BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(color: Theme.of(context).cardColor.withOpacity(0.2), width: 3),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: ClipRRect(
                  child: CustomImageWidget(
                    placeholder: Images.placeholder,
                    image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}'
                        '/${restaurant.logo}',
                    fit: BoxFit.cover, height: 58, width: 58,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),


    );
  }
}