import 'package:flutter/widgets.dart';
import 'package:non_veg_city/common/widgets/custom_ink_well_widget.dart';
import 'package:non_veg_city/common/widgets/hover_widgets/hover_zoom_widget.dart';
import 'package:non_veg_city/features/category/screens/category_product_screen.dart';
import 'package:non_veg_city/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:non_veg_city/features/restaurant/controllers/restaurant_controller.dart';
import 'package:non_veg_city/features/splash/controllers/splash_controller.dart';
import 'package:non_veg_city/features/category/controllers/category_controller.dart';
import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/styles.dart';
import 'package:non_veg_city/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class WhatOnYourMindViewWidget extends StatelessWidget {
  final bool isTitle;
  final bool? isBackButton;
  final bool? isStayOnPage;
  final ScrollController _scrollController = ScrollController();
  WhatOnYourMindViewWidget({Key? key, this.isTitle = false,  this.isBackButton = false,this.isStayOnPage = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal:ResponsiveHelper.isMobile(context)
            ? Dimensions.paddingSizeDefault
            : Dimensions.paddingSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
            ResponsiveHelper.isMobile(context) ?
            Text(
              "What's in your mind",
              style: robotoBold.copyWith(
                fontSize: Dimensions.fontSizeOverLarge,
                color: Colors.black.withOpacity(0.80),
              ),
              textAlign: TextAlign.center,
            ) :
            isTitle
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.isMobile(context)
                            ? Dimensions.paddingSizeDefault
                            : 0),
                    child: isBackButton! ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (ResponsiveHelper.isDesktop(context))
                          ArrowIconButtonWidget(
                            isLeft: true,
                            paddingLeft: Dimensions.paddingSizeSmall,
                            onTap: () {
                              Get.back();
                            },
                          ),
                        if (!ResponsiveHelper.isDesktop(context))
                          const SizedBox(width: Dimensions.paddingSizeSmall), // Placeholder space for non-desktop

                        // Spacer(), // Push the text to the center
                        const SizedBox(width: Dimensions.paddingSizeDefault,),

                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "What's in your mind",
                            style: robotoBold.copyWith(
                              fontSize: Dimensions.fontSizeOverLarge,
                              color: Colors.black.withOpacity(0.80),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const Spacer(), // Push the text to the center

                        if (ResponsiveHelper.isDesktop(context))
                          const SizedBox(width: 0), // No extra space after text on desktop
                        if (!ResponsiveHelper.isDesktop(context))
                          const Expanded(child: SizedBox()), // Fill remaining space on non-desktop
                      ],
                    ) :
                    Text(
                      "What's in your mind",
                      style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeOverLarge,
                        color: Colors.black.withOpacity(0.80),
                      ),
                      textAlign: TextAlign.center,
                    ),


            )
                : const SizedBox(),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Row(
              children: [
                ResponsiveHelper.isMobile(context) ?
                    const SizedBox() :
                Container(decoration:  BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.10),
                ),
                  child: IconButton(
                    icon:  Icon(Icons.arrow_back,color: Theme.of(context).primaryColor,),
                    onPressed: () {
                      _scrollController.animateTo(
                        _scrollController.offset -
                            MediaQuery.of(context).size.width,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: ResponsiveHelper.isMobile(context) ? 140 : 200,
                    child: categoryController.categoryList != null
                        ? ListView.separated(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault),
                            itemCount: categoryController.categoryList!.length,
                            itemBuilder: (context, index) {
                              var category = categoryController.categoryList![index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                child: Container(
                                  width: ResponsiveHelper.isMobile(context)
                                      ? 110
                                      : 140,
                                  height: ResponsiveHelper.isMobile(context)
                                      ? 100
                                      : 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                    border:
                                        categoryController.selectedCategoryId ==
                                                category.id
                                            ? Border(
                                                bottom: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width: 5.0))
                                            : null,
                                  ),
                                  child: CustomInkWellWidget(
                                    // Inside onTap method

                                    onTap: () {
                                      // Perform any additional actions needed
                                      categoryController.selectCategory(category.id!);
                                      categoryController.getCategoryRestaurantList(category.id.toString(), 1, '', true);
                                      Get.find<RestaurantController>().clearRestaurantParticularProductList();

                                      // Navigate to the new route
                                      Get.toNamed(
                                        RouteHelper.getCategoryProductRoute(category.id!, category.name!),
                                        arguments: CategoryProductScreen(
                                          categoryID: category.id.toString(),
                                          categoryName: category.name!,
                                          categoryTitle: category.name!,
                                        ),
                                      );
                                    },



                                    // onTap: () {
                                    //   categoryController
                                    //       .selectCategory(category.id!);
                                    //   categoryController.getCategoryRestaurantList(
                                    //     category.id.toString(), 1, '', true,
                                    //   );
                                    //   Get.find<RestaurantController>().clearRestaurantParticularProductList();
                                    //   categoryController.categoryName = category.name.toString();
                                    //   categoryController.categoryId = category.id.toString();
                                    //   String categoryNameEncoded = Uri.encodeComponent(category.name!);
                                    //   isStayOnPage! ?
                                    //       null :
                                    //   Get.toNamed(
                                    //     RouteHelper.getCategoryProductRoute(category.id!, categoryNameEncoded,   categoryController.categoryName,
                                    //     ),
                                    //     arguments: CategoryProductScreen(  // Pass data as arguments if needed
                                    //       categoryID: category.id.toString(),
                                    //       categoryName: category.name!,
                                    //       categoryTitle: categoryController.categoryName,
                                    //
                                    //     ),
                                    //   );
                                    // },
                                    radius: Dimensions.radiusSmall,
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeExtraSmall),
                                      child: Column(children: [
                                        HoverZoom(
                                          child: Container(
                                            width:
                                                ResponsiveHelper.isMobile(context)
                                                    ? 80
                                                    : 120,
                                            height:
                                                ResponsiveHelper.isMobile(context)
                                                    ? 80
                                                    : 120,
                                            clipBehavior: Clip.hardEdge,
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(),
                                            child: ClipOval(
                                              child: CustomImageWidget(
                                                image:
                                                    '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${category.image}',
                                                fit: BoxFit.cover,

                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            height: ResponsiveHelper.isMobile(context)
                                                ? Dimensions.paddingSizeDefault
                                                : Dimensions.paddingSizeLarge),
                                        Expanded(
                                          child: Text(
                                            category.name!, style: robotoMedium.copyWith(
                                              fontSize: Dimensions.fontSizeSmall,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) =>
                                SizedBox(
                                    width: ResponsiveHelper.isMobile(context)
                                        ? Dimensions.paddingSizeDefault
                                        : Dimensions.paddingSizeDefault),
                          )
                        : CategoryViewShimmer(
                            categoryController: categoryController),
                  ),
                ),
                ResponsiveHelper.isMobile(context) ?
                const SizedBox() :
                Container(decoration:  BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.10),
                ),
                  child: IconButton(
                    icon:  Icon(Icons.arrow_forward,color: Theme.of(context).primaryColor,),
                    onPressed: () {
                      _scrollController.animateTo(
                        _scrollController.offset +
                            MediaQuery.of(context).size.width,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
          ],
        ),
      );
    });
  }
}

class WebWhatOnYourMindViewShimmer extends StatelessWidget {
  final CategoryController categoryController;

  const WebWhatOnYourMindViewShimmer(
      {super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: 8,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveHelper.isMobile(context)
              ? 8
              : ResponsiveHelper.isTab(context)
                  ? 4
                  : 4,
          crossAxisSpacing: Dimensions.paddingSizeSmall,
          mainAxisSpacing: Dimensions.paddingSizeSmall,
          mainAxisExtent: ResponsiveHelper.isMobile(context) ? 160 : 200,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
                bottom: Dimensions.paddingSizeSmall,
                right: Dimensions.paddingSizeSmall,
                top: Dimensions.paddingSizeSmall),
            child: Container(
              width: ResponsiveHelper.isMobile(context) ? 110 : 140,
              height: ResponsiveHelper.isMobile(context) ? 110 : 140,
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              margin: EdgeInsets.only(
                  top: ResponsiveHelper.isMobile(context)
                      ? 0
                      : Dimensions.paddingSizeSmall),
              child: Shimmer(
                duration: const Duration(seconds: 2),
                enabled: categoryController.categoryList == null,
                child: Column(children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                        color: Colors.grey[300]),
                    width: ResponsiveHelper.isMobile(context) ? 120 : 120,
                    height: ResponsiveHelper.isMobile(context) ? 100 : 120,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Container(
                      height: ResponsiveHelper.isMobile(context) ? 10 : 15,
                      width: 150,
                      color: Colors.grey[300]),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
