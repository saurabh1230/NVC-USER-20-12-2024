import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:non_veg_city/common/models/response_model.dart';
import 'package:non_veg_city/common/widgets/custom_snackbar_widget.dart';
import 'package:non_veg_city/features/auth/domain/reposotories/auth_repo.dart';
import 'package:non_veg_city/features/cart/controllers/cart_controller.dart';
import 'package:non_veg_city/features/profile/controllers/profile_controller.dart';
import 'package:non_veg_city/features/splash/controllers/splash_controller.dart';
import 'package:non_veg_city/features/auth/domain/models/signup_body_model.dart';
import 'package:non_veg_city/features/auth/domain/models/social_log_in_body_model.dart';
import 'package:non_veg_city/features/auth/domain/services/auth_service_interface.dart';
import 'package:get/get.dart';
import 'package:non_veg_city/helper/address_helper.dart';
import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/app_constants.dart';

class AuthController extends GetxController implements GetxService {
  final AuthServiceInterface authServiceInterface;
  final AuthRepo authrepo;
  AuthController({required this.authServiceInterface, required this.authrepo }) {
    _notification = authServiceInterface.isNotificationActive();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _guestLoading = false;
  bool get guestLoading => _guestLoading;

  bool _acceptTerms = true;
  bool get acceptTerms => _acceptTerms;

  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  bool _notification = true;
  bool get notification => _notification;


  String _verificationCode = '';
  String get verificationCode => _verificationCode;


  Future<ResponseModel> login(String? phone, String password, {bool alreadyInApp = false}) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await authServiceInterface.login(phone: phone, password: password,customerVerification: Get.find<SplashController>().configModel!.customerVerification!, alreadyInApp: alreadyInApp);
    if(responseModel.isSuccess) {
      Get.find<ProfileController>().getUserInfo();
      Get.find<CartController>().getCartDataOnline();
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> registration(SignUpBodyModel signUpModel) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await authServiceInterface.registration(signUpModel, Get.find<SplashController>().configModel!.customerVerification!);
    _isLoading = false;
    update();
    return responseModel;
  }

  void saveUserNumberAndPassword(String number, String password, String countryCode) {
    authServiceInterface.saveUserNumberAndPassword(number, password, countryCode);
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authServiceInterface.clearUserNumberAndPassword();
  }

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  String getUserCountryCode() {
    return authServiceInterface.getUserCountryCode();
  }

  String getUserNumber() {
    return authServiceInterface.getUserNumber();
  }

  String getUserPassword() {
    return authServiceInterface.getUserPassword();
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  Future<ResponseModel> guestLogin() async {
    _guestLoading = true;
    update();
    ResponseModel responseModel = await authServiceInterface.guestLogin();
    _guestLoading = false;
    update();
    return responseModel;
  }

  Future<void> loginWithSocialMedia(SocialLogInBodyModel socialLogInBody) async {
    _isLoading = true;
    update();
    await authServiceInterface.loginWithSocialMedia(socialLogInBody, isCustomerVerificationOn: Get.find<SplashController>().configModel!.customerVerification!);
    _isLoading = false;
    update();
  }

  Future<void> registerWithSocialMedia(SocialLogInBodyModel socialLogInModel) async {
    _isLoading = true;
    update();
    await authServiceInterface.registerWithSocialMedia(socialLogInModel, isCustomerVerificationOn: Get.find<SplashController>().configModel!.customerVerification!);
    _isLoading = false;
    update();
  }

  Future<void> updateToken() async {
    await authServiceInterface.updateToken();
  }

  bool isLoggedIn() {
    return authServiceInterface.isLoggedIn();
  }

  String getGuestId() {
    return authServiceInterface.getGuestId();
  }

  bool isGuestLoggedIn() {
    return authServiceInterface.isGuestLoggedIn() && !authServiceInterface.isLoggedIn();
  }

  void saveDmTipIndex(String i){
    authServiceInterface.saveDmTipIndex(i);
  }

  String getDmTipIndex() {
    return authServiceInterface.getDmTipIndex();
  }

  Future<void> socialLogout() async {
    await authServiceInterface.socialLogout();
  }

  bool clearSharedData() {
    return authServiceInterface.clearSharedData();
  }

  bool setNotificationActive(bool isActive) {
    _notification = isActive;
    authServiceInterface.setNotificationActive(isActive);
    update();
    return _notification;
  }

  String getUserToken() {
    return authServiceInterface.getUserToken();
  }

  Future<void> saveGuestNumber(String number) async {
    authServiceInterface.saveGuestNumber(number);
  }

  String getGuestNumber() {
    return authServiceInterface.getGuestNumber();
  }


  void updateVerificationCode(String query, {bool canUpdate = true}) {
    _verificationCode = query;
    if(canUpdate){
      update();
    }
  }

  Future<void> handleResponse(SignUpBodyModel signUpBody, String countryCode, context) async {
  _isLoading = true;
  update();
  String numberWithCountryCode = signUpBody.phone!;
  
  // Define the API endpoint
  final Uri url = Uri.parse('${AppConstants.baseUrl}/api/v1/auth/sign-up');
  
  // Define headers
  Map<String, String> headers = {
    'Content-Type': 'application/json', // Adjust content type if necessary
  };
  
  try {
    // Show loading indicator
    print("SignUpBody: ${signUpBody.toJson()}"); // Log request body
    print("Request URL: $url"); // Log the request URL
    print("Request Headers: $headers"); // Log the request headers
    
    // Send POST request
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(signUpBody), // Encode the body to JSON
    );
    
    print("Response Status Code: ${response.statusCode}"); // Log the status code
    print("Response Body: ${response.body}"); // Log the response body
    
    // Handle the response
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      
      String token = responseBody['token']; // Extract the token
      int isPhoneVerified = responseBody['is_phone_verified'];
      String phoneVerifyEndUrl = responseBody['phone_verify_end_url'];
      
      // Handle customer verification logic
      if (Get.find<SplashController>().configModel!.customerVerification!) {
        List<int> encoded = utf8.encode(signUpBody.password!);
        String data = base64Encode(encoded);
        print('Check one');
        // Navigate to the verification route with token
        Get.toNamed(
          RouteHelper.getVerificationRoute(
            numberWithCountryCode,
            token,
            RouteHelper.signUp,
            data,
          ),
        );
      } else {
                print('Check two');
        // No verification required, go to profile or location screen
        Get.find<ProfileController>().getUserInfo();
        Get.find<SplashController>().navigateToLocationScreen(RouteHelper.signUp);
        if (ResponsiveHelper.isDesktop(context)) {
          Get.back();
        }
      }
    } else {
         print('Check three');
      // Handle errors
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('errors')) {
        String errorMessage = responseBody['errors'][0]['message'];
        print("Error: $errorMessage"); // Log the error message
        showCustomSnackBar(errorMessage); // Show error in custom snackbar
      } else {
        print("Error: ${response.reasonPhrase}"); // Log generic error message
        showCustomSnackBar('Error: ${response.reasonPhrase}'); // Show generic error
      }
    }
  } catch (e) {
       print('Check four');
    // Handle exception
    print("Exception: $e"); // Log exception details
    showCustomSnackBar('Server is down, please try again later');
  } finally {
    _isLoading = false;
    update();
    // Hide loading indicator
  }
}


  bool _isloginLoading = false;
  bool get isloginLoading => _isloginLoading;

