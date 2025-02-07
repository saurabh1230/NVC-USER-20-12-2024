import 'package:non_veg_city/common/widgets/custom_search_field.dart';
import 'package:non_veg_city/common/widgets/search_web_menu_bar.dart';
import 'package:non_veg_city/features/auth/controllers/auth_controller.dart';
import 'package:non_veg_city/features/cart/controllers/cart_controller.dart';
import 'package:non_veg_city/features/home/screens/mobile_category_widget.dart';
import 'package:non_veg_city/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:non_veg_city/features/home/widgets/cuisine_card_widget.dart';
import 'package:non_veg_city/features/restaurant/widgets/heading_widget.dart';
import 'package:non_veg_city/features/search/controllers/search_controller.dart' as search;
import 'package:non_veg_city/features/search/widgets/filter_widget.dart';
import 'package:non_veg_city/common/widgets/search_field_widget.dart';
import 'package:non_veg_city/features/search/widgets/search_result_widget.dart';
import 'package:non_veg_city/features/splash/controllers/splash_controller.dart';
import 'package:non_veg_city/features/cuisine/controllers/cuisine_controller.dart';
import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/styles.dart';
import 'package:non_veg_city/common/widgets/bottom_cart_widget.dart';
import 'package:non_veg_city/common/widgets/custom_snackbar_widget.dart';
import 'package:non_veg_city/common/widgets/footer_view_widget.dart';
import 'package:non_veg_city/common/widgets/menu_drawer_widget.dart';
import 'package:non_veg_city/common/widgets/product_bottom_sheet_widget.dart';
import 'package:non_veg_city/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/responsive.dart';
import '../../home/widgets/what_on_your_mind_view_widget.dart';

class SearchScreen extends StatefulWidget {
  final FocusNode? focusNode;
  const SearchScreen({super.key, this.focusNode});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    Get.find<search.SearchController>().setSearchMode(true, canUpdate: false);
    if(_isLoggedIn) {
      Get.find<search.SearchController>().getSuggestedFoods();
    }
    Get.find<CuisineController>().getCuisineList();
    Get.find<search.SearchController>().getHistoryList();

