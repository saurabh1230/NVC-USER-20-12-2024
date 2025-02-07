import 'package:non_veg_city/common/widgets/custom_image_widget.dart';
import 'package:non_veg_city/features/home/controllers/home_controller.dart';
import 'package:non_veg_city/features/home/screens/mobile_all_restaurant.dart';
import 'package:non_veg_city/features/home/screens/particular_cooked_product_widget.dart';
import 'package:non_veg_city/features/home/screens/pet_food_items.dart';
import 'package:non_veg_city/features/home/screens/petfood_and_masala_particle_view.dart';
import 'package:non_veg_city/features/home/widgets/all_restaurant_filter_widget.dart';
import 'package:non_veg_city/features/home/widgets/all_restaurants_widget.dart';
import 'package:non_veg_city/features/home/widgets/bad_weather_widget.dart';
import 'package:non_veg_city/features/home/widgets/best_review_item_view_widget.dart';
import 'package:non_veg_city/features/home/widgets/enjoy_off_banner_view_widget.dart';
import 'package:non_veg_city/features/home/widgets/order_again_view_widget.dart';
import 'package:non_veg_city/features/home/widgets/popular_foods_nearby_view_widget.dart';
import 'package:non_veg_city/features/home/widgets/popular_restaurants_view_widget.dart';
import 'package:non_veg_city/features/home/widgets/today_trends_view_widget.dart';
import 'package:non_veg_city/features/home/widgets/web/cooked_and_uncooked_view_widget.dart';
import 'package:non_veg_city/features/home/widgets/web/web_banner_view_widget.dart';
import 'package:non_veg_city/features/home/widgets/web/web_cuisine_view_widget.dart';
import 'package:non_veg_city/features/home/widgets/web/web_loaction_and_refer_banner_view_widget.dart';
import 'package:non_veg_city/features/home/widgets/web/web_new_on_nvc_view_widget.dart';

import 'package:non_veg_city/features/home/widgets/what_on_your_mind_view_widget.dart';
import 'package:non_veg_city/features/restaurant/screens/pet_food_section.dart';
import 'package:non_veg_city/features/restaurant/screens/popular_fish_items.dart';
import 'package:non_veg_city/features/splash/controllers/splash_controller.dart';
import 'package:non_veg_city/features/splash/domain/models/config_model.dart';
import 'package:non_veg_city/features/auth/controllers/auth_controller.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/common/widgets/footer_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:non_veg_city/util/styles.dart';

import '../../../common/models/product_model.dart';
import '../../../common/widgets/product_view_widget.dart';
import '../../../helper/responsive_helper.dart';
import '../../../util/images.dart';
import '../../category/controllers/category_controller.dart';
import '../../product/screens/popular_food_screen.dart';
import '../../restaurant/screens/popular_mutton_items.dart';
import '../widgets/arrow_icon_button_widget.dart';
import '../widgets/banner_view_widget.dart';
import '../widgets/cooked_category_widget.dart';
import '../widgets/home_category_web_widget.dart';
import '../widgets/particular_category_widget.dart';

class WebHomeScreen extends StatefulWidget {
  final ScrollController scrollController;
  const WebHomeScreen({super.key, required this.scrollController});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  ConfigModel? _configModel;

  @override
  void initState() {
    super.initState();
    Get.find<HomeController>().setCurrentIndex(0, false);
    _configModel = Get.find<SplashController>().configModel;
    print("check ======================> ");
    // Get.find<CategoryController>().getFilCategoryList("1");
    // Get.find<CategoryController>().getFilUncookedCategoryList("2");
    print("check ======================> ");

    // print("Check Api ===========> allproducts");
    // Get.find<CategoryController>().getAllProductList(1, true);
    // print("Check Api ===========> allproducts");
  }

