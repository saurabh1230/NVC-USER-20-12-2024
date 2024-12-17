import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/home/widgets/all_restaurants_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/web/web_banner_view_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_view_widget_horizontal.dart';
import 'package:stackfood_multivendor/helper/extensions.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/app_loading_screen.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/cart_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/veg_filter_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/heading_widget.dart';
import '../../../restaurant/widgets/restaurant_view_verticle.dart';
import '../home_screen.dart';
import 'uncooked_whats_on_your_mind_widget.dart';


class UnCookedParticleProductScreen extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  // final String? categoryImage;
  const UnCookedParticleProductScreen({super.key, required this.categoryID, required this.categoryName, });

  @override
  UnCookedParticleProductScreenState createState() => UnCookedParticleProductScreenState();
}

class UnCookedParticleProductScreenState extends State<UnCookedParticleProductScreen> with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController restaurantScrollController = ScrollController();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().clearSubCategoryList();
    Get.find<CategoryController>().getUncookedProducts(1,"uncooked",false);
    Get.find<CategoryController>().getFilterRestaurantList(1, "2", false,);
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    print('check');
    restaurantScrollController.addListener(() {
      print('check2');
      if (restaurantScrollController.position.pixels == restaurantScrollController.position.maxScrollExtent
          && Get.find<CategoryController>().categoryRestaurantList != null
          && !Get.find<CategoryController>().isLoading) {
        print('check3');
        int pageSize = (Get.find<CategoryController>().restaurantPageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          debugPrint('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryRestaurantList(
            Get.find<CategoryController>().subCategoryIndex == 0 ? widget.categoryID
                : Get.find<CategoryController>().subCategoryList![Get.find<CategoryController>().subCategoryIndex].id.toString(),
            Get.find<CategoryController>().offset+1, Get.find<CategoryController>().type, false,
          );
        }
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (catController) {
      List<Product>? products;
      List<Restaurant>? restaurants;
      if(catController.categoryProductList != null && catController.searchProductList != null) {
        products = [];
        if (catController.isSearching) {
          products.addAll(catController.searchProductList!);
        } else {
          products.addAll(catController.categoryProductList!);
        }
      }
      if(catController.categoryRestaurantList != null && catController.searchRestaurantList != null) {
        restaurants = [];
        if (catController.isSearching) {
          restaurants.addAll(catController.searchRestaurantList!);
        } else {
          restaurants.addAll(catController.categoryRestaurantList!);
        }
      }

      return PopScope(
        canPop: Navigator.canPop(context),
        onPopInvoked: (val) async {
          if(catController.isSearching) {
            catController.toggleSearch();
          }else {}
        },
        child: Scaffold(
          appBar: ResponsiveHelper.isDesktop(context) ?   const WebMenuBar() : AppBar(
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
            ) : Text(widget.categoryName.toTitleCase(), style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color,
            )),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
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
                onPressed: () => Get.toNamed(RouteHelper.getSearchRoute()),
                icon: Icon(
                  Icons.search,
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
          body: catController.categoryRestaurantList == null
              ? const AppLoading() :
          CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
           slivers: [
             SliverToBoxAdapter(
               child: Center(child: SizedBox(
                 width: Dimensions.webMaxWidth,
                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                     Container(
                           width: Get.size.width,
                           padding: EdgeInsets.only(/*left:  ResponsiveHelper.isTab(context)  ? Dimensions.paddingSizeDefault : 200,
                           right:  ResponsiveHelper.isTab(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeDefault,*/
                               top:   Dimensions.paddingSizeSmall,
                               bottom:  ResponsiveHelper.isTab(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeDefault),
                           color: Theme.of(context).primaryColor.withOpacity(0.03),
                           child: Center(child: UnCookedCategoryWhatOnYourMindViewWidget(),),
                         ),

                 ]),
               )),
             ),
             SliverPersistentHeader(
               pinned: true,
               delegate: SliverDelegate(
                 height: 60,
                 child: HeadingWidget(title: 'Vendors & Shops',
                   tap: () {
                     Get.toNamed(RouteHelper.getAllRestaurantRoute('Top Vendors'));
                   },)
               ),
             ),


             SliverToBoxAdapter(
                 child: Center(child: FooterViewWidget(
               child: Padding(
                 padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.only(bottom: Dimensions.paddingSizeOverLarge),
                 child:  RestaurantsViewHorizontalWidget(isCooked: true,
                        restaurants: catController.categoryRestaurantList, categoryName: Get.find<CategoryController>().categoryName, categoryId: Get.find<CategoryController>().categoryId,
                   scrollController: restaurantScrollController,),
               ),
             ))),


           ] ),
        ),
      );
    });
  }
}