Future<Map<String, dynamic>?> loginUser({
  required String phone,
}) async {
  _isloginLoading = true;
  update();
  print("Loading: $_isloginLoading");

  try {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request(
        'POST', Uri.parse("https://nonvegcity.com/panel/api/v1/auth/login"));

    print('Check Guest Id ============== >  ${getGuestId()}');
    request.bodyFields = {
      'guest_id': getGuestId(),
      'phone': phone,
      'login_type': "otp",
      'type': "phone",
    };
    request.headers.addAll(headers);

    print("Request URL: ${request.url}");
    print("Request Headers: ${request.headers}");
    print("Request Body: ${request.bodyFields}");

    http.StreamedResponse response = await request.send();

    print("Response Status: ${response.statusCode}");
    print("Response Headers: ${response.headers}");
    String responseString = await response.stream.bytesToString();
    print("Response Body: $responseString");

    if (response.statusCode == 200) {
             _isloginLoading = false;
        update();
     await Get.toNamed(RouteHelper.getVerificationRoute(phone, '', RouteHelper.signUp, ''));
  
      // return jsonDecode(responseString);
    } else {
      var responseData = jsonDecode(responseString);
      if (responseData['errors'] != null && responseData['errors'].isNotEmpty) {
        String errorMessage = responseData['errors'][0]['message'];
      showCustomSnackBar(errorMessage);
      }
        _isloginLoading = false;
    update();
    }
  } catch (e) {
    print("Exception: $e");
   
    return null;
  } finally {
    _isloginLoading = false;
    update();
    print("Loading: $_isloginLoading");
  }
}


  bool _isVerifyLoading = false;
  bool get isVerifyLoading => _isVerifyLoading;

  Future<Map<String, dynamic>?> verifyPhoneLogin({
  required String phone,
  required String otp,
}) async {
  _isVerifyLoading = true;
  update();
  print("Loading: $_isVerifyLoading");

  try {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request('POST', Uri.parse("https://nonvegcity.com/panel/api/v1/auth/verify-phone"));

    request.bodyFields = {
      'guest_id': Get.find<AuthController>().getGuestId(),
      'phone': phone,
      'login_type': "otp",
      'verification_type': "phone",
      'otp': otp,
    };
    request.headers.addAll(headers);

    print("Request URL: ${request.url}");
    print("Request Headers: ${request.headers}");
    print("Request Body: ${request.bodyFields}");

    http.StreamedResponse response = await request.send();

    print("Response Status: ${response.statusCode}");
    print("Response Headers: ${response.headers}");
    String responseString = await response.stream.bytesToString();
    print("Response Body: $responseString");

    if (response.statusCode == 200) {
      var responseData = jsonDecode(responseString);

      if (responseData['token'] != null) {
        String token = responseData['token'];
        await authrepo.saveUserToken(token);
        await authrepo.updateToken();
        Get.find<ProfileController>().getUserInfo();
        Get.find<CartController>().getCartDataOnline();
        print("Token Saved: $token");
        await Get.find<SplashController>().navigateToLocationScreen('sign-in', offNamed: true);
      } else {
        print("Error: Token is missing in the response");
      }
    } else if (response.statusCode == 404) {
      // Handle incorrect OTP error
      var responseData = jsonDecode(responseString);
      String errorMessage = responseData['message'] ?? "OTP verification failed";
      print("Error: $errorMessage");
      showCustomSnackBar(errorMessage);
    } else {
      print("Error: ${response.reasonPhrase}");
      showCustomSnackBar(response.reasonPhrase ?? "Something went wrong");
    }
  } catch (e) {
    print("Exception: $e");
    showCustomSnackBar("Unexpected error occurred. Please try again.");
  } finally {
    _isVerifyLoading = false;
    update();
    print("Loading: $_isVerifyLoading");
  }
}





}