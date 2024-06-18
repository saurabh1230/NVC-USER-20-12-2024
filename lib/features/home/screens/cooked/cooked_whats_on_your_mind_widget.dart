import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/common/widgets/hover_widgets/hover_zoom_widget.dart';
import 'package:stackfood_multivendor/features/category/screens/category_product_screen.dart';
import 'package:stackfood_multivendor/features/home/widgets/what_on_your_mind_view_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryWhatOnYourMindViewWidget extends StatelessWidget {
  final bool isTitle;
  final ScrollController _scrollController = ScrollController();

  CategoryWhatOnYourMindViewWidget({Key? key, this.isTitle = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      return SizedBox(
        height: 130,
        child: categoryController.cat != null
            ? ListView.separated(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          // padding: const EdgeInsets.symmetric(
          //     horizontal: Dimensions.paddingSizeSmall),
          itemCount: categoryController.cat!.length,
          itemBuilder: (context, index) {
            var category = categoryController.cat![index];
            return GestureDetector(
              onTap: () {
                Get.find<CategoryController>().getSubCategoryList(category.id!.toString());
                categoryController.selectCookedCategory(category.id!);
                categoryController.getCategoryProductList(category.id.toString(), 1, 'all', false);
                categoryController.getCategoryRestaurantList(
                  category.id.toString(), 1, '1', true,
                );
              },
              child: Container(
              width:  90,
              height: 90,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                      Dimensions.radiusSmall),
                  border:
                  categoryController.selectedCookedCategoryId ==
                      category.id
                      ? Border(
                      bottom: BorderSide(
                          color: Theme.of(context)
                              .primaryColor,
                          width: 5.0))
                      : null,
                ),
              child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Column(children: [

              Container(
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, spreadRadius: 1)]
              ),
              child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              child: CustomImageWidget(
               image: '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${category.image}',
              height: ResponsiveHelper.isMobile(context) ? 70 : 100, width: ResponsiveHelper.isMobile(context) ? 70 : 100, fit: BoxFit.cover,
              ),
              ),
              ),
              SizedBox(height: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge),

              Expanded(child: Text(
                category.name!,
              style: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              // color:Theme.of(context).textTheme.bodyMedium!.color,
              ),
              maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
              )),

              ]),
              ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              SizedBox(
                  width: ResponsiveHelper.isMobile(context)
                      ? 0
                      : Dimensions.paddingSizeDefault),
        )
            : WebWhatOnYourMindViewShimmer(
            categoryController: categoryController),
      );
    });
  }
}


