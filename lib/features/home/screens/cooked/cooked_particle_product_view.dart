import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/common/widgets/heading_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/home/screens/cooked/cooked_whats_on_your_mind_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_view_widget_horizontal.dart';
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

import '../../../../util/app_loading_screen.dart';
import '../../../restaurant/widgets/restaurant_view_verticle.dart';
import '../home_screen.dart';

class CookedParticleProductScreen extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  const CookedParticleProductScreen({
    super.key,
    required this.categoryID,
    required this.categoryName,
  });
  @override
  CookedParticleProductScreenState createState() => CookedParticleProductScreenState();
}

class CookedParticleProductScreenState extends State<CookedParticleProductScreen> with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController restaurantScrollController = ScrollController();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().clearSubCategoryList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get.find<CategoryController>().getFilUncookedCategoryList("1");
      Get.find<CategoryController>().getFilterRestaurantList(1, "1", false,);
      Get.find<CategoryController>().getUncookedProducts(1,"cooked",false);
    });



    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    // Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<CategoryController>().categoryProductList != null
          && !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          debugPrint('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          if(Get.find<CategoryController>().selectedCookedCategoryId == null) {
            Get.find<CategoryController>().getUncookedProducts(Get.find<CategoryController>().offset+1,"cooked",false);
          } else {
            Get.find<CategoryController>().getCategoryProductList(
              Get.find<CategoryController>().subCategoryIndex == 0 ? widget.categoryID
                  : Get.find<CategoryController>().subCategoryList![Get.find<CategoryController>().subCategoryIndex].id.toString(),
              Get.find<CategoryController>().offset+1, Get.find<CategoryController>().type, false,
            );
          }
        }
      }
    });

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
                      child: Center(child: CategoryWhatOnYourMindViewWidget(),),
                    ),

                  ]),
                )),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverDelegate(
                    height: 60,
                    child: HeadingWidget(title: 'Top Restaurants & Cloud Kitchen',
                      tap: () {
                        // Get.toNamed(RouteHelper.getAllRestaurantRoute('Top Vendors'));
                      },)
                ),
              ),

              SliverToBoxAdapter(
                  child: Center(child: FooterViewWidget(
                    child: Padding(
                      padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.only(bottom: Dimensions.paddingSizeOverLarge),
                      child:  RestaurantsViewHorizontalWidget(isCooked: true,
                        restaurants: catController.categoryRestaurantList, categoryName: Get.find<CategoryController>().categoryName, categoryId: Get.find<CategoryController>().categoryId,
                        scrollController: scrollController,),
                    ),
                  ))),
            ] ),
        ),
      );
    });
  }
}
