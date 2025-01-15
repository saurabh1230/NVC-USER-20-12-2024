import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/common/widgets/hover_widgets/hover_zoom_widget.dart';
import 'package:stackfood_multivendor/common/widgets/not_available_widget.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/product_view.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/place_order_body_model.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/features/product/controllers/product_controller.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/discount_tag_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../common/widgets/custom_button_widget.dart';


class ItemCardWidget extends StatelessWidget {
  final Product product;
  final bool? isBestItem;
  final bool? isPopularNearbyItem;
  final bool isCampaignItem;
  final bool? isAvailable;
  const ItemCardWidget({super.key, required this.product, this.isBestItem, this.isPopularNearbyItem = false, this.isCampaignItem = false, this.isAvailable = true});


  @override
  Widget build(BuildContext context) {
    print('CHECK AVAILABLE ${isAvailable}');
    double price = product.price!;
    double discount = product.discount!;
    double discountPrice = PriceConverter.convertWithDiscount(price, discount, product.discountType)!;
    bool desktop = ResponsiveHelper.isDesktop(context);
    bool? active = product.isActive;
    bool foodAvailable = DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds);
    bool foodStatus = !active! || !foodAvailable;

    CartModel cartModel = CartModel(
      null, price, discountPrice, (price - discountPrice),
      1, [], [], isCampaignItem, product, [], product.quantityLimit
    );




