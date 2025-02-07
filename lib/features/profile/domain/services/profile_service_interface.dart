
import 'package:non_veg_city/common/models/response_model.dart';
import 'package:non_veg_city/features/profile/domain/models/userinfo_model.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileServiceInterface {
  Future<UserInfoModel?> getUserInfo();
  Future<ResponseModel> updateProfile(UserInfoModel userInfoModel, XFile? data, String token);
  Future<ResponseModel> changePassword(UserInfoModel userInfoModel);
  Future<XFile?> pickImageFromGallery();
  Future<Response> deleteUser();
}