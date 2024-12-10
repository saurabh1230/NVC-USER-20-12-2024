
import 'package:get/get.dart';
import 'package:stackfood_multivendor/api/repo/borzo_repo.dart';

import '../api/api_checker.dart';
import '../common/widgets/custom_snackbar_widget.dart';

class BorzoController extends GetxController implements GetxService {
  final BorzoRepo borzoRepo;
  BorzoController({required this.borzoRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getBorzoDeliveryFees(String address,
      String contactPersonName,
      String contactPersonNumber,
      String latitude,
      String longitude,
      String restaurantId,) async {
    _isLoading = true;
    update();
    Response response = await borzoRepo.getBorzoFee(address, contactPersonName, contactPersonNumber, latitude, longitude, restaurantId);
    if(response.statusCode == 200) {
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

}