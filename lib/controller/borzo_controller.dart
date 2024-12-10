
import 'package:get/get.dart';
import 'package:stackfood_multivendor/api/repo/borzo_repo.dart';

import '../api/api_checker.dart';
import '../common/models/borzo_delivery_fee_model.dart';
import '../common/widgets/custom_snackbar_widget.dart';

class BorzoController extends GetxController implements GetxService {
  final BorzoRepo borzoRepo;
  BorzoController({required this.borzoRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  BorzoDeliveryFee? _borzoDeliveryFee;
  BorzoDeliveryFee? get borzoDeliveryFee => _borzoDeliveryFee;


  Future<void> getBorzoDeliveryFees(
      String address,
      // String contactPersonName,
      // String contactPersonNumber,
      String latitude,
      String longitude,
      String restaurantId,
      ) async {
    print('getBorzoDeliveryFees');
    _isLoading = true;
    update();

    Response response = await borzoRepo.getBorzoFee(
      address,
      // contactPersonName,
      // contactPersonNumber,
      latitude,
      longitude,
      restaurantId,
    );

    if (response.statusCode == 200) {
      // Parse the response and extract the payment_amount and delivery_fee_amount
      _borzoDeliveryFee = BorzoDeliveryFee.fromJson(response.body['data']['order']);
      print('Delivery Amount ${borzoDeliveryFee!.deliveryFeeAmount}');
    } else {
      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    update();
  }


}