
import 'package:non_veg_city/common/widgets/hover_widgets/text_hover_widget.dart';
import 'package:non_veg_city/features/auth/controllers/auth_controller.dart';
import 'package:non_veg_city/features/auth/widgets/sign_in_widget.dart';

import 'package:non_veg_city/features/splash/controllers/splash_controller.dart';
import 'package:non_veg_city/features/splash/domain/models/config_model.dart';
import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/images.dart';
import 'package:non_veg_city/util/styles.dart';
import 'package:non_veg_city/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class

FooterViewWidget extends StatefulWidget {
  final Widget child;
  final double minHeight;
  final bool visibility;
  const FooterViewWidget({super.key, required this.child, this.minHeight = 0.65, this.visibility = true});

  @override
  State<FooterViewWidget> createState() => _FooterViewWidgetState();
}

class _FooterViewWidgetState extends State<FooterViewWidget> {
  final TextEditingController _newsLetterController = TextEditingController();
  final Color _color = Colors.black;
  final ConfigModel? _config = Get.find<SplashController>().configModel;

  @override
  Widget build(BuildContext context) {
    return Column( mainAxisAlignment: MainAxisAlignment.start, children: [
      ConstrainedBox(
        constraints: BoxConstraints(minHeight: (widget.visibility && ResponsiveHelper.isDesktop(context))
            ? MediaQuery.of(context).size.height * widget.minHeight : MediaQuery.of(context).size.height *0.7) ,
        child: Align(alignment: Alignment.topCenter, child: widget.child),
      ),

      (widget.visibility && ResponsiveHelper.isDesktop(context)) ? Container(
        // color: const Color(0xFF414141),
        color: Colors.white,
        width: context.width,
        margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
        child: Center(child: Column(children: [
          SizedBox(
            width: Dimensions.webMaxWidth,
            child: Column(
              children: [
                const SizedBox(height: Dimensions.paddingSizeDefault,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Image.asset(Images.webLogo, width: 180, ),
                    Row(crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(onTap: () {},
                            child: Image.asset("assets/image/googlemock.com.png",width: 120,)),
                        InkWell(onTap: () {},
                            child: Image.asset("assets/image/applemock.com.png",width: 120,))
                      ],),

                ],),
                const SizedBox(height: Dimensions.paddingSizeSmall,),
                const Divider(),
                Row(crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text('My Account', style: robotoBold.copyWith(color: _color, fontSize: Dimensions.fontSizeLarge)),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                TextHoverWidget(builder: (hovered) {
                                  return InkWell(
                                    hoverColor: Colors.transparent,
                                    onTap: () {
                                      if (Get.find<AuthController>().isLoggedIn()) {
                                        Get.toNamed(RouteHelper.getProfileRoute());
                                      }else{
                                        Get.dialog( const Center(child: SignInWidget(exitFromApp: false, backFromThis: true)));
                                      }
                                    },
                                    child: Text(Get.find<AuthController>().isLoggedIn() ? 'profile'.tr : 'login'.tr, style: hovered ? robotoBlack.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)
                                        : robotoMedium.copyWith(color:   Colors.black, fontSize: Dimensions.fontSizeSmall)),
                                  );
                                }),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                FooterButton(title: 'Your Account', route: RouteHelper.getProfileRoute()),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                FooterButton(title: 'My Cart', route: RouteHelper.getCartRoute()),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                FooterButton(title: 'live_chat'.tr, route: RouteHelper.getConversationRoute()),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                FooterButton(title: 'My Orders', route: RouteHelper.getOrderRoute()),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Quick Links', style: robotoBold.copyWith(color: _color, fontSize: Dimensions.fontSizeLarge)),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                _config!.refundPolicyStatus == 1 ? FooterButton(title: 'money_refund'.tr, route: RouteHelper.getHtmlRoute('refund-policy')) : const SizedBox(),
                                SizedBox(height: _config.refundPolicyStatus == 1 ? Dimensions.paddingSizeSmall : 0.0),
                                _config.shippingPolicyStatus == 1 ? FooterButton(title: 'shipping'.tr, route: RouteHelper.getHtmlRoute('shipping-policy')) : const SizedBox(),
                                SizedBox(height: _config.shippingPolicyStatus == 1 ? Dimensions.paddingSizeSmall : 0.0),
                                FooterButton(title: 'Terms and Condition', route: RouteHelper.getHtmlRoute('terms-and-condition')),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                FooterButton(title: 'Privacy Policy', route: RouteHelper.getHtmlRoute('privacy-policy')),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                FooterButton(title: 'Refund Policy', route: RouteHelper.getHtmlRoute('refund-policy')),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                FooterButton(title: 'Shipping Policy', route: RouteHelper.getHtmlRoute('shipping-policy')),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                FooterButton(title: 'About Us', route: RouteHelper.getHtmlRoute('about-us')),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Customer Service', style: robotoBold.copyWith(color: _color, fontSize: Dimensions.fontSizeLarge)),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                FooterButton(title: 'Contact', route: RouteHelper.getSupportRoute()),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                FooterButton(title: 'Location', route: RouteHelper.getAddressRoute()),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                FooterButton(title: 'Help Page', route: RouteHelper.getSupportRoute()),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                              ],
                            ),
                            (_config.appUrlAndroid != null || _config.appUrlIos != null) ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('get_app'.tr, style: robotoBold.copyWith(color: _color, fontSize: Dimensions.fontSizeSmall)),
                                const SizedBox(height: Dimensions.paddingSizeLarge),
                                _config.appUrlAndroid != null ? InkWell(
                                  onTap: () => _launchURL(_config.appUrlAndroid ?? ''),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                    child: Image.asset(Images.landingGooglePlay, height: 40, fit: BoxFit.contain),
                                  ),
                                ) : const SizedBox(),
                                _config.appUrlIos != null ? InkWell(
                                  onTap: () => _launchURL(_config.appUrlIos ?? ''),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                    child: Image.asset(Images.landingAppStore, height: 40, fit: BoxFit.contain),
                                  ),
                                ) : const SizedBox(),
                              ],
                            ) : const SizedBox(),

                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(flex: 4,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: Dimensions.paddingSizeDefault,),
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('subscribe_to_out_new_channel_to_get_latest_updates'.tr, style: robotoMedium.copyWith(color: _color, fontSize: Dimensions.fontSizeSmall)),
                            SizedBox(height: Dimensions.fontSizeExtraSmall,),
                            Container(
                              width: 300,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1,color: Theme.of(context).primaryColor),
                                color:   Theme.of(context).disabledColor.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)],
                              ),
                              child: Row(children: [
                                const SizedBox(width: 20),
                                Expanded(child: TextField(
                                  controller: _newsLetterController,
                                  expands: false,
                                  style: robotoMedium.copyWith(color: Colors.black, fontSize: Dimensions.fontSizeExtraSmall),
                                  decoration: InputDecoration(
                                      hintText: 'your_email_address'.tr,
                                      hintStyle: robotoRegular.copyWith(color: Colors.grey, fontSize: Dimensions.fontSizeExtraSmall),
                                      border: InputBorder.none,
                                      isCollapsed: true
                                  ),
                                  maxLines: 1,
                                )),
                                GetBuilder<SplashController>(builder: (splashController) {
                                  return InkWell(
                                    onTap: () {
                                      String email = _newsLetterController.text.trim().toString();
                                      if (email.isEmpty) {
                                        showCustomSnackBar('enter_email_address'.tr);
                                      }else if (!GetUtils.isEmail(email)) {
                                        showCustomSnackBar('enter_a_valid_email_address'.tr);
                                      }else{
                                        Get.find<SplashController>().subscribeMail(email).then((value) {
                                          if(value) {
                                            _newsLetterController.clear();
                                          }
                                        });
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 2,vertical: 2),
                                      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      child: !splashController.isLoading ? Text('subscribe'.tr, style: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeExtraSmall))
                                          : const SizedBox(height: 15, width: 20, child: CircularProgressIndicator(color: Colors.white)),
                                    ),
                                  );
                                }),
                              ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                ),
              ],
            ),
          ),
          Divider(thickness: 0.5, color: Theme.of(context).primaryColor, indent: 0, height: 0,),

          Container(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall ),
            color: Theme.of(context).disabledColor.withOpacity(0.03),
            child: Center(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '© ${_config.footerText ?? ''}',
                          style: robotoMedium.copyWith(color: _color, fontSize: Dimensions.fontSizeExtraSmall, fontWeight: FontWeight.w100),
                        ),

                      ],
                    ),
                  ),
                ),
              )
            ),
          ),

        ])),
      ) : const SizedBox.shrink(),

    ]);
  }

  _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class FooterButton extends StatelessWidget {
  final String title;
  final String route;
  final bool url;
  const FooterButton({super.key, required this.title, required this.route, this.url = false});

  @override
  Widget build(BuildContext context) {
    return TextHoverWidget(builder: (hovered) {
      return InkWell(
        hoverColor: Colors.transparent,
        onTap: route.isNotEmpty ? () async {
          if(url) {
            if(await canLaunchUrlString(route)) {
              launchUrlString(route, mode: LaunchMode.externalApplication);
            }
          }else {
            Get.toNamed(route);
          }
        } : null,
        child: Text(title,
            // style: robotoBlack.copyWith(fontSize: Dimensions.fontSizeDefault,color: Colors.black.withOpacity(0.70)),
            style: hovered ? robotoBlack.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)
            : robotoMedium.copyWith(color:  Colors.black, fontSize: Dimensions.fontSizeSmall)
        ),
      );
    });
  }
}