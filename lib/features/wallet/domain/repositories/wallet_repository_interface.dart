import 'package:non_veg_city/features/wallet/domain/models/fund_bonus_model.dart';
import 'package:non_veg_city/features/wallet/domain/models/wallet_model.dart';
import 'package:non_veg_city/interface/repository_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class WalletRepositoryInterface extends RepositoryInterface{
  @override
  Future<WalletModel?> getList({int? offset, String sortingType});
  Future<Response> addFundToWallet(double amount, String paymentMethod);
  Future<List<FundBonusModel>?> getWalletBonusList();
  Future<void> setWalletAccessToken(String token);
  String getWalletAccessToken();
}