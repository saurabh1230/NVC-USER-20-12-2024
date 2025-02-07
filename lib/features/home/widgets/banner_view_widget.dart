import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:non_veg_city/common/widgets/custom_shimmer.dart';
import 'package:non_veg_city/features/home/controllers/home_controller.dart';
import 'package:non_veg_city/features/restaurant/screens/restaurant_screen.dart';
import 'package:non_veg_city/features/splash/controllers/splash_controller.dart';
import 'package:non_veg_city/features/splash/controllers/theme_controller.dart';
import 'package:non_veg_city/features/product/domain/models/basic_campaign_model.dart';
import 'package:non_veg_city/common/models/product_model.dart';
import 'package:non_veg_city/common/models/restaurant_model.dart';
import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/styles.dart';
import 'package:non_veg_city/common/widgets/custom_image_widget.dart';
import 'package:non_veg_city/common/widgets/product_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../util/images.dart';
import '../../category/controllers/category_controller.dart';

class BannerViewWidget extends StatelessWidget {
  const BannerViewWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<HomeController>(builder: (homeController) {
      return (homeController.bannerImageList != null && homeController.bannerImageList!.isEmpty) ? const SizedBox() :
      Container(

        width: MediaQuery.of(context).size.width,
        // height:  1,
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
        child: homeController.bannerImageList != null ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CarouselSlider.builder(
              options: CarouselOptions(
                aspectRatio: 2.9,
                // viewportFraction: 0.5,
                enlargeFactor: 0.2,
                autoPlay: true,
                enlargeCenterPage: true,
                disableCenter: true,
                autoPlayInterval: const Duration(seconds: 7),
                onPageChanged: (index, reason) {
                  homeController.setCurrentIndex(index, true);
                },
              ),
              itemCount: homeController.bannerImageList!.isEmpty ? 1 : homeController.bannerImageList!.length,
              itemBuilder: (context, index, _) {
                String? baseUrl = homeController.bannerDataList![index] is BasicCampaignModel ? Get.find<SplashController>()
                    .configModel!.baseUrls!.campaignImageUrl : Get.find<SplashController>().configModel!.baseUrls!.bannerImageUrl;
                return InkWell(
                  onTap: () {
                    if(homeController.bannerDataList![index] is Product) {
                      Product? product = homeController.bannerDataList![index];
                      ResponsiveHelper.isMobile(context) ? showModalBottomSheet(
                        context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                        builder: (con) => ProductBottomSheetWidget(product: product),
                      ) : showDialog(context: context, builder: (con) => Dialog(
                          child: ProductBottomSheetWidget(product: product)),
                      );
                    }else if(homeController.bannerDataList![index] is Restaurant) {
                      Restaurant restaurant = homeController.bannerDataList![index];
                      String slug = restaurant.name!.toLowerCase().replaceAll(' ', '-');
                      Get.toNamed(
                        RouteHelper.getRestaurantRoute(slug,restaurant.id!),
                        arguments: RestaurantScreen(restaurant: restaurant),
                      );
                    }else if(homeController.bannerDataList![index] is BasicCampaignModel) {
                      BasicCampaignModel campaign = homeController.bannerDataList![index];
                      Get.toNamed(RouteHelper.getBasicCampaignRoute(campaign));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: GetBuilder<SplashController>(builder: (splashController) {
                        return CustomImageWidget(
                          image: '$baseUrl/${homeController.bannerImageList![index]}',
                          fit: BoxFit.cover,
                        );
                      },
                      ),
                    ),
                  ),
                );
              },
            ),
            //
            // const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: homeController.bannerImageList!.map((bnr) {
            //     int index = homeController.bannerImageList!.indexOf(bnr);
            //     int totalBanner = homeController.bannerImageList!.length;
            //     return Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 3),
            //       child: index == homeController.currentIndex ? Container(
            //         decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
            //         padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            //         child: Text('${(index) + 1}/$totalBanner', style: robotoRegular.copyWith(color: Colors.white, fontSize: 12)),
            //       ) : Container(
            //         height: 4.18, width: 5.57,
            //         decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.5), borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
            //       ),
            //     );
            //   }).toList(),
            // ),
          ],
        ) : Shimmer(
          duration: const Duration(seconds: 2),
          enabled: homeController.bannerImageList == null,
          child: CarouselSlider.builder(
            options: CarouselOptions(
              aspectRatio: 2.9,
              // viewportFraction: 0.5,
              enlargeFactor: 0.2,
              autoPlay: true,
              enlargeCenterPage: true,
              disableCenter: true,
              autoPlayInterval: const Duration(seconds: 7),
              onPageChanged: (index, reason) {
                homeController.setCurrentIndex(index, true);
              },
            ),
            itemCount: 1,
            itemBuilder: (context, index, _) {
              return InkWell(
                onTap: () {
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

}

class CustomStaticBannerWidget extends StatelessWidget {
  const CustomStaticBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<CategoryController>().getCategoryList(false);

    return GetBuilder<CategoryController>(builder: (categoryController) {
      return ResponsiveHelper.isMobile(context) ?
      Container(
        width : Get.size.width,
        // padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeOverLarge),
        child: Image.asset(Images.topBanner,),)
          :
        categoryController.categoryList != null ?
        Stack(
          children: [
            Container(
              // color: const Color(0xff171a29),
            height: 300,width : Get.size.width,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomShimmerEffect(
                          child: Container(
                            height: 250,
                            width: Get.size.width,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            ),

                          ),
                        ),
                      ),
                      const SizedBox(width: 15,),
                      Expanded(
                        child: CustomShimmerEffect(
                          child: Container(
                            height: 250,
                            width: Get.size.width,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            ),

                          ),
                        ),
                      ),
                      const SizedBox(width: 15,),
                      Expanded(
                        child: CustomShimmerEffect(
                          child: Container(
                            height: 250,
                            width: Get.size.width,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            ),

                          ),
                        ),
                      ),
                      const SizedBox(width: 15,),
                      Expanded(
                        child: CustomShimmerEffect(
                          child: Container(
                            height: 250,
                            width: Get.size.width,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            ),

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // const CustomLoader(),
                // Center(child: Image.asset("assets/image/loadingImage.png",height: 40,color: Colors.white,))

              ],
            ),
            ),
            Image.asset(Images.topBanner,fit: BoxFit.cover,height: 300, width :Get.size.width),
          ],
        ) :
      Container(width : Get.size.width,height: 300,
        // color: const Color(0xff171a29),
        // padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeOverLarge),
        child:  Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomShimmerEffect(
                      child: Container(
                        height: 250,
                        width: Get.size.width,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),

                      ),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: CustomShimmerEffect(
                      child: Container(
                        height: 250,
                        width: Get.size.width,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),

                      ),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: CustomShimmerEffect(
                      child: Container(
                        height: 250,
                        width: Get.size.width,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),

                      ),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: CustomShimmerEffect(
                      child: Container(
                        height: 250,
                        width: Get.size.width,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),

                      ),
                    ),
                  ),
                ],
              ),
            ),
            // const CustomLoader(),
            // Center(child: Image.asset("assets/image/loadingImage.png",height: 40,color: Colors.white,))

          ],
        ),
        );
    });

  }
}
