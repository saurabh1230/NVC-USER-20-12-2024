import 'package:non_veg_city/common/models/response_model.dart';
import 'package:non_veg_city/features/profile/domain/models/userinfo_model.dart';
import 'package:non_veg_city/interface/repository_interface.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileRepositoryInterface extends RepositoryInterface {
  Future<ResponseModel> updateProfile(UserInfoModel userInfoModel, XFile? data, String token);
  Future<ResponseModel> changePassword(UserInfoModel userInfoModel);
}