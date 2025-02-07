import 'package:non_veg_city/api/api_client.dart';
import 'package:non_veg_city/interface/repository_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';

abstract class RestaurantRegistrationRepoInterface extends RepositoryInterface{

  Future<Response> registerRestaurant(Map<String, String> data, XFile? logo, XFile? cover, List<MultipartDocument> additionalDocument);
}