  @override
  Widget build(BuildContext context) {
    List<Product>? products;

    bool isLogin = Get.find<AuthController>().isLoggedIn();
    return CustomScrollView(
      controller: widget.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
         SliverToBoxAdapter(
             child:CarouselBannerWidget()),
        // const SliverToBoxAdapter(child:
        // CustomStaticBannerWidget(),
        // ),
        // SliverToBoxAdapter(child: GetBuilder<HomeController>(builder: (bannerController) {
        //   return bannerController.bannerImageList == null ?
        //   CarouselBannerWidget(homeController: bannerController)
        //       : bannerController.bannerImageList!.isEmpty ? const SizedBox() :
        //   CarouselBannerWidget(homeController: bannerController);
        // })),
        // SliverToBoxAdapter(child: GetBuilder<HomeController>(builder: (bannerController) {
        //   return bannerController.bannerImageList == null ?
        //   WebBannerViewWidget(homeController: bannerController)
        //       : bannerController.bannerImageList!.isEmpty ? const SizedBox() :
        //   WebBannerViewWidget(homeController: bannerController);
        // })),

         SliverToBoxAdapter(
          child: Center(child: SizedBox(width: Dimensions.webMaxWidth,
              child: Column(
                children: [
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge,),
                  // CarouselBannerWidget(),
                  WhatOnYourMindViewWidget(isTitle: true,isBackButton: false,),
                ],
              )),
          ),
        ),

       /* SliverToBoxAdapter(child: GetBuilder<HomeController>(builder: (bannerController) {
          return bannerController.bannerImageList == null ? WebBannerViewWidget(homeController: bannerController)
              : bannerController.bannerImageList!.isEmpty ? const SizedBox() : WebBannerViewWidget(homeController: bannerController);
        })),*/


         SliverToBoxAdapter(
            child: Center(child: SizedBox(
              width: Dimensions.webMaxWidth,
              child: Column(children: [
                const CookedAndUnCookedView(),
                // const ParticularCategoryWidget(),
                const ParticularCategoryWidget(categoryID: '12', categoryName: 'uncooked', categoryBanner: Images.foodTypeUncookedBanner, heading: 'Latest UnCooked Items',),
                const ParticularUnCookedCategoryWidget(categoryID: '12', categoryName: 'cooked', categoryBanner: Images.foodTypeCookedBanner, heading: 'Latest UnCooked Items',),
                const PetFoodAndMasalaParticle(),

                // PetFoodCategoryWidget(categoryID: '12', categoryName: 'cooked',
                //   categoryBanner: Images.unCookedBanner,
                //   heading: 'Latest UnCooked Items',),

                // PopularFishItems(categoryID: '14', categoryName: 'Uncooked', categoryBanner: Images.unCookedBanner, heading: 'Latest UnCooked Items',),
                // PopularMuttonItems(categoryID: '18', categoryName: 'Uncooked', categoryBanner: Images.unCookedBanner, heading: 'Latest UnCooked Items',),
                // PetFoodItems(categoryID: '69', categoryName: 'Nvc Pet Food', categoryBanner: Images.unCookedBanner, heading: 'Nvc Pet Food Items',),

                // const ParticularCategoryWidget(categoryID: '8', categoryName: 'Uncooked', categoryBanner: Images.cookedBanner, heading: 'Top Recommended',),

                // const CookedCategoryWidget(categoryID: '7', categoryName: 'Cooked', categoryBanner: Images.cookedBanner,),

                // const ParticularCartegoryWidget(categoryID: '1', categoryName: 'uncooked',),

                // const BadWeatherWidget(),

                // const TodayTrendsViewWidget(),

                // isLogin ? const OrderAgainViewWidget() : const SizedBox(),


                _configModel!.popularFood == 1 ?   const BestReviewItemViewWidget(isPopular: false) : const SizedBox(),

               /* const WebCuisineViewWidget(),*/
                // PopularFoodScreen(isPopular: true, fromIsRestaurantFood: false,),

                PopularRestaurantsViewWidget(),

                // const PopularFoodNearbyViewWidget(),

                // isLogin ? const PopularRestaurantsViewWidget(isRecentlyViewed: false,) : const SizedBox(),
                //
                /*const WebLocationAndReferBannerViewWidget(),*/

                _configModel!.newRestaurant == 1 ? const WebNewOnNvcViewWidget(isLatest: true) : const SizedBox(),


                // AllVendorsWidget(/*scrollController: widget.scrollController*/),
                const AllUncookedVendorsWidget(),
                const AllCookedVendorsWidget(),
                const PromotionalBannerViewWidget(),
                // PopularFoodScreen(isPopular: true, fromIsRestaurantFood: false,),
              ]),
            ))
        ),






        SliverPersistentHeader(
          pinned: true,
          delegate: SliverDelegate(
            child:  const AllRestaurantFilterWidget(),
          ),
        ),
        // SliverPersistentHeader(
        //   pinned: true,
        //   delegate: SliverDelegate(
        //     child:  AllRestaurantFilterWidget(),
        //   ),
        // ),
        SliverToBoxAdapter(child: Center(child: FooterViewWidget(
          child: Padding(
            padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.only(bottom: Dimensions.paddingSizeOverLarge),
            child: MobileAllRestaurantsWidget(scrollController: widget.scrollController),
          ),
        ))),

        // SliverToBoxAdapter(child: SizedBox(width: Dimensions.webMaxWidth,
        //   child: AllFoodWidget(scrollController: widget.scrollController),
        // )),
        //  SliverToBoxAdapter(child: SizedBox(width: Dimensions.webMaxWidth,
        //   child: FooterViewWidget(minHeight: 0.0,
        //     child: AllFoodWidget(scrollController: widget.scrollController),),
        // )),



      ],
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
  }
}