    if (widget.focusNode != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(widget.focusNode);
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvoked: (val) async {
        if(Get.find<search.SearchController>().isSearchMode) {
        }else {
          Get.find<search.SearchController>().setSearchMode(true);
        }
      },
      child:  GetBuilder<search.SearchController>(builder: (searchController) {
        _searchController.text = searchController.searchText;
        return Scaffold(
          appBar:  WebSearchMenuBar(searchField:
            Expanded(child: SearchFieldWidget(
              focus: widget.focusNode,
            controller: _searchController,
            hint: 'search_food_or_restaurant'.tr,
            suffixIcon: !searchController.isSearchMode ? Icons.filter_list : Icons.search,
            iconPressed: () => _actionSearch(searchController, false),
            onSubmit: (text) => _actionSearch(searchController, true),
          )),
          ),
          endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
          body: SafeArea(child: /*GetBuilder<search.SearchController>(builder: (searchController) {

            return */
              Column(children: [
              // Container(
              //   width: Dimensions.webMaxWidth,
              //   height: ResponsiveHelper.isDesktop(context) ? 100 : 80,
              //   color: ResponsiveHelper.isDesktop(context) ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       if (ResponsiveHelper.isDesktop(context))
              //         ArrowIconButtonWidget(
              //           isLeft: true,
              //           paddingLeft: Dimensions.paddingSizeSmall,
              //           onTap: () {
              //             Get.back();
              //           },
              //         ),
              //       if (!ResponsiveHelper.isDesktop(context))
              //         const SizedBox(width: Dimensions.paddingSizeSmall), // Placeholder space for non-desktop
              //
              //       Spacer(), // Push the text to the center
              //       // const SizedBox(width: Dimensions.paddingSizeDefault,),
              //
              //       SizedBox(width: Dimensions.webMaxWidth,
              //         child: HeadingWidget(title:  'Search Food & Restaurants',
              //           tap: () {
              //             // Get.toNamed(RouteHelper.getAllRestaurantRoute('Top Vendors'));
              //           },),
              //       ),
              //       // Text(
              //       //   "Search Food & Restaurants",
              //       //   style: robotoBold.copyWith(
              //       //     fontSize: ResponsiveHelper.isMobile(context) ?Dimensions.fontSizeDefault :   Dimensions.fontSizeOverLarge,
              //       //     color: Colors.black.withOpacity(0.80),
              //       //   ),
              //       //   textAlign: TextAlign.center,
              //       // ),
              //
              //       const Spacer(), // Push the text to the center
              //
              //       if (ResponsiveHelper.isDesktop(context))
              //         const SizedBox(width: 0), // No extra space after text on desktop
              //       if (!ResponsiveHelper.isDesktop(context))
              //         const Expanded(child: SizedBox()), // Fill remaining space on non-desktop
              //     ],
              //   ),
              // ),

                // SizedBox(width: Dimensions.webMaxWidth,
                //   child: Row(
                //     children: [
                //       if (ResponsiveHelper.isDesktop(context))
                //         ArrowIconButtonWidget(
                //           isLeft: true,
                //           paddingLeft: Dimensions.paddingSizeSmall,
                //           onTap: () {
                //             Get.back();
                //           },
                //         ),
                //       SizedBox(width: Dimensions.paddingSizeExtraLarge,),
                //       Center(
                //         child: HeadingWidget(title:  'Search Food & Restaurants',
                //           tap: () {
                //             // Get.toNamed(RouteHelper.getAllRestaurantRoute('Top Vendors'));
                //           },),
                //       ),
                //     ],
                //   ),
                // ),
              Expanded(child: searchController.isSearchMode ? SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: FooterViewWidget(
                  child: SizedBox(width: Dimensions.webMaxWidth, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    searchController.historyList.isNotEmpty ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('recent_search'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

                      InkWell(
                        onTap: () => searchController.clearSearchAddress(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: 4),
                          child: Text('clear_all'.tr, style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error,
                          )),
                        ),
                      ),
                    ]) : const SizedBox(),

                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Wrap(
                      children: searchController.historyList.map((address) {
                        return Padding(
                          padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).disabledColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.6)),
                            ),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              InkWell(
                                onTap: () => searchController.searchData(address),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                  child: Text(
                                    address,
                                    style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5)),
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              InkWell(
                                onTap: () => searchController.removeHistory(searchController.historyList.indexOf(address)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                  child: Icon(Icons.close, color: Theme.of(context).disabledColor, size: 20),
                                ),
                              )
                            ]),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    (_isLoggedIn && searchController.suggestedFoodList != null) ? Text(
                      'recommended'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ) : const SizedBox(),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    (_isLoggedIn && searchController.suggestedFoodList != null) ? searchController.suggestedFoodList!.isNotEmpty ?  Wrap(
                      children: searchController.suggestedFoodList!.map((product) {
                        return Padding(
                          padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
                          child: InkWell(
                            onTap: () {
                              ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
                                ProductBottomSheetWidget(product: product),
                                backgroundColor: Colors.transparent, isScrollControlled: true,
                              ) : Get.dialog(
                                Dialog(child: ProductBottomSheetWidget(product: product)),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.6)),
                              ),
                              child: Text(
                                product.name!,
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ) : Padding(padding: const EdgeInsets.only(top: 10), child: Text('no_suggestions_available'.tr)) : const SizedBox(),
                    Container(
                      // color: Theme.of(context).primaryColor.withOpacity(0.10),
                      child: Center(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Categories",
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeOverLarge,
                                    color: Theme.of(context).primaryColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),*/
                          ResponsiveHelper.isMobile(context) ?
                          MobileWhatOnYourMindViewWidget() :
                          WhatOnYourMindViewWidget(isTitle: true,isBackButton: true,),

                        ],
                      ),),
                    ),



                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    /*   GetBuilder<CuisineController>(builder: (cuisineController) {
                    return (cuisineController.cuisineModel != null && cuisineController.cuisineModel!.cuisines!.isEmpty) ? const SizedBox() : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (cuisineController.cuisineModel != null) ? Text(
                          'cuisines'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                        ) : const SizedBox(),
                        const SizedBox(height: Dimensions.paddingSizeDefault),


                        (cuisineController.cuisineModel != null) ? cuisineController.cuisineModel!.cuisines!.isNotEmpty ? GetBuilder<CuisineController>(
                            builder: (cuisineController) {
                              return cuisineController.cuisineModel != null ? GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: ResponsiveHelper.isDesktop(context) ? 8 : ResponsiveHelper.isTab(context) ? 6 : 4,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 35 : 15,
                                    childAspectRatio: ResponsiveHelper.isDesktop(context) ? 1 : 0.9,
                                  ),
                                  shrinkWrap: true,
                                  itemCount: cuisineController.cuisineModel!.cuisines!.length,
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index){
                                    return InkWell(
                                      onTap: (){
                                        Get.toNamed(RouteHelper.getCuisineRestaurantRoute(cuisineController.cuisineModel!.cuisines![index].id, cuisineController.cuisineModel!.cuisines![index].name));
                                      },
                                      child: SizedBox(
                                        height: 130,
                                        child: CuisineCardWidget(
                                          image: '${Get.find<SplashController>().configModel!.baseUrls!.cuisineImageUrl}/${cuisineController.cuisineModel!.cuisines![index].image}',
                                          name: cuisineController.cuisineModel!.cuisines![index].name!,
                                        ),
                                      ),
                                    );
                                  }) : const Center(child: CircularProgressIndicator());
                            }
                        ) : Padding(padding: const EdgeInsets.only(top: 10), child: Text('no_suggestions_available'.tr)) : const SizedBox(),
                      ],
                    );
                  }
                  ),*/


                  ])),
                ),
              ) : SearchResultWidget(searchText: _searchController.text.trim())),





            ]),
         /* })*/
          ),
          bottomNavigationBar: GetBuilder<CartController>(builder: (cartController) {
            return cartController.cartList.isNotEmpty && !ResponsiveHelper.isDesktop(context) ? const BottomCartWidget() : const SizedBox();
          }),
        );
      }),

    );
  }

  void _actionSearch(search.SearchController searchController, bool isSubmit) {
    if(searchController.isSearchMode || isSubmit) {
      if(_searchController.text.trim().isNotEmpty) {
        searchController.searchData(_searchController.text.trim());
      }else {
        showCustomSnackBar('search_food_or_restaurant'.tr);
      }
    }
    else {
      List<double?> prices = [];
      if(!searchController.isRestaurant) {
        for (var product in searchController.allProductList!) {
          prices.add(product.price);
        }
        prices.sort();
      }
      double? maxValue = prices.isNotEmpty ? prices[prices.length-1] : 1000;
      ResponsiveHelper.isMobile(context) ?
      Get.bottomSheet(FilterWidget(maxValue: maxValue, isRestaurant: searchController.isRestaurant),
          isScrollControlled: true)
      :  Get.dialog(Dialog(
        insetPadding: const EdgeInsets.all(30),
        child: FilterWidget(maxValue: maxValue, isRestaurant: searchController.isRestaurant),
      ));
    }
  }
}
