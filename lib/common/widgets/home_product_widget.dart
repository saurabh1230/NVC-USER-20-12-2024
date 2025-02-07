import 'package:non_veg_city/common/widgets/custom_ink_well_widget.dart';
import 'package:non_veg_city/common/widgets/hover_widgets/hover_zoom_widget.dart';
import 'package:non_veg_city/common/widgets/not_available_widget.dart';
import 'package:non_veg_city/common/widgets/product_bottom_sheet_widget.dart';
import 'package:non_veg_city/features/auth/controllers/auth_controller.dart';
import 'package:non_veg_city/features/cart/controllers/cart_controller.dart';
import 'package:non_veg_city/features/restaurant/controllers/restaurant_controller.dart';
import 'package:non_veg_city/features/splash/controllers/splash_controller.dart';
import 'package:non_veg_city/features/cart/domain/models/cart_model.dart';
import 'package:non_veg_city/features/splash/domain/models/config_model.dart';
import 'package:non_veg_city/common/models/product_model.dart';
import 'package:non_veg_city/common/models/restaurant_model.dart';
import 'package:non_veg_city/features/favourite/controllers/favourite_controller.dart';
import 'package:non_veg_city/features/product/controllers/product_controller.dart';
import 'package:non_veg_city/helper/date_converter.dart';
import 'package:non_veg_city/helper/price_converter.dart';
import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/styles.dart';
import 'package:non_veg_city/common/widgets/custom_image_widget.dart';
import 'package:non_veg_city/common/widgets/custom_snackbar_widget.dart';
import 'package:non_veg_city/common/widgets/discount_tag_widget.dart';
import 'package:non_veg_city/common/widgets/discount_tag_without_image_widget.dart';
import 'package:non_veg_city/features/restaurant/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/checkout/widgets/order_place_button.dart';
import '../../features/restaurant/screens/restaurant_screen_web.dart';
import 'custom_button_widget.dart';

class HomeProductWidget extends StatelessWidget {
  final Product? product;
  final Restaurant? restaurant;
  final bool isRestaurant;
  final int index;
  final int? length;
  final bool inRestaurant;
  final bool isCampaign;
  final bool fromCartSuggestion;
  final bool? isActive;
  final bool? fromHomeProduct;
  const HomeProductWidget({super.key, required this.product, required this.isRestaurant, required this.restaurant, required this.index,
    required this.length, this.inRestaurant = false, this.isCampaign = false, this.fromCartSuggestion = false,  this.isActive, this.fromHomeProduct = false});

