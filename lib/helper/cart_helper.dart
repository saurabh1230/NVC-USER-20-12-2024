import 'package:stackfood_multivendor/common/models/online_cart_model.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/place_order_body_model.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart' as pv;
import 'package:stackfood_multivendor/helper/price_converter.dart';

class CartHelper {
  static List<OrderVariation> getSelectedVariations ({required List<pv.Variation>? productVariations, required List<List<bool?>> selectedVariations}) {
    List<OrderVariation> variations = [];
    for(int i=0; i<productVariations!.length; i++) {
      if(selectedVariations[i].contains(true)) {
        variations.add(OrderVariation(name: productVariations[i].name, values: OrderVariationValue(label: [])));
        for(int j=0; j<productVariations[i].variationValues!.length; j++) {
          if(selectedVariations[i][j]!) {
            variations[variations.length-1].values!.label!.add(productVariations[i].variationValues![j].level);
          }
        }
      }
    }

    return variations;
  }

  static getSelectedAddonIds({required List<AddOn> addOnIdList }) {
    List<int?> listOfAddOnId = [];
    for (var addOn in addOnIdList) {
      listOfAddOnId.add(addOn.id);
    }
    return listOfAddOnId;
  }

  static getSelectedAddonQtnList({required List<AddOn> addOnIdList }) {
    List<int?> listOfAddOnQty = [];
    for (var addOn in addOnIdList) {
      listOfAddOnQty.add(addOn.quantity);
    }
    return listOfAddOnQty;
  }



  static String setupVariationText({required CartModel cart}) {
    String variationText = '';

    if(cart.variations!.isNotEmpty) {
      for(int index=0; index<cart.variations!.length; index++) {
        if(cart.variations![index].isNotEmpty && cart.variations![index].contains(true)) {
          variationText = '$variationText${variationText.isNotEmpty ? ', ' : ''}${cart.product!.variations![index].name} (';

          for(int i=0; i<cart.variations![index].length; i++) {
            if(cart.variations![index][i]!) {
              variationText = '$variationText${variationText.endsWith('(') ? '' : ', '}${cart.product!.variations![index].variationValues![i].level}';
            }
          }
          variationText = '$variationText)';
        }
      }
    }

    return variationText;
  }

  static String? setupAddonsText({required CartModel cart}) {
    String addOnText = '';
    int index0 = 0;
    List<int?> ids = [];
    List<int?> qtys = [];
    for (var addOn in cart.addOnIds!) {
      ids.add(addOn.id);
      qtys.add(addOn.quantity);
    }
    for (var addOn in cart.product!.addOns!) {
      if (ids.contains(addOn.id)) {
        addOnText = '$addOnText${(index0 == 0) ? '' : ',  '}${addOn.name} (${qtys[index0]})';
        index0 = index0 + 1;
      }
    }
    return addOnText;
  }
}