import 'package:non_veg_city/features/address/domain/models/address_model.dart';
import 'package:non_veg_city/interface/repository_interface.dart';
import 'package:flutter/material.dart';

abstract class LanguageRepositoryInterface extends RepositoryInterface {

  AddressModel? getAddressFormSharedPref();
  void updateHeader(AddressModel? addressModel, Locale locale);
  Locale getLocaleFromSharedPref();
  void saveLanguage(Locale locale);
}