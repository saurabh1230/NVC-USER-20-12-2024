import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/common/widgets/not_available_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_product_route.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/features/product/controllers/product_controller.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/discount_tag_widget.dart';
import 'package:stackfood_multivendor/common/widgets/discount_tag_without_image_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductWidgetForRestaurant extends StatelessWidget {
  final Product? product;
  final Restaurant? restaurant;
  final int index;
  final int? length;
  final bool inRestaurant;
  final bool isCampaign;
  final bool fromCartSuggestion;
  const ProductWidgetForRestaurant({super.key, required this.product, required this.restaurant, required this.index,
    required this.length, this.inRestaurant = false, this.isCampaign = false, this.fromCartSuggestion = false});

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
    image = product!.image;
    discount = (product!.restaurantDiscount == 0 || isCampaign) ? product!.discount : product!.restaurantDiscount;
    discountType = (product!.restaurantDiscount == 0 || isCampaign) ? product!.discountType : 'percent';
    isAvailable = DateConverter.isAvailable(product!.availableTimeStarts, product!.availableTimeEnds);
    price = product!.price!;
    discountPrice = PriceConverter.convertWithDiscount(price, discount, discountType)!;

    return Padding(
      padding: EdgeInsets.only(bottom: desktop ? 0 :Dimensions.paddingSizeSmall),
      child: Container(
        margin: desktop ? null : const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(2, 5))],
        ),
        child: CustomInkWellWidget(
          onTap: () {
            Get.toNamed(RouteHelper.getRestaurantProductsRoute(restaurant!.id),
              arguments: RestaurantProductScreen(restaurant: restaurant, product: null, categoryName: '', categoryID: product!.categoryId.toString(),),
            );
            // if(isRestaurant) {
            //   if(restaurant != null && restaurant!.restaurantStatus == 1){
            //     Get.toNamed(RouteHelper.getRestaurantRoute(restaurant!.id), arguments: RestaurantScreen(restaurant: restaurant));
            //   }else if(restaurant!.restaurantStatus == 0){
            //     showCustomSnackBar('restaurant_is_not_available'.tr);
            //   }
            // }else {
            //   if(product!.restaurantStatus == 1){
            //     ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
            //       ProductBottomSheetWidget(product: product, inRestaurantPage: inRestaurant, isCampaign: isCampaign),
            //       backgroundColor: Colors.transparent, isScrollControlled: true,
            //     ) : Get.dialog(
            //       Dialog(child: ProductBottomSheetWidget(product: product, inRestaurantPage: inRestaurant)),
            //     );
            //   }else{
            //     showCustomSnackBar('item_is_not_available'.tr);
            //   }
            // }
          },
          radius: Dimensions.radiusDefault,
          child: Padding(
            padding: desktop ? EdgeInsets.all(fromCartSuggestion ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall)
                : const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

              Expanded(child: Padding(
                padding: EdgeInsets.symmetric(vertical: desktop ? 0 : Dimensions.paddingSizeExtraSmall),
                child: Row(children: [

                  ((image != null && image.isNotEmpty) ) ? Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: CustomImageWidget(
                        image: '${isCampaign ? baseUrls!.campaignImageUrl :  baseUrls!.productImageUrl}'
                            '/${product!.image}',
                        height: 230, width: 130, fit: BoxFit.cover,

                        // height: desktop ? 140 : length == null ? 120 : 120, width: desktop ? 140 : 100, fit: BoxFit.cover,
                      ),
                    ),
                    DiscountTagWidget(
                      discount: discount, discountType: discountType,
                      freeDelivery: false,
                    ),
                    // Positioned(bottom: Dimensions.paddingSizeSmall,right:  Dimensions.paddingSizeLarge,left:  Dimensions.paddingSizeLarge,
                    //   child: !isRestaurant ? GetBuilder<CartController>(
                    //       builder: (cartController) {
                    //         int cartQty = cartController.cartQuantity(product!.id!);
                    //         int cartIndex = cartController.isExistInCart(product!.id, null);
                    //         CartModel cartModel = CartModel(
                    //           null, price, discountPrice, (price - discountPrice),
                    //           1, [], [], false, product, [], product?.quantityLimit,
                    //         );
                    //         return cartQty != 0 ? Container(
                    //           decoration: BoxDecoration(
                    //             color: Theme.of(context).primaryColor,
                    //             borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                    //           ),
                    //           child: Row(children: [
                    //             InkWell(
                    //               onTap: () {
                    //                 if (cartController.cartList[cartIndex].quantity! > 1) {
                    //                   cartController.setQuantity(false, cartModel, cartIndex: cartIndex);
                    //                 }else {
                    //                   cartController.removeFromCart(cartIndex);
                    //                 }
                    //               },
                    //               child:
                    //               Container(
                    //                 decoration: BoxDecoration(
                    //                   color: Theme.of(context).cardColor,
                    //                   shape: BoxShape.circle,
                    //                   border: Border.all(color: Theme.of(context).primaryColor),
                    //                 ),
                    //                 padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    //                 child: Icon(
                    //                   Icons.remove, size: 16, color: Theme.of(context).primaryColor,
                    //                 ),
                    //               ),
                    //             ),
                    //
                    //             Padding(
                    //               padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    //               child: Text(
                    //                 cartQty.toString(),
                    //                 style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                    //               ),
                    //             ),
                    //
                    //             InkWell(
                    //               onTap: () {
                    //                 cartController.setQuantity(true, cartModel, cartIndex: cartIndex);
                    //               },
                    //               child: Container(
                    //                 decoration: BoxDecoration(
                    //                   color: Theme.of(context).cardColor,
                    //                   shape: BoxShape.circle,
                    //                   border: Border.all(color: Theme.of(context).primaryColor),
                    //                 ),
                    //                 padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    //                 child: Icon(
                    //                   Icons.add, size: 16, color: Theme.of(context).primaryColor,
                    //                 ),
                    //               ),
                    //             ),
                    //           ]),
                    //         ) : InkWell(
                    //           onTap: () => Get.find<ProductController>().productDirectlyAddToCart(product, context),
                    //           child: Container(
                    //               padding: const EdgeInsets.symmetric(vertical: 4),
                    //               decoration: BoxDecoration(
                    //                 color: Theme.of(context).primaryColor,
                    //                 borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    //                 // shape: BoxShape.circle,
                    //                 boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(2, 5))],
                    //               ),
                    //               child: Center(child: Text("ADD",style: robotoBold.copyWith(color: Theme.of(context).cardColor),))
                    //             // Icon(Icons.add, size: desktop ? 30 : 25, color: Theme.of(context).primaryColor),
                    //           ),
                    //         );
                    //       }
                    //   ) : const SizedBox(),
                    // ),
                    // isAvailable ? const SizedBox() : NotAvailableWidget(isRestaurant: isRestaurant),
                  ]) : const SizedBox.shrink(),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [

                      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Flexible(
                          child: Text(
                            product!.name!,
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault,
                                color: Colors.black.withOpacity(0.80)),
                            maxLines: 2, overflow: TextOverflow.ellipsis,

                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        // (!isRestaurant && Get.find<SplashController>().configModel!.toggleVegNonVeg!)
                        //     ? Image.asset(product != null && product!.veg == 0 ? Images.nonVegImage : Images.vegImage,
                        //     height: 10, width: 10, fit: BoxFit.contain) : const SizedBox(),
                      ]),

                      SizedBox(height:  Dimensions.paddingSizeExtraSmall),

                      Text(
                         product!.restaurantName ?? '',
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: Colors.black,
                        ),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),

                      // isRestaurant ? Row(children: [
                      //   Icon(Icons.star, size: 16, color: Theme.of(context).primaryColor),
                      //   const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      //
                      //   Text(isRestaurant ? restaurant!.avgRating!.toStringAsFixed(1) : product!.avgRating!.toStringAsFixed(1), style: robotoMedium),
                      //   const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      //
                      //   Text('(${isRestaurant ? restaurant!.ratingCount : product!.ratingCount})', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                      // ]) : const SizedBox(),

                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      // SizedBox(height: (desktop || isRestaurant) ? 5 : 0),

                      // !isRestaurant ? RatingBar(
                      //   rating: isRestaurant ? restaurant!.avgRating : product!.avgRating, size: desktop ? 15 : 12,
                      //   ratingCount: isRestaurant ? restaurant!.ratingCount : product!.ratingCount,
                      // ) : const SizedBox(),
                      // !isRestaurant ? Row(children: [
                      //   Icon(Icons.star, size: 16, color: Theme.of(context).primaryColor),
                      //   const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      //
                      //   Text(product!.avgRating!.toStringAsFixed(1), style: robotoMedium),
                      //   const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      //
                      //   Text('(${product!.ratingCount})', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                      // ]) : const SizedBox(),

                      SizedBox(height: 0),

                      Wrap(children: [

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
                            freeDelivery:  false),

                      ]),
                      SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                      Text(
                     product!.description ?? '',
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: Colors.black.withOpacity(0.60),
                        ),
                        maxLines: 3, overflow: TextOverflow.ellipsis,
                      ),

                    ]),
                  ),


                  Column(mainAxisAlignment:  MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [

                    fromCartSuggestion ? const SizedBox() : GetBuilder<FavouriteController>(builder: (favouriteController) {
                      bool isWished = favouriteController.wishProductIdList.contains(product!.id);
                      return InkWell(
                        onTap: () {
                          if(Get.find<AuthController>().isLoggedIn()) {
                            isWished ? favouriteController.removeFromFavouriteList( product!.id, false)
                                : favouriteController.addToFavouriteList(product, restaurant, false);
                          }else {
                            showCustomSnackBar('you_are_not_logged_in'.tr);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: desktop ? Dimensions.paddingSizeSmall : 0),
                          child: Icon(
                            Icons.favorite,  size: desktop ? 30 : 25,
                            color: isWished ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.2),
                          ),
                        ),
                      );
                    }),




                  ]),

                ]),
              )),


            ]),
          ),
        ),
      ),
    );
  }

}