    return HoverZoom(
      child: Container(
        width: isPopularNearbyItem! ? double.infinity : 190,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(2, 5))],
        ),
        // decoration: BoxDecoration(
        //   color: Theme.of(context).cardColor,
        //   borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        // ),
        child: CustomInkWellWidget(
          onTap: () {
            ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
              ProductBottomSheetWidget(product: product, isCampaign: isCampaignItem,isActive: foodStatus,),
              backgroundColor: Colors.transparent, isScrollControlled: true,
            ) :
            // Get.dialog(
            //   Dialog(child: ProductViewScreen(product: product, isCampaign: isCampaignItem)),
            // );

            // Get.toNamed(RouteHelper.getProductViewRoute(product,isCampaign:isCampaignItem ));
            // Get.to(()=>ProductViewScreen(product: product, isCampaign: isCampaignItem));
            // Get.to(ProductViewScreen(product: product, isCampaign: isCampaignItem));
                // Get.toNamed( ProductViewScreen(product: product, isCampaign: isCampaignItem));
            // Get.dialog(
            //   Dialog(child: ProductBottomSheetWidget(product: product, isCampaign: isCampaignItem)),
            // );
            // print('')
            Get.dialog(
              Dialog(child: ProductBottomSheetWidget(product: product, isCampaign: false,
              isActive: foodStatus,)),
            );
          },
          radius: Dimensions.radiusDefault,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall, left: Dimensions.paddingSizeExtraSmall, right: Dimensions.paddingSizeExtraSmall),
                    child: ClipRRect(
                      borderRadius:  BorderRadius.circular(Dimensions.radiusDefault),
                      child: CustomImageWidget(
                        placeholder: Images.placeholder,
                        image: !isCampaignItem ? '${Get.find<SplashController>().configModel?.baseUrls?.productImageUrl}''/${product.image}'
                            : '${Get.find<SplashController>().configModel?.baseUrls?.campaignImageUrl}''/${product.image}',
                        height: desktop ? 130 :  100, width: desktop ? Get.size.width :  Get.size.width, fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  !isCampaignItem ? Positioned(
                    top: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
                    child: GetBuilder<FavouriteController>(builder: (favouriteController) {
                      bool isWished = favouriteController.wishProductIdList.contains(product.id);
                      return InkWell(
                        onTap: () {
                          if(Get.find<AuthController>().isLoggedIn()) {
                            isWished ? favouriteController.removeFromFavouriteList(product.id, false)
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

                  DiscountTagWidget(
                    discount: product.restaurantDiscount! > 0
                        ? product.restaurantDiscount
                        : product.discount,
                    discountType: product.restaurantDiscount! > 0 ? 'percent'
                        : product.discountType,
                    fromTop: Dimensions.paddingSizeSmall, fontSize: Dimensions.fontSizeExtraSmall,
                  ),
                  foodStatus
                      ? const NotAvailableWidget(isRestaurant: false)
                      : const SizedBox(),
                ],
              ),
                  const SizedBox(height: Dimensions.paddingSizeDefault,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeExtraSmall),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                      crossAxisAlignment:  CrossAxisAlignment.start,
                      children: [
                        Text(product.name!, style:robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                      maxLines: 1, overflow: TextOverflow.ellipsis,),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        Text(
                          product.restaurantName!,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: Colors.black.withOpacity(0.70),
                          ),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        Row(
                          mainAxisAlignment:  MainAxisAlignment.start,
                          children: [
                            Icon(Icons.star, color: Theme.of(context).primaryColor, size: 16),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            Text(product.avgRating!.toStringAsFixed(1), style: robotoMedium),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            Text('(${product.ratingCount})',style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                          ],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Wrap(
                          alignment: isBestItem == true ? WrapAlignment.center : WrapAlignment.start,
                          // mainAxisAlignment: isBestItem == true ? MainAxisAlignment.center : MainAxisAlignment.start,
                          children: [
                            discountPrice < price ? Text(PriceConverter.convertPrice(price),
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor, decoration: TextDecoration.lineThrough)): const SizedBox(),
                            discountPrice < price ? const SizedBox(width: Dimensions.paddingSizeExtraSmall) : const SizedBox(),

                            Text(PriceConverter.convertPrice(discountPrice), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)),
                          ],
                        ),],),),
                    Column(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GetBuilder<ProductController>(builder: (productController) {
                          return GetBuilder<CartController>(builder: (cartController) {
                            int cartQty = cartController.cartQuantity(product.id!);
                            int cartIndex = cartController.isExistInCart(product.id, null);

                            return cartQty != 0 ? Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                              ),
                              child: Row(children: [
                                InkWell(
                                  onTap: cartController.isLoading ? null : () {
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
                                    ),
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                    child: Icon(
                                      Icons.remove, size: 16, color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                  child: /*!cartController.isLoading ? */Text(
                                    cartQty.toString(),
                                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                                  )/* : const Center(child: SizedBox(height: 15, width: 15, child: CircularProgressIndicator(color: Colors.white)))*/,
                                ),

                                InkWell(
                                  onTap: cartController.isLoading ? null : () {
                                    cartController.setQuantity(true, cartModel, cartIndex: cartIndex);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                    child: Icon(
                                      Icons.add, size: 16, color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ]),
                            ) :
                            InkWell(
                              onTap: () {
                                if(isCampaignItem) {
                                  ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
                                    ProductBottomSheetWidget(product: product, isCampaign: true),
                                    backgroundColor: Colors.transparent, isScrollControlled: true,
                                  ) : Get.dialog(
                                    Dialog(child: ProductBottomSheetWidget(product: product, isCampaign: true)),
                                  );
                                } else {
                                  if(product.variations == null || (product.variations != null && product.variations!.isEmpty)) {

                                    productController.setExistInCart(product);

                                    OnlineCart onlineCart = OnlineCart(null, product.id, null, product.price!.toString(), [], 1, [], [], [], 'Food');

                                    if (Get.find<CartController>().existAnotherRestaurantProduct(cartModel.product!.restaurantId)) {
                                      Get.dialog(ConfirmationDialogWidget(
                                        icon: Images.warning,
                                        title: 'are_you_sure_to_reset'.tr,
                                        description: 'if_you_continue'.tr,
                                        onYesPressed: () {
                                          Get.find<CartController>().clearCartOnline().then((success) async {
                                            if (success) {
                                              await Get.find<CartController>().addToCartOnline(onlineCart);
                                              Get.back();
                                              _showCartSnackBar();
                                            }
                                          });
                                        },
                                      ), barrierDismissible: false);
                                    } else {
                                      Get.find<CartController>().addToCartOnline(onlineCart);
                                      _showCartSnackBar();
                                    }

                                  } else {
                                    ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
                                      ProductBottomSheetWidget(product: product, isCampaign: false),
                                      backgroundColor: Colors.transparent, isScrollControlled: true,
                                    ) : Get.dialog(
                                      Dialog(child: ProductBottomSheetWidget(product: product, isCampaign: false)),
                                    );
                                  }
                                }

                              },
                              child:  CustomButtonWidget(
                                height: 30,
                                fontSize: 12,
                                isBold: false,
                                transparent: true,
                                onPressed: () {
                                  if(foodStatus) {
                                    showCustomSnackBar('closed_now'.tr);
                                  } else {
                                    Get.find<ProductController>().productDirectlyAddToCart(product, context);
                                  }

                                  // if(isAvailable!) {
                                  //   showCustomSnackBar('Restaunt Currently Closed');
                                  //
                                  //
                                  // } else {
                                  //   Get.find<ProductController>().productDirectlyAddToCart(product, context);
                                  // }
                                },
                                buttonText: "Add to ",width:  desktop ? 80 : 75,),
                            );
                          });
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _showCartSnackBar() {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      dismissDirection: DismissDirection.horizontal,
      margin: ResponsiveHelper.isDesktop(Get.context) ?  EdgeInsets.only(
        right: Get.context!.width * 0.7,
        left: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall,
      ) : const EdgeInsets.all(Dimensions.paddingSizeSmall),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green,
      action: SnackBarAction(label: 'view_cart'.tr, textColor: Colors.white, onPressed: () {
        Get.toNamed(RouteHelper.getCartRoute());
      }),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      content: Text(
        'item_added_to_cart'.tr,
        style: robotoMedium.copyWith(color: Colors.white),
      ),
    ));
  }
}


class ItemCardShimmer extends StatelessWidget {
  final bool? isPopularNearbyItem;
  const ItemCardShimmer({super.key, this.isPopularNearbyItem});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: ResponsiveHelper.isMobile(context) ? 250 : 265,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: (isPopularNearbyItem! && ResponsiveHelper.isMobile(context)) ? 1 : 5,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
              child: Shimmer(
                duration: const Duration(seconds: 2),
                enabled: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 240, width: 190,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 133, width: 190,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                              child: Container(color: Colors.grey[300], ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(height: 10, width: 100, color:Colors.grey[300], ),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                Container(height: 10, width: 150, color: Colors.grey[300], ),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                Container(height: 10, width: 100, color: Colors.grey[300], ),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                Container(height: 10, width: 100, color: Colors.grey[ 300], ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
      ),
    );
  }
}
