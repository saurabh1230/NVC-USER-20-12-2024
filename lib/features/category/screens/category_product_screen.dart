// import 'package:stackfood_multivendor/common/models/product_model.dart';
// import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
// import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
// import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
// import 'package:stackfood_multivendor/helper/responsive_helper.dart';
// import 'package:stackfood_multivendor/helper/route_helper.dart';
// import 'package:stackfood_multivendor/util/dimensions.dart';
// import 'package:stackfood_multivendor/util/styles.dart';
// import 'package:stackfood_multivendor/common/widgets/cart_widget.dart';
// import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
// import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
// import 'package:stackfood_multivendor/common/widgets/veg_filter_widget.dart';
// import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class CategoryProductScreen extends StatefulWidget {
//   final String? categoryID;
//   final String categoryName;
//   const CategoryProductScreen({super.key, required this.categoryID, required this.categoryName});
//
//   @override
//   CategoryProductScreenState createState() => CategoryProductScreenState();
// }
//
// class CategoryProductScreenState extends State<CategoryProductScreen> with TickerProviderStateMixin {
//   final ScrollController scrollController = ScrollController();
//   final ScrollController restaurantScrollController = ScrollController();
//   TabController? _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
//     Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
//     scrollController.addListener(() {
//       if (scrollController.position.pixels == scrollController.position.maxScrollExtent
//           && Get.find<CategoryController>().categoryProductList != null
//           && !Get.find<CategoryController>().isLoading) {
//         int pageSize = (Get.find<CategoryController>().pageSize! / 10).ceil();
//         if (Get.find<CategoryController>().offset < pageSize) {
//           debugPrint('end of the page');
//           Get.find<CategoryController>().showBottomLoader();
//           Get.find<CategoryController>().getCategoryProductList(
//             Get.find<CategoryController>().subCategoryIndex == 0 ? widget.categoryID
//                 : Get.find<CategoryController>().subCategoryList![Get.find<CategoryController>().subCategoryIndex].id.toString(),
//             Get.find<CategoryController>().offset+1, Get.find<CategoryController>().type, false,
//           );
//         }
//       }
//     });
//     restaurantScrollController.addListener(() {
//       if (restaurantScrollController.position.pixels == restaurantScrollController.position.maxScrollExtent
//           && Get.find<CategoryController>().categoryRestaurantList != null
//           && !Get.find<CategoryController>().isLoading) {
//         int pageSize = (Get.find<CategoryController>().restaurantPageSize! / 10).ceil();
//         if (Get.find<CategoryController>().offset < pageSize) {
//           debugPrint('end of the page');
//           Get.find<CategoryController>().showBottomLoader();
//           Get.find<CategoryController>().getCategoryRestaurantList(
//             Get.find<CategoryController>().subCategoryIndex == 0 ? widget.categoryID
//                 : Get.find<CategoryController>().subCategoryList![Get.find<CategoryController>().subCategoryIndex].id.toString(),
//             Get.find<CategoryController>().offset+1, Get.find<CategoryController>().type, false,
//           );
//         }
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<CategoryController>(builder: (catController) {
//       List<Product>? products;
//       List<Restaurant>? restaurants;
//       if(catController.categoryProductList != null && catController.searchProductList != null) {
//         products = [];
//         if (catController.isSearching) {
//           products.addAll(catController.searchProductList!);
//         } else {
//           products.addAll(catController.categoryProductList!);
//         }
//       }
//       if(catController.categoryRestaurantList != null && catController.searchRestaurantList != null) {
//         restaurants = [];
//         if (catController.isSearching) {
//           restaurants.addAll(catController.searchRestaurantList!);
//         } else {
//           restaurants.addAll(catController.categoryRestaurantList!);
//         }
//       }
//
//       return PopScope(
//         canPop: Navigator.canPop(context),
//         onPopInvoked: (val) async {
//           if(catController.isSearching) {
//             catController.toggleSearch();
//           }else {}
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(20.0), // Adjust the radius as needed
//                 bottomRight: Radius.circular(20.0), // Adjust the radius as needed
//               ),
//             ),
//             title: catController.isSearching ? TextField(
//               autofocus: true,
//               textInputAction: TextInputAction.search,
//               decoration: const InputDecoration(
//                 hintText: 'Search...',
//                 border: InputBorder.none,
//               ),
//               style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
//               onSubmitted: (String query) => catController.searchData(
//                 query, catController.subCategoryIndex == 0 ? widget.categoryID
//                   : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
//                 catController.type,
//               ),
//             ) : Text(widget.categoryName, style: robotoRegular.copyWith(
//               fontSize: Dimensions.fontSizeLarge, color: Colors.white,
//             )),
//             centerTitle: true,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back,color: Colors.white,),
//               color: Colors.white,
//               onPressed: () {
//                 if(catController.isSearching) {
//                   catController.toggleSearch();
//                 }else {
//                   Get.back();
//                 }
//               },
//             ),
//             backgroundColor: Theme.of(context).primaryColor,
//             elevation: 0,
//             actions: [
//               IconButton(
//                 onPressed: () => catController.toggleSearch(),
//                 icon: Icon(
//                   catController.isSearching ? Icons.close_sharp : Icons.search,
//                   color: Colors.white,
//                 ),
//               ),
//
//               IconButton(
//                 onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
//                 icon: const CartWidget(color: Colors.white, size: 25),
//               ),
//
//               VegFilterWidget(type: catController.type, fromAppBar: true, onSelected: (String type) {
//                 if(catController.isSearching) {
//                   catController.searchData(
//                     catController.subCategoryIndex == 0 ? widget.categoryID
//                         : catController.subCategoryList![catController.subCategoryIndex].id.toString(), '1', type,
//                   );
//                 }else {
//                   if(catController.isRestaurant) {
//                     catController.getCategoryRestaurantList(
//                       catController.subCategoryIndex == 0 ? widget.categoryID
//                           : catController.subCategoryList![catController.subCategoryIndex].id.toString(), 2, type, true,
//                     );
//                   } else {
//                     catController.getCategoryProductList(
//                       catController.subCategoryIndex == 0 ? widget.categoryID
//                           : catController.subCategoryList![catController.subCategoryIndex].id.toString(), 1, 'uncooked', true,
//                     );
//                   }
//                 }
//               }),
//             ],
//           ),
//           endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
//           body: SingleChildScrollView(
//             child: Column(children: [
//
//               (catController.subCategoryList != null && !catController.isSearching) ? Center(child: Container(
//                 height: 40, width: Dimensions.webMaxWidth, color: Theme.of(context).cardColor,
//                 padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: catController.subCategoryList!.length,
//                   padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
//                   physics: const BouncingScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       onTap: () => catController.setSubCategoryIndex(index, widget.categoryID),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
//                         margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//                           color: index == catController.subCategoryIndex ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
//                         ),
//                         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//                           Text(
//                             catController.subCategoryList![index].name!,
//                             style: index == catController.subCategoryIndex
//                                 ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)
//                                 : robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
//                           ),
//                         ]),
//                       ),
//                     );
//                   },
//                 ),
//               )) : const SizedBox(),
//
//                      /*   Center(child: Container(
//                 width: Dimensions.webMaxWidth,
//                 color: Theme.of(context).cardColor,
//                 child: Align(
//                   alignment: ResponsiveHelper.isDesktop(context) ? Alignment.centerLeft : Alignment.center,
//                   child: Container(
//                     width: ResponsiveHelper.isDesktop(context) ? 350 : Dimensions.webMaxWidth,
//                     color: ResponsiveHelper.isDesktop(context) ? Colors.transparent : Theme.of(context).cardColor,
//                     child: TabBar(
//                       controller: _tabController,
//                       indicatorColor: Theme.of(context).primaryColor,
//                       indicatorWeight: 3,
//                       labelColor: Theme.of(context).primaryColor,
//                       unselectedLabelColor: Theme.of(context).disabledColor,
//                       unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
//                       labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
//                       tabs: [
//                         Tab(text: 'food'.tr),
//                         // Tab(text: 'restaurants'.tr),
//                       ],
//                     ),
//                   ),
//                 ),
//               )),*/
//               ProductViewWidget(
//                 isRestaurant: false, products: products, restaurants: null, noDataText: 'no_category_food_found'.tr,
//               ),
//
//                     /*    Expanded(child: NotificationListener(
//                 onNotification: (dynamic scrollNotification) {
//                   if (scrollNotification is ScrollEndNotification) {
//                     if((_tabController!.index == 1 && !catController.isRestaurant) || _tabController!.index == 0 && catController.isRestaurant) {
//                       catController.setRestaurant(_tabController!.index == 1);
//                       if(catController.isSearching) {
//                         catController.searchData(
//                           catController.searchText, catController.subCategoryIndex == 0 ? widget.categoryID
//                             : catController.subCategoryList![catController.subCategoryIndex].id.toString(), catController.type,
//                         );
//                       }else {
//                         if(_tabController!.index == 1) {
//                           catController.getCategoryRestaurantList(
//                             catController.subCategoryIndex == 0 ? widget.categoryID
//                                 : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
//                             1, catController.type, false,
//                           );
//                         }else {
//                           catController.getCategoryProductList(
//                             catController.subCategoryIndex == 0 ? widget.categoryID
//                                 : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
//                             1, catController.type, false,
//                           );
//                         }
//                       }
//                     }
//                   }
//                   return false;
//                 },
//                 child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     SingleChildScrollView(
//                       controller: scrollController,
//                       child: FooterViewWidget(
//                         child: Center(
//                           child: SizedBox(
//                             width: Dimensions.webMaxWidth,
//                             child: Column(
//                               children: [
//                                 ProductViewWidget(
//                                   isRestaurant: false, products: products, restaurants: null, noDataText: 'no_category_food_found'.tr,
//                                 ),
//
//                                 catController.isLoading ? Center(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
//                                     child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
//                                   ),
//                                 ) : const SizedBox(),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SingleChildScrollView(
//                       controller: restaurantScrollController,
//                       child: FooterViewWidget(
//                         child: Center(
//                           child: SizedBox(
//                             width: Dimensions.webMaxWidth,
//                             child: Column(
//                               children: [
//                                 ProductViewWidget(
//                                   isRestaurant: true, products: null, restaurants: restaurants, noDataText: 'no_category_restaurant_found'.tr,
//                                 ),
//
//                                 catController.isLoading ? Center(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
//                                     child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
//                                   ),
//                                 ) : const SizedBox(),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )),*/
//             ]),
//           ),
//         ),
//       );
//     });
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/hover_widgets/hover_zoom_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/home/widgets/restaurants_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/what_on_your_mind_view_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_view_widget_horizontal.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
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
import '../../../common/widgets/heading_widget.dart';
import '../../home/screens/cooked/cooked_whats_on_your_mind_widget.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/arrow_icon_button_widget.dart';

class CategoryProductScreen extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  const CategoryProductScreen({super.key, required this.categoryID, required this.categoryName});

  @override
  CategoryProductScreenState createState() => CategoryProductScreenState();
}

class CategoryProductScreenState extends State<CategoryProductScreen> with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController restaurantScrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CategoryController>().getCategoryList(true);
      Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
      // Get.find<CategoryController>().getFilCategoryList("1");
      Get.find<CategoryController>().getCategoryRestaurantList(
        widget.categoryID, 1,'', true,
      );
    });
    // Get.find<CategoryController>().getCategoryProductList(
    //   Get.find<CategoryController>().subCategoryIndex == 0 ? widget.categoryID
    //       : Get.find<CategoryController>().subCategoryList![Get.find<CategoryController>().subCategoryIndex].id.toString(),
    //   Get.find<CategoryController>().offset+1, Get.find<CategoryController>().type, false,
    // );

    // Get.find<CategoryController>().getCategoryRestaurantList(widget.categoryID,1, Get.find<CategoryController>().type, false,
    // );
    // Get.find<CategoryController>().getCategoryRestaurantList("1",1,"",false);
    print("check ======================> ");

    print("check ======================> ");



    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<CategoryController>().categoryProductList != null
          && !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          debugPrint('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryProductList(
            Get.find<CategoryController>().subCategoryIndex == 0 ? widget.categoryID
                : Get.find<CategoryController>().subCategoryList![Get.find<CategoryController>().subCategoryIndex].id.toString(),
            Get.find<CategoryController>().offset+1, Get.find<CategoryController>().type, false,
          );
        }
      }
    });
    restaurantScrollController.addListener(() {
      if (restaurantScrollController.position.pixels == restaurantScrollController.position.maxScrollExtent
          && Get.find<CategoryController>().categoryRestaurantList != null
          && !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().restaurantPageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          debugPrint('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryRestaurantList(
            Get.find<CategoryController>().subCategoryIndex == 0 ? widget.categoryID
                : Get.find<CategoryController>().subCategoryList![Get.find<CategoryController>().subCategoryIndex].id.toString(),
            Get.find<CategoryController>().offset+1, Get.find<CategoryController>().type, false,
          );
          print('========================>>>>>>>>> Check ');
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
            ) : Text(widget.categoryName, style: robotoRegular.copyWith(
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
          body: catController.categoryRestaurantList == null ?
              AppLoading() :
          CustomScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Center(child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      // Container(
                      //   width: Get.size.width,
                      //   padding: EdgeInsets.only(/*left:  ResponsiveHelper.isTab(context)  ? Dimensions.paddingSizeDefault : 200,
                      //      right:  ResponsiveHelper.isTab(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeDefault,*/
                      //       top:   Dimensions.paddingSizeSmall,
                      //       bottom:  ResponsiveHelper.isTab(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeDefault),
                      //   color: Theme.of(context).primaryColor.withOpacity(0.03),
                      //   child: Center(child: CategoryWhatOnYourMindViewWidget(),),
                      // ),

                    ]),
                  )),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverDelegate(
                      height: 60,
                      child: HeadingWidget(title: 'Top Restaurants & Cloud Kitchen',
                        tap: () {
                          Get.toNamed(RouteHelper.getAllRestaurantRoute('Top Vendors'));
                        },)
                  ),
                ),


                SliverToBoxAdapter(
                    child: Center(child: FooterViewWidget(
                      child: Column(
                        children: [
                          Padding(
                            padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.only(bottom: Dimensions.paddingSizeOverLarge),
                            child:  RestaurantsViewHorizontalWidget(isCooked: true,
                                categoryId: widget.categoryID,
                                categoryName: widget.categoryName,
                                products: products,
                                restaurants: catController.categoryRestaurantList),
                          ),
                        ],
                      ),
                    ))),


              ] ),
          // body: SingleChildScrollView(
          //   controller: scrollController,
          //   child: Column(children: [
          //     Container(
          //       width: Get.size.width,
          //       padding: EdgeInsets.only(/*left:  ResponsiveHelper.isTab(context)  ? Dimensions.paddingSizeDefault : 200,
          //       right:  ResponsiveHelper.isTab(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeDefault,*/
          //           top:   Dimensions.paddingSizeDefault,
          //           bottom:  ResponsiveHelper.isTab(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeDefault),
          //       color: Theme.of(context).primaryColor.withOpacity(0.03),
          //       child: Center(child: Column(
          //         children: [
          //           (catController.subCategoryList != null && !catController.isSearching) ? Center(child: Container(
          //             height: 130,
          //             width: Dimensions.webMaxWidth, /*color: Theme.of(context).cardColor,*/
          //             padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
          //             child: ListView.separated(
          //               scrollDirection: Axis.horizontal,
          //               itemCount: catController.subCategoryList!.length,
          //               padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
          //               physics: const BouncingScrollPhysics(),
          //               itemBuilder: (context, index) {
          //                 return InkWell(
          //                   onTap: () => catController.setSubCategoryIndex(index, widget.categoryID),
          //                   child: Container(
          //                     width:  90,
          //                     height: 90,
          //                     decoration: BoxDecoration(
          //                       color: Colors.transparent,
          //                       borderRadius: BorderRadius.circular(
          //                           Dimensions.radiusSmall),
          //                       border:
          //                       index == catController.subCategoryIndex ?
          //                       Border(
          //                           bottom: BorderSide(
          //                               color: Theme.of(context)
          //                                   .primaryColor,
          //                               width: 5.0))
          //                           : null,
          //                     ),
          //                     // padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
          //                     // margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
          //                     // decoration: BoxDecoration(
          //                     //   borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          //                     //   color: index == catController.subCategoryIndex ?
          //                     //   Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
          //                     // ),
          //                     child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //                       Container(
          //                         decoration: BoxDecoration(
          //                             borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          //                             color: Theme.of(context).cardColor,
          //                             boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, spreadRadius: 1)]
          //                         ),
          //                         child: ClipRRect( borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          //                           child: CachedNetworkImage(
          //                             height: ResponsiveHelper.isMobile(context) ? 70 : 100, width: ResponsiveHelper.isMobile(context) ? 70 : 100,
          //                             imageUrl: catController.subCategoryList != null &&
          //                                 index < catController.subCategoryList!.length &&
          //                                 catController.subCategoryList![index].name != "All" &&
          //                                 catController.subCategoryList![index].image != null &&
          //                                 catController.subCategoryList![index].image!.isNotEmpty
          //                                 ? '${Get.find<SplashController>().configModel?.baseUrls?.categoryImageUrl}/${catController.subCategoryList![index].image!}'
          //                                 : 'assets/image/dish-svgrepo-com.png', fit: BoxFit.cover,
          //                             placeholder: (context, url) => Image.asset( Images.placeholder, fit:  BoxFit.cover),
          //                             errorWidget: (context, url, error) => Image.asset('assets/image/dish-svgrepo-com.png'),
          //                           ),
          //                         ),
          //                       ),
          //                       SizedBox(height: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge),
          //                       Expanded(child: Text(
          //                         catController.subCategoryList![index].name!,
          //                         style: robotoMedium.copyWith(
          //                           fontSize: Dimensions.fontSizeSmall,
          //                           // color:Theme.of(context).textTheme.bodyMedium!.color,
          //                         ),
          //                         maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
          //                       )),
          //
          //                       // Column(
          //                       //   children: [
          //                       //     Container(
          //                       //       width:
          //                       //       ResponsiveHelper.isMobile(context)
          //                       //           ? 80
          //                       //           : 120,
          //                       //       height:
          //                       //       ResponsiveHelper.isMobile(context)
          //                       //           ? 80
          //                       //           : 120,
          //                       //       clipBehavior: Clip.hardEdge,
          //                       //       padding: const EdgeInsets.all(8),
          //                       //       decoration: const BoxDecoration(),
          //                       //       child: ClipOval(
          //                       //         child: CachedNetworkImage(
          //                       //           imageUrl: catController.subCategoryList != null &&
          //                       //               index < catController.subCategoryList!.length &&
          //                       //               catController.subCategoryList![index].name != "All" &&
          //                       //               catController.subCategoryList![index].image != null &&
          //                       //               catController.subCategoryList![index].image!.isNotEmpty
          //                       //               ? '${Get.find<SplashController>().configModel?.baseUrls?.categoryImageUrl}/${catController.subCategoryList![index].image!}'
          //                       //               : 'assets/image/dish-svgrepo-com.png',
          //                       //           fit: BoxFit.cover,
          //                       //           placeholder: (context, url) => Image.asset( Images.placeholder, fit:  BoxFit.cover),
          //                       //           errorWidget: (context, url, error) => Image.asset('assets/image/dish-svgrepo-com.png'),
          //                       //         ),
          //                       //       ),
          //                       //     ),
          //                       //     SizedBox(
          //                       //         height: ResponsiveHelper.isMobile(
          //                       //             context)
          //                       //             ? Dimensions.paddingSizeDefault
          //                       //             : Dimensions.paddingSizeLarge),
          //                       //     Text(
          //                       //       catController.subCategoryList![index].name!,
          //                       //       style: index == catController.subCategoryIndex
          //                       //           ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)
          //                       //           : robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          //                       //     ),
          //                       //   ],
          //                       // ),
          //                     ]),
          //                   ),
          //                 );
          //               }, separatorBuilder: (BuildContext context, int index)  => SizedBox(
          //                 width: ResponsiveHelper.isMobile(context)
          //                     ? 0
          //                     : Dimensions.paddingSizeDefault),
          //             ),
          //           )) :  WebWhatOnYourMindViewShimmer(categoryController: catController,),
          //         ],
          //       )),
          //     ),
          //     const SizedBox(height:Dimensions.paddingSizeDefault ,),
          //     FooterViewWidget(
          //       child: Center(
          //         child: SizedBox(
          //           width: Dimensions.webMaxWidth,
          //           child: Column(
          //             children: [
          //               RestaurantsViewHorizontalWidget(restaurants: catController.categoryRestaurantList),
          //               const SizedBox(height: Dimensions.paddingSizeDefault,),
          //               Padding(
          //                 padding: const EdgeInsets.only(
          //                   top:  Dimensions.paddingSizeOverLarge,
          //                   left:  Dimensions.paddingSizeExtraSmall,
          //                   right: Dimensions.paddingSizeExtraSmall,
          //                   bottom: Dimensions.paddingSizeDefault,
          //                 ),
          //                 child:
          //                 Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeDefault),
          //                   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Text("All Food Items", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600)),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //
          //               // RestaurantViewHorizontal(restaurants: catController.categoryRestaurantList),
          //               ProductViewWidget(
          //                 isRestaurant: false,
          //                 products: products,
          //                 restaurants: null,
          //                 noDataText: 'no_category_food_found'.tr,
          //                 // isTitle: true,
          //               ),
          //
          //               catController.isLoading ? Center(
          //                 child: Padding(
          //                   padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          //                   child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          //                 ),
          //               ) : const SizedBox(),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //
          //     // Center(child: Container(
          //     //   width: Dimensions.webMaxWidth,
          //     //   color: Theme.of(context).cardColor,
          //     //   child: Align(
          //     //     alignment: ResponsiveHelper.isDesktop(context) ? Alignment.centerLeft : Alignment.center,
          //     //     child: Container(
          //     //       width: ResponsiveHelper.isDesktop(context) ? 350 : Dimensions.webMaxWidth,
          //     //       color: ResponsiveHelper.isDesktop(context) ? Colors.transparent : Theme.of(context).cardColor,
          //     //       child: TabBar(
          //     //         controller: _tabController,
          //     //         indicatorColor: Theme.of(context).primaryColor,
          //     //         indicatorWeight: 3,
          //     //         labelColor: Theme.of(context).primaryColor,
          //     //         unselectedLabelColor: Theme.of(context).disabledColor,
          //     //         unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
          //     //         labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
          //     //         tabs: [
          //     //           Tab(text: 'food'.tr),
          //     //           Tab(text: 'restaurants'.tr),
          //     //         ],
          //     //       ),
          //     //     ),
          //     //   ),
          //     // )),
          //
          //     // Expanded(child: NotificationListener(
          //     //   onNotification: (dynamic scrollNotification) {
          //     //     if (scrollNotification is ScrollEndNotification) {
          //     //       if((_tabController!.index == 1 && !catController.isRestaurant) || _tabController!.index == 0 && catController.isRestaurant) {
          //     //         catController.setRestaurant(_tabController!.index == 1);
          //     //         if(catController.isSearching) {
          //     //           catController.searchData(
          //     //             catController.searchText, catController.subCategoryIndex == 0 ? widget.categoryID
          //     //               : catController.subCategoryList![catController.subCategoryIndex].id.toString(), catController.type,
          //     //           );
          //     //         }else {
          //     //           if(_tabController!.index == 1) {
          //     //             catController.getCategoryRestaurantList(
          //     //               catController.subCategoryIndex == 0 ? widget.categoryID
          //     //                   : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
          //     //               1, catController.type, false,
          //     //             );
          //     //           }else {
          //     //             catController.getCategoryProductList(
          //     //               catController.subCategoryIndex == 0 ? widget.categoryID
          //     //                   : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
          //     //               1, catController.type, false,
          //     //             );
          //     //           }
          //     //         }
          //     //       }
          //     //     }
          //     //     return false;
          //     //   },
          //     //   child: TabBarView(
          //     //     controller: _tabController,
          //     //     children: [
          //     //       FooterViewWidget(
          //     //         child: Center(
          //     //           child: SizedBox(
          //     //             width: Dimensions.webMaxWidth,
          //     //             child: Column(
          //     //               children: [
          //     //
          //     //                 ProductViewWidget(
          //     //                   isRestaurant: false, products: products, restaurants: null, noDataText: 'no_category_food_found'.tr,
          //     //                 ),
          //     //
          //     //                 catController.isLoading ? Center(
          //     //                   child: Padding(
          //     //                     padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          //     //                     child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          //     //                   ),
          //     //                 ) : const SizedBox(),
          //     //               ],
          //     //             ),
          //     //           ),
          //     //         ),
          //     //       ),
          //     //       FooterViewWidget(
          //     //         child: Center(
          //     //           child: SizedBox(
          //     //             width: Dimensions.webMaxWidth,
          //     //             child: Column(
          //     //               children: [
          //     //                 ProductViewWidget(
          //     //                   isRestaurant: true, products: null, restaurants: restaurants, noDataText: 'no_category_restaurant_found'.tr,
          //     //                 ),
          //     //
          //     //                 catController.isLoading ? Center(
          //     //                   child: Padding(
          //     //                     padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          //     //                     child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          //     //                   ),
          //     //                 ) : const SizedBox(),
          //     //               ],
          //     //             ),
          //     //           ),
          //     //         ),
          //     //       ),
          //     //     ],
          //     //   ),
          //     // )),
          //   ]),
          // ),
        ),
      );
    });
  }
}

class CategoryViewShimmer extends StatelessWidget {
  final CategoryController categoryController;

  const CategoryViewShimmer(
      {super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 7,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
                bottom: Dimensions.paddingSizeSmall,
                right: Dimensions.paddingSizeSmall,
                top: Dimensions.paddingSizeSmall),
            child: Container(
              width: 80,
              height: 80,
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
                        shape: BoxShape.circle,
                        // borderRadius:
                        // BorderRadius.circular(Dimensions.radiusSmall),
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
