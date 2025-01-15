
import 'package:get/get.dart';


import '../api/api_checker.dart';
import '../api/borzo_repo.dart';

import '../common/models/borzo_fee_model.dart';
import '../common/widgets/custom_snackbar_widget.dart';

class BorzoController extends GetxController implements GetxService {
  final BorzoRepo borzoRepo;
  BorzoController({required this.borzoRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  BorzoDeliveryFee? _borzoDeliveryFee;
  BorzoDeliveryFee? get borzoDeliveryFee => _borzoDeliveryFee;

    String? _deliveryApproxStartTime;
  String? get deliveryApproxStartTime => _deliveryApproxStartTime;

  String? _deliveryApproxEndTime;
  String? get deliveryApproxEndTime => _deliveryApproxEndTime;
  


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

    print('Borzo headers ${response.headers}');
        print('Borzo body ${response.body}');

    if (response.statusCode == 200) {
      _borzoDeliveryFee = BorzoDeliveryFee.fromJson(response.body['data']['order']);
    // _deliveryApproxStartTime = response.body['data']['order']['points'][0]['required_start_datetime'];
    // _deliveryApproxEndTime = response.body['data']['order']['points'].last['required_finish_datetime'];
      print('Delivery Amount ${borzoDeliveryFee!.deliveryFeeAmount}');
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }


}