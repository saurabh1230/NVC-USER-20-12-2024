
import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/app_constants.dart';

import 'api_client.dart';

class BorzoRepo {
  final ApiClient apiClient;
  BorzoRepo({required this.apiClient});

  Future<Response> getBorzoFee(String address,
      // String contactPersonName,
      // String contactPersonNumber,
      String latitude,
      String longitude,
      String restaurantId,) {
    return apiClient.postUrlData(AppConstants.borzoFeeAmount,{
      "address": address,
      // "contact_person_name": contactPersonName,
      // "contact_person_number": contactPersonNumber,
      "latitude": latitude,
      "longitude": longitude,
      "restaurant_id" : restaurantId
    });
  }
}