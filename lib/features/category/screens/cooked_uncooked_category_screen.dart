import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/category/screens/cooked_and_cooked_category_widget.dart';
import 'package:stackfood_multivendor/features/home/screens/mobile_category_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/web/web_banner_view_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_horizontal_view_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/widgets/heading_widget.dart';
import 'package:stackfood_multivendor/helper/extensions.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/cart_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/veg_filter_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/screens/mobile_all_restaurant.dart';

class CookedUnCookedProductScreen extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  const CookedUnCookedProductScreen({super.key, required this.categoryID, required this.categoryName, });

  @override
  CookedUnCookedProductScreenState createState() => CookedUnCookedProductScreenState();
}

class CookedUnCookedProductScreenState extends State<CookedUnCookedProductScreen> with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController restaurantScrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
     Get.find<RestaurantController>().getRestaurantCookedList(1,false);
    });


  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (catController) {


      return PopScope(
        canPop: Navigator.canPop(context),
        onPopInvoked: (val) async {
          if(catController.isSearching) {
            catController.toggleSearch();
          }else {}
        },
        child: Scaffold(
          appBar: ResponsiveHelper.isDesktop(context) ?   WebMenuBar() : AppBar(
            title: catController.isSearching ? TextField(
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
              onSubmitted: (String query) => catController.searchData(
                query, catController.subCategoryIndex == 0 ? widget.categoryID
                  : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
                catController.type,
              ),
            ) : Text(widget.categoryName, style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color,
            )),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Theme.of(context).textTheme.bodyLarge!.color,
              onPressed: () {
                if(catController.isSearching) {
                  catController.toggleSearch();
                }else {
                  Get.back();
                }
              },
            ),
            backgroundColor: Theme.of(context).cardColor,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () => catController.toggleSearch(),
                icon: Icon(
                  catController.isSearching ? Icons.close_sharp : Icons.search,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),

              IconButton(
                onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
                icon: CartWidget(color: Theme.of(context).textTheme.bodyLarge!.color, size: 25),
              ),

              VegFilterWidget(type: catController.type, fromAppBar: true, onSelected: (String type) {
                if(catController.isSearching) {
                  catController.searchData(
                    catController.subCategoryIndex == 0 ? widget.categoryID
                        : catController.subCategoryList![catController.subCategoryIndex].id.toString(), '1', type,
                  );
                }else {
                  if(catController.isRestaurant) {
                    catController.getCategoryRestaurantList(
                      catController.subCategoryIndex == 0 ? widget.categoryID
                          : catController.subCategoryList![catController.subCategoryIndex].id.toString(), 1, type, true,
                    );
                  }else {
                    catController.getCategoryProductList(
                      catController.subCategoryIndex == 0 ? widget.categoryID
                          : catController.subCategoryList![catController.subCategoryIndex].id.toString(), 1, type, true,
                    );
                  }
                }
              }),
            ],
          ),
          endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Column(children: [
              Container(
                width: Get.size.width,
                padding: EdgeInsets.only(
                    top:   Dimensions.paddingSizeSmall,
                    bottom:  ResponsiveHelper.isTab(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeDefault),
                color: Theme.of(context).primaryColor.withOpacity(0.03),
                child: Center(child: Column(
                  children: [
                    SizedBox(width: Dimensions.webMaxWidth,
                      child: Column(
                        children: [
                          ResponsiveHelper.isMobile(context) ? const SizedBox() :
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal:ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeDefault),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (ResponsiveHelper.isDesktop(context))
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: ArrowIconButtonWidget(
                                        isLeft: true,
                                        paddingLeft: Dimensions.paddingSizeSmall,
                                        onTap: () {
                                          Get.toNamed(RouteHelper.getMainRoute(1.toString()));
                                        },
                                      ),
                                    ),
                                  )
                                else const Expanded(child: SizedBox()),
                                const SizedBox(width: Dimensions.paddingSizeDefault,),
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      widget.categoryName.toTitleCase(),
                                      style: robotoBold.copyWith(
                                        fontSize: Dimensions.fontSizeOverLarge,
                                        color: Colors.black.withOpacity(0.80),
                                      ),
                                    ),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                              ],
                            )
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault,),
                          CarouselBannerCookedWidget(),
                          const SizedBox(height: Dimensions.paddingSizeDefault,),
                          // ResponsiveHelper.isMobile(context) ?
                          // MobileWhatOnYourMindViewWidget() :
                          CategoryWhatOnYourMindViewWidget(),
                        ],
                      ),
                    ),

                  ],
                )),
              ),
              SizedBox(width: Dimensions.webMaxWidth,
                child: HeadingWidget(title:  'All Cooked Restaurants',
                  tap: () {
                    // Get.toNamed(RouteHelper.getAllRestaurantRoute('Top Vendors'));
                  },),
              ),
              Padding(
                padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.only(bottom: Dimensions.paddingSizeOverLarge),
                child: MobileAllRestaurantsWidget(scrollController: _scrollController),
              ),
              const SizedBox(height: Dimensions.paddingSizeOverLarge,)
              // SliverToBoxAdapter(child: Center(child: FooterViewWidget(
              //   child: Padding(
              //     padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.only(bottom: Dimensions.paddingSizeOverLarge),
              //     child: MobileAllRestaurantsWidget(scrollController: _scrollController),
              //   ),
              // ))),

              // SizedBox(width: Dimensions.webMaxWidth,
              //     child: RestaurantsViewHorizontalWidget(isCooked: true,
              //       restaurants: catController.categoryRestaurantList, categoryName: Get.find<CategoryController>().categoryName, categoryId: Get.find<CategoryController>().categoryId,),),
              // const SizedBox(height: Dimensions.paddingSizeDefault,),
              // const FooterViewWidget(minHeight: 0.05,
              //     child: SizedBox())
            ]),
          ),
        ),
      );
    });
  }
}
