import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/common/widgets/hover_widgets/hover_zoom_widget.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/widgets/heading_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/extensions.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
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
import '../../home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_horizontal_view_widget.dart';


class PetFoodAndBakeryFoodScreen extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  const PetFoodAndBakeryFoodScreen({super.key, required this.categoryID, required this.categoryName});

  @override
  PetFoodAndBakeryFoodScreenState createState() => PetFoodAndBakeryFoodScreenState();
}

class PetFoodAndBakeryFoodScreenState extends State<PetFoodAndBakeryFoodScreen> with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController restaurantScrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
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
            child: GetBuilder<CategoryController>(builder: (catController) {
              return Column(children: [
                Container(
                  width: Get.size.width,
                  padding: EdgeInsets.only(/*left:  ResponsiveHelper.isTab(context)  ? Dimensions.paddingSizeDefault : 200,
                right:  ResponsiveHelper.isTab(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeDefault,*/
                      top:   Dimensions.paddingSizeDefault,
                      bottom:  ResponsiveHelper.isTab(context)  ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeDefault),
                  color: Theme.of(context).primaryColor.withOpacity(0.03),
                  child: Center(child: Column(
                    children: [
                      SizedBox(width: Dimensions.webMaxWidth,
                        child: Column(
                          children: [
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
                                              // Get.back();
                                            },
                                          ),
                                        ),
                                      )
                                    else
                                      const Expanded(child: SizedBox()),

                                    const SizedBox(width: Dimensions.paddingSizeDefault,),

                                    Expanded(
                                      flex: 2, // Giving more space to the text to ensure it is centered
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
                            const SizedBox(height:Dimensions.paddingSizeDefault ,),
                            (catController.subCategoryList != null && !catController.isSearching) ? Center(child: Container(
                              height: ResponsiveHelper.isMobile(context) ? 160 : 200,
                              width: Dimensions.webMaxWidth, /*color: Theme.of(context).cardColor,*/
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                              child: Row(
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
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: catController.subCategoryList!.length,
                                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            catController.selectUncookedCategory(catController.subCategoryList![index].id!);
                                            catController.selectUncookedCategory(catController.subCategoryList![index].id!);
                                            catController.getCategoryRestaurantList(catController.subCategoryList![index].id.toString(), 1, '2', true,);
                                            catController.categoryName = catController.subCategoryList![index].name.toString();
                                            catController.categoryId = catController.subCategoryList![index].id.toString();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                                            margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    Dimensions.radiusSmall),
                                                border:
                                                catController.selectedUnCookedCategoryId ==
                                                    catController.subCategoryList![index].id
                                                    ? Border(
                                                    bottom: BorderSide(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        width: 5.0))
                                                    : null,
                                              ),
                                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                              Column(children: [HoverZoom(child: Container(width:
                                                      ResponsiveHelper.isMobile(context) ? 80 : 120,
                                                height: ResponsiveHelper.isMobile(context) ? 80 : 120,
                                                      clipBehavior: Clip.hardEdge,
                                                      padding: const EdgeInsets.all(8),
                                                      decoration: const BoxDecoration(),
                                                      child: ClipOval(
                                                        child: CachedNetworkImage(
                                                          imageUrl: catController.subCategoryList != null &&
                                                              index < catController.subCategoryList!.length &&
                                                              catController.subCategoryList![index].name != "All" &&
                                                              catController.subCategoryList![index].image != null &&
                                                              catController.subCategoryList![index].image!.isNotEmpty
                                                              ? '${Get.find<SplashController>().configModel?.baseUrls?.categoryImageUrl}/${catController.subCategoryList![index].image!}'
                                                              : 'assets/image/dish-svgrepo-com.png', fit: BoxFit.cover,
                                                          placeholder: (context, url) => Image.asset(Images.placeholder, fit:  BoxFit.cover),
                                                          errorWidget: (context, url, error) => Image.asset('assets/image/dish-svgrepo-com.png'),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: ResponsiveHelper.isMobile(
                                                          context)
                                                          ? Dimensions.paddingSizeDefault
                                                          : Dimensions.paddingSizeLarge),
                                                  Text(
                                                    catController.subCategoryList![index].name!,
                                                    style: index == catController.subCategoryIndex
                                                        ? robotoLight.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)
                                                        : robotoLight.copyWith(fontSize: Dimensions.fontSizeSmall),
                                                  ),
                                                ],
                                              ),
                                            ]),
                                          ),
                                        );
                                      },
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
                            )) :  CategoryViewShimmer(categoryController: catController,),
                          ],
                        ),
                      ),

                    ],
                  )),
                ),
                const SizedBox(height:Dimensions.paddingSizeDefault ,),
                FooterViewWidget(
                  child: Center(
                    child: SizedBox(
                      width: Dimensions.webMaxWidth,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              HeadingWidget(title: 'Top Vendors & Shops',
                                tap: () {
                                  Get.toNamed(RouteHelper.getAllRestaurantRoute('Top Vendors'));
                                },),
                              Padding(
                                padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.only(bottom: Dimensions.paddingSizeOverLarge,left: Dimensions.paddingSizeDefault,right: Dimensions.paddingSizeDefault),
                                child:  RestaurantsViewHorizontalWidget(isCooked: true,
                                  categoryName: Get.find<CategoryController>().categoryName,
                                  categoryId:   Get.find<CategoryController>().categoryId,
                                  restaurants: catController.categoryRestaurantList,),
                              ),
                            ],
                          ),

                          catController.isLoading ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                            ),
                          ) : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              ]);
            }),

          ),
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
      height: ResponsiveHelper.isMobile(context) ? 160 : 200,
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