  @override
  Widget build(BuildContext context) {
    BaseUrls? baseUrls = Get.find<SplashController>().configModel!.baseUrls;
    bool desktop = ResponsiveHelper.isDesktop(context);
    double? discount;
    String? discountType;
    bool isAvailable;
    String? image ;
    double price = 0;
    double discountPrice = 0;
    bool foodAvailable = DateConverter.isAvailable(product!.availableTimeStarts, product!.availableTimeEnds);
    bool isClosed = fromHomeProduct == true
        ? (product?.isActive ?? false) == false  // Check if product is inactive if fromHomeProduct is true
        : (isActive == false);

    bool foodStatus = isClosed || !foodAvailable;


    print('Check Home Product TIme${foodAvailable}');
    if(isRestaurant  == true) {
      print('==================>  isRestaurant');
      image = restaurant!.logo;
      discount = restaurant!.discount != null ? restaurant!.discount!.discount : 0;
      discountType = restaurant!.discount != null ? restaurant!.discount!.discountType : 'percent';
      // bool _isClosedToday = Get.find<RestaurantController>().isRestaurantClosed(true, restaurant.active, restaurant.offDay);
      // _isAvailable = DateConverter.isAvailable(restaurant.openingTime, restaurant.closeingTime) && restaurant.active && !_isClosedToday;
      isAvailable = /*restaurant!.open == 1 &&*/ restaurant!.active! ;
      print('restaurant!.active! ${restaurant!.active!}');
    }else {
      print('==================>  product');
      image = product!.image;
      discount = (product!.restaurantDiscount == 0 || isCampaign) ? product!.discount : product!.restaurantDiscount;
      discountType = (product!.restaurantDiscount == 0 || isCampaign) ? product!.discountType : 'percent';
      print('=====>availableTimeStarts${product!.availableTimeStarts}');
      print('=====>availableTimeEnds${product!.availableTimeEnds}');
      isAvailable = DateConverter.isAvailable(product!.availableTimeStarts, product!.availableTimeEnds);
      price = product!.price!;
      discountPrice = PriceConverter.convertWithDiscount(price, discount, discountType)!;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: desktop ? 10 :10),
      child: HoverZoom(
        child: Stack(
          children: [
            Container(
              margin: desktop ? null : const EdgeInsets.only(bottom: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color:  Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(2, 5))],
              ),
              child: CustomInkWellWidget(
                onTap: () {
                  if(isRestaurant) {
                    if(restaurant != null && restaurant!.restaurantStatus == 1){
                      String slug = restaurant!.name!.toLowerCase().replaceAll(' ', '-');
                      Get.toNamed(RouteHelper.getRestaurantRoute(slug,restaurant!.id!),
                        arguments: RestaurantScreen(restaurant: restaurant),
                      );
                     ResponsiveHelper.isMobile(context) ? Get.toNamed(RouteHelper.getRestaurantRoute(slug,restaurant!.id!), arguments: RestaurantScreen(restaurant: restaurant)) :
                     Get.toNamed(RouteHelper.getRestaurantWebRoute(restaurant!.id), arguments: RestaurantScreenWeb(restaurant: restaurant));
                    }else if(restaurant!.restaurantStatus == 0){
                      showCustomSnackBar('restaurant_is_not_available'.tr);
                    }
                  }else {
                    if(product!.restaurantStatus == 1){
                      ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
                        ProductBottomSheetWidget(product: product, inRestaurantPage: inRestaurant, isCampaign: isCampaign,
                        isActive: foodStatus,),
                        backgroundColor: Colors.transparent, isScrollControlled: true,

                      ) :
                      // Get.toNamed(RouteHelper.getProductViewRoute(product,isCampaign:false ));
                      Get.dialog(
                        Dialog(child: ProductBottomSheetWidget(product: product, inRestaurantPage: inRestaurant,
                        isActive: foodStatus,)),
                      );
                    }else{
                      showCustomSnackBar('item_is_not_available'.tr);
                    }
                  }
                },
                radius: Dimensions.radiusDefault,
                child: Padding(
                  padding: desktop ? EdgeInsets.all(fromCartSuggestion ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall)
                      : const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [


                    Expanded(child: Padding(
                      padding: EdgeInsets.symmetric(vertical: desktop ? 0 : Dimensions.paddingSizeExtraSmall),
                      child: Column(
                        children: [
                          ((image != null && image.isNotEmpty) || isRestaurant) ? Stack(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              child: CustomImageWidget(
                                image: '${isCampaign ? baseUrls!.campaignImageUrl : isRestaurant ? baseUrls!.restaurantImageUrl
                                    : baseUrls!.productImageUrl}'
                                    '/${isRestaurant ? restaurant!.logo : product!.image}',
                                height: desktop ? 130 : length == null ? 100 : 100, width: desktop ? Get.size.width :  Get.size.width, fit: BoxFit.cover,
                              ),
                            ),
                            DiscountTagWidget(
                              discount: discount, discountType: discountType,
                              freeDelivery: isRestaurant ? restaurant!.freeDelivery : false,
                            ),


                            foodStatus
                                ? NotAvailableWidget(isRestaurant: isRestaurant)
                                : const SizedBox(),

                            // isAvailable ? const SizedBox() : NotAvailableWidget(isRestaurant: isRestaurant),
                            !isCampaign ? Positioned(
                              top: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
                              child: GetBuilder<FavouriteController>(builder: (favouriteController) {
                                bool isWished = favouriteController.wishProductIdList.contains(product!.id);
                                return InkWell(
                                  onTap: () {
                                    if(Get.find<AuthController>().isLoggedIn()) {
                                      isWished ? favouriteController.removeFromFavouriteList(product!.id, false)
                                          : favouriteController.addToFavouriteList(product, null, false);
                                    }else {
                                      showCustomSnackBar('you_are_not_logged_in'.tr);
                                    }
                                  },
                                  child: Icon(isWished ? Icons.favorite : Icons.favorite_border,
                                      color: isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, size: 20),
                                );
                              }
                              ),
                            ) : const SizedBox(),
                          ]) : const SizedBox.shrink(),
                          const SizedBox(height: Dimensions.paddingSizeDefault,),
                          Row(children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                  Flexible(
                                    child: Text(
                                      isRestaurant ? restaurant!.name! : product!.name!,
                                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                  // (!isRestaurant && Get.find<SplashController>().configModel!.toggle_cooked_uncooked!)
                                  //     ? Image.asset(product != null && product!.food_type == 1 ? Images.nonVegImage : Images.vegImage,
                                  //     height: 10, width: 10, fit: BoxFit.contain) : const SizedBox(),
                                ]),

                                SizedBox(height: isRestaurant ? 0 : Dimensions.paddingSizeExtraSmall),

                                Text(
                                  isRestaurant ? '' : product!.restaurantName ?? '',
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                    color: Colors.black.withOpacity(0.70),
                                  ),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),

                                isRestaurant ? Row(children: [
                                  Icon(Icons.star, size: 16, color: Theme.of(context).primaryColor),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                  Text(isRestaurant ? restaurant!.avgRating!.toStringAsFixed(1) : product!.avgRating!.toStringAsFixed(1), style: robotoMedium),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                  Text('(${isRestaurant ? restaurant!.ratingCount : product!.ratingCount})', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                                ]) : const SizedBox(),

                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                // SizedBox(height: (desktop || isRestaurant) ? 5 : 0),

                                // !isRestaurant ? RatingBar(
                                //   rating: isRestaurant ? restaurant!.avgRating : product!.avgRating, size: desktop ? 15 : 12,
                                //   ratingCount: isRestaurant ? restaurant!.ratingCount : product!.ratingCount,
                                // ) : const SizedBox(),
                                !isRestaurant ? Row(children: [
                                  Icon(Icons.star, size: 16, color: Theme.of(context).primaryColor),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                  Text(product!.avgRating!.toStringAsFixed(1), style: robotoMedium),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                  Text('(${product!.ratingCount})', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                                ]) : const SizedBox(),

                                SizedBox(height: (!isRestaurant && desktop) ? Dimensions.paddingSizeExtraSmall : 0),

                                isRestaurant ? Row(children: [
                                  Text(
                                    'start_from'.tr,
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                  Text(
                                    PriceConverter.convertPrice(restaurant!.minimumOrder!),
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w700, color: Theme.of(context).textTheme.bodyLarge!.color),
                                  ),

                                ],
                                ) : Wrap(children: [
                                  discount! > 0 ? Text(
                                    PriceConverter.convertPrice(product!.price), textDirection: TextDirection.ltr,
                                    style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                      color: Theme.of(context).disabledColor,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ) : const SizedBox(),
                                  SizedBox(width: discount> 0 ? Dimensions.paddingSizeExtraSmall : 0),
                                  Text(
                                    PriceConverter.convertPrice(product!.price, discount: discount, discountType: discountType),
                                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor), textDirection: TextDirection.ltr,
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  (image != null && image.isNotEmpty) ? const SizedBox.shrink() : DiscountTagWithoutImageWidget(discount: discount, discountType: discountType,
                                      freeDelivery: isRestaurant ? restaurant!.freeDelivery : false),
                                ]),
                              ]),
                            ),
                            Column(mainAxisAlignment: isRestaurant ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [

                              // fromCartSuggestion ? const SizedBox() : GetBuilder<FavouriteController>(builder: (favouriteController) {
                              //   bool isWished = isRestaurant ? favouriteController.wishRestIdList.contains(restaurant!.id)
                              //       : favouriteController.wishProductIdList.contains(product!.id);
                              //   return InkWell(
                              //     onTap: () {
                              //       if(Get.find<AuthController>().isLoggedIn()) {
                              //         isWished ? favouriteController.removeFromFavouriteList(isRestaurant ? restaurant!.id : product!.id, isRestaurant)
                              //             : favouriteController.addToFavouriteList(product, restaurant, isRestaurant);
                              //       }else {
                              //         showCustomSnackBar('you_are_not_logged_in'.tr);
                              //       }
                              //     },
                              //     child: Padding(
                              //       padding: EdgeInsets.symmetric(vertical: desktop ? Dimensions.paddingSizeSmall : 0),
                              //       child: Icon(
                              //         Icons.favorite,  size: desktop ? 30 : 25,
                              //         color: isWished ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.2),
                              //       ),
                              //     ),
                              //   );
                              // }),

                              !isRestaurant ? GetBuilder<CartController>(
                                  builder: (cartController) {
                                    int cartQty = cartController.cartQuantity(product!.id!);
                                    int cartIndex = cartController.isExistInCart(product!.id, null);
                                    CartModel cartModel = CartModel(
                                      null, price, discountPrice, (price - discountPrice),
                                      1, [], [], false, product, [], product?.quantityLimit,
                                    );
                                    return cartQty != 0 ? Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                                      ),
                                      child: Row(children: [
                                        InkWell(
                                          onTap: () {
                                            if (cartController.cartList[cartIndex].quantity! > 1) {
                                              cartController.setQuantity(false, cartModel, cartIndex: cartIndex);
                                            }else {
                                              cartController.removeFromCart(cartIndex);
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Theme.of(context).primaryColor),
                                            ),
                                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                            child: Icon(
                                              Icons.remove, size: 16, color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                          child: Text(
                                            cartQty.toString(),
                                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            // bool isClosed = fromHomeProduct == true
                                            //     ? (product?.isActive ?? false) == false  // Check if product is inactive if fromHomeProduct is true
                                            //     : (isActive == false);                   // Check if isActive is false otherwise

                                            if (foodStatus) {
                                              showCustomSnackBar('closed_now'.tr);
                                            } else {
                                              cartController.setQuantity(true, cartModel, cartIndex: cartIndex);
                                            }
                                            // if(!isActive!) {
                                            //   showCustomSnackBar('closed_now'.tr);
                                            // } else {
                                            //   cartController.setQuantity(true, cartModel, cartIndex: cartIndex);
                                            // }
                                          },
                                          // onTap: () {
                                          //   cartController.setQuantity(true, cartModel, cartIndex: cartIndex);
                                          //
                                          // },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Theme.of(context).primaryColor),
                                            ),
                                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                            child: Icon(
                                              Icons.add, size: 16, color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ) :
                                    CustomButtonWidget(
                                      height: 30,
                                      fontSize: 12,
                                      isBold: false,
                                      transparent: true,
                                      onPressed: () {
                                        // bool isClosed = fromHomeProduct == true
                                        //     ? (product?.isActive ?? false) == false  // Check if product is inactive if fromHomeProduct is true
                                        //     : (isActive == false);                   // Check if isActive is false otherwise

                                        if (foodStatus) {
                                          showCustomSnackBar('closed_now'.tr);
                                        } else {
                                          Get.find<ProductController>().productDirectlyAddToCart(product, context);
                                        }
                                      },

                                      buttonText: "Add to cart",width:  desktop ? 80 : 75,
                                    );
                                  }
                              ) : const SizedBox(),
                            ]),
                          ]),
                        ],
                      ),
                    )),

                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
