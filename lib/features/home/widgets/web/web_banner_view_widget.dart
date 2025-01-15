import 'package:carousel_slider/carousel_slider.dart';
import 'package:stackfood_multivendor/features/home/controllers/home_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/features/product/domain/models/basic_campaign_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class WebBannerViewWidget extends StatelessWidget {
  final HomeController homeController;
  const WebBannerViewWidget({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    return Container(
      // color: Theme.of(context).primaryColor.withOpacity(0.08),
      // color: const Color(0xFF171A29),
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(width: Dimensions.webMaxWidth, height: 240, child: homeController.bannerImageList != null ? Stack(
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: PageView.builder(
                  controller: pageController,
                  itemCount: (homeController.bannerImageList!.length/2).ceil(),
                  itemBuilder: (context, index) {
                    int index1 = index * 2;
                    int index2 = (index * 2) + 1;
                    bool hasSecond = index2 < homeController.bannerImageList!.length;
                    String? baseUrl1 = homeController.bannerDataList![index1] is BasicCampaignModel ? Get.find<SplashController>()
                        .configModel!.baseUrls!.campaignImageUrl : Get.find<SplashController>().configModel!.baseUrls!.bannerImageUrl;
                    String? baseUrl2 = hasSecond ? homeController.bannerDataList![index2] is BasicCampaignModel ? Get.find<SplashController>()
                        .configModel!.baseUrls!.campaignImageUrl : Get.find<SplashController>().configModel!.baseUrls!.bannerImageUrl : '';
                    return Row(children: [

                      Expanded(child: InkWell(
                        onTap: () => _onTap(index1, context),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: CustomImageWidget(
                            image: '$baseUrl1/${homeController.bannerImageList![index1]}', fit: BoxFit.cover, height: 220,
                          ),
                        ),
                      )),

                      const SizedBox(width: Dimensions.paddingSizeLarge),

                      Expanded(child: hasSecond ? InkWell(
                        onTap: () => _onTap(index2, context),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: CustomImageWidget(
                            image: '$baseUrl2/${homeController.bannerImageList![index2]}', fit: BoxFit.cover, height: 220,
                          ),
                        ),
                      ) : const SizedBox()),

                    ]);
                  },
                  onPageChanged: (int index) => homeController.setCurrentIndex(index, true),
                ),
              ),

              homeController.currentIndex != 0 ? Positioned(
                top: 0, bottom: 0, left: 0,
                child: InkWell(
                  onTap: () => pageController.previousPage(duration: const Duration(seconds: 1), curve: Curves.easeInOut),
                  child: Container(
                    height: 40, width: 40, alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Theme.of(context).cardColor,
                    ),
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
              ) : const SizedBox(),

              homeController.currentIndex != ((homeController.bannerImageList!.length/2).ceil()-1) ? Positioned(
                top: 0, bottom: 0, right: 0,
                child: InkWell(
                  onTap: () => pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.easeInOut),
                  child: Container(
                    height: 40, width: 40, alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Theme.of(context).cardColor,
                    ),
                    child: const Icon(Icons.arrow_forward),
                  ),
                ),
              ) : const SizedBox(),
            ],
          ) : WebBannerShimmer(bannerController: homeController)),


          const SizedBox(height: Dimensions.paddingSizeLarge),
          homeController.bannerImageList != null ? Builder(
              builder: (context) {
                List<String> finalBanner = [];
                for(int i=0; i<homeController.bannerImageList!.length; i++){
                  if(i%2==0){
                    finalBanner.add(homeController.bannerImageList![i]!);
                  }
                }
                int totalBanner = homeController.bannerImageList!.length;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: finalBanner.map((bnr) {
                    int index = finalBanner.indexOf(bnr);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: index == homeController.currentIndex ? Container(
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        child: Text('${(index*2) + 2}/$totalBanner', style: robotoRegular.copyWith(color: Colors.white, fontSize: 12)),
                      ) : Container(
                        height: 4.18, width: 5.57,
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.5), borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                      ),
                    );
                  }).toList(),
                );
              }
          ) : const SizedBox(),

        ],
      ),
    );
  }

  void _onTap(int index, BuildContext context) {
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
      Get.toNamed(RouteHelper.getRestaurantRoute(slug,restaurant.id!),
        arguments: RestaurantScreen(restaurant: restaurant),
      );
    }else if(homeController.bannerDataList![index] is BasicCampaignModel) {
      BasicCampaignModel campaign = homeController.bannerDataList![index];
      Get.toNamed(RouteHelper.getBasicCampaignRoute(campaign));
    }
  }
}

class WebBannerShimmer extends StatelessWidget {
  final HomeController bannerController;
  const WebBannerShimmer({super.key, required this.bannerController});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: bannerController.bannerImageList == null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
        child: Row(children: [
          Expanded(child: Container(
            height: 220,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.grey[300]),
          )),
          const SizedBox(width: Dimensions.paddingSizeLarge),
          Expanded(child: Container(
            height: 220,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.grey[300]),
          )),

        ]),
      ),
    );
  }
}

class CarouselBannerWidget extends StatelessWidget {
   CarouselBannerWidget({super.key, });
  final List<String> imageList = [
    Images.topBanner1,
    Images.topBanner2,
    Images.topBanner3,
    Images.topBanner4,
    Images.topBanner5,
    // Images.topBanner6,
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: ResponsiveHelper.isDesktop(context) ? 300.0 : 200, // Match the height to your banner's height
        enlargeCenterPage: false,
        autoPlay: true,
        aspectRatio: 16 / 9, // Aspect ratio of your banner
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 1.0, // Each item takes up the full width
      ),
      items: imageList.map((String imageUrl) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              clipBehavior: Clip.hardEdge,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                // borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover, // Ensure the image covers the container
              ),
            );
          },
        );
      }).toList(),
    );

  }
}

class CarouselBannerCookedWidget extends StatelessWidget {
  CarouselBannerCookedWidget({super.key, });
  final List<String> imageList = [
    Images.cookedBanner1,
    Images.cookedBanner2,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: ResponsiveHelper.isMobile(context) ? 120 : 300.0,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          viewportFraction: 1,
        ),

        items: imageList.map((String imageUrl) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                clipBehavior: Clip.hardEdge,

                width: MediaQuery.of(context).size.width,
                // margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Image.asset(imageUrl,
                  fit: ResponsiveHelper.isMobile(context) ? BoxFit.fitWidth :BoxFit.cover,
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}


class CarouselBannerUnCookedWidget extends StatelessWidget {
  CarouselBannerUnCookedWidget({super.key, });
  final List<String> imageList = [
    Images.uncookedBanner1,
    Images.uncookedBanner2,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal :ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: ResponsiveHelper.isMobile(context) ? 120 : 300.0,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          viewportFraction: 1,
        ),

        items: imageList.map((String imageUrl) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                clipBehavior: Clip.hardEdge,

                width: MediaQuery.of(context).size.width,
                // margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Image.asset(imageUrl,
                  fit: ResponsiveHelper.isMobile(context) ? BoxFit.fitWidth :BoxFit.cover,
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
