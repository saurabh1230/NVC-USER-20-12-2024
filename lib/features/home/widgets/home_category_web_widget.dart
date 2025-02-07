import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:non_veg_city/common/widgets/custom_image_widget.dart';
import 'package:non_veg_city/common/widgets/custom_ink_well_widget.dart';
import 'package:non_veg_city/features/category/controllers/category_controller.dart';
import 'package:non_veg_city/features/splash/controllers/splash_controller.dart';
import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/styles.dart';

import '../../category/screens/category_product_screen.dart';

class CategoryWebViewWidget extends StatelessWidget {
  const CategoryWebViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
      builder: (categoryController) {
        return categoryController.categoryList != null
            ? GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveHelper.isMobile(context) ? 4 : 8,
            crossAxisSpacing: Dimensions.paddingSizeSmall,
            mainAxisSpacing: Dimensions.paddingSizeSmall,
            mainAxisExtent: 200,
            // childAspectRatio: 0.8,
          ),
          padding: const EdgeInsets.only(
              left: Dimensions.paddingSizeExtraSmall,bottom: Dimensions.paddingSizeOverLarge),
          itemCount: categoryController.categoryList!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () =>

                  Get.toNamed(
                    RouteHelper.getCategoryProductRoute(categoryController.categoryList![index].id!,
                        categoryController.categoryList![index].name!,
                     ),
                    arguments: CategoryProductScreen(
                      categoryID: categoryController.categoryList![index].id.toString(),
                      categoryName:  categoryController.categoryList![index].name!,
                    ),
                  ),
              //     Get.toNamed(
              //   RouteHelper.getCategoryProductRoute(
              //     categoryController.categoryList![index].id,
              //     categoryController.categoryList![index].name!,
              //   ),
              // ),
              child: Container(
                width: ResponsiveHelper.isMobile(context) ? 80 : 110,
                height: ResponsiveHelper.isMobile(context) ? 80 : 110,
                // decoration: BoxDecoration(
                //     color: Colors.transparent,
                //     borderRadius: BorderRadius.circular(Dimensions.radiusSmall)
                // ),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: Container(
                    width: ResponsiveHelper.isMobile(context) ? 90 : 90,
                    height: ResponsiveHelper.isMobile(context) ? 70 : 90,
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(
                    //     Dimensions.radiusSmall,
                    //   ),
                    //   color: Theme.of(context).cardColor,
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: CustomImageWidget(
                              image:
                              '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList![index].image}',
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height:
                            ResponsiveHelper.isMobile(context)
                                ? Dimensions.paddingSizeDefault
                                : Dimensions.paddingSizeLarge,
                          ),
                          Text(
                            categoryController.categoryList![index].name!,
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        )
            : CategoryWebViewWidgetShimmer(
          categoryController: categoryController,
        );
      },
    );
  }
}

class CategoryWebViewWidgetShimmer extends StatelessWidget {
  final CategoryController categoryController;

  const CategoryWebViewWidgetShimmer({
    Key? key,
    required this.categoryController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isMobile(context) ? 4 : 8,
        crossAxisSpacing: Dimensions.paddingSizeSmall,
        mainAxisSpacing: Dimensions.paddingSizeSmall,
        mainAxisExtent: 200,
        // childAspectRatio: 0.8,
      ),
      // padding: const EdgeInsets.only(
      //     left: Dimensions.paddingSizeExtraSmall,bottom: Dimensions.paddingSizeOverLarge),
      itemCount: categoryController.categoryList!.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () =>
              Get.toNamed(
                RouteHelper.getCategoryProductRoute(categoryController.categoryList![index].id!,
                    categoryController.categoryList![index].name!,
                    ),
                arguments: CategoryProductScreen(
                  categoryID: categoryController.categoryList![index].id.toString(),
                  categoryName:  categoryController.categoryList![index].name!,
                ),
              ),

          //     Get.toNamed(
          //   RouteHelper.getCategoryProductRoute(
          //     categoryController.categoryList![index].id,
          //     categoryController.categoryList![index].name!,
          //   ),
          // ),
          child: Shimmer(duration: const Duration(seconds: 2),
            enabled: categoryController.categoryList == null,
            child: Container(
              width: ResponsiveHelper.isMobile(context) ? 80 : 110,
              height: ResponsiveHelper.isMobile(context) ? 80 : 110,
              // decoration: BoxDecoration(
              //     color: Colors.transparent,
              //     borderRadius: BorderRadius.circular(Dimensions.radiusSmall)
              // ),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: Container(
                  width: ResponsiveHelper.isMobile(context) ? 90 : 90,
                  height: ResponsiveHelper.isMobile(context) ? 70 : 90,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(
                  //     Dimensions.radiusSmall,
                  //   ),
                  //   color: Theme.of(context).cardColor,
                  // ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Container(color: Colors.red,),
                        ),
                        SizedBox(
                          height:
                          ResponsiveHelper.isMobile(context)
                              ? Dimensions.paddingSizeDefault
                              : Dimensions.paddingSizeLarge,
                        ),
                        Text(
                          categoryController.categoryList![index].name!,
                          style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
