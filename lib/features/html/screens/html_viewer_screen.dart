import 'package:non_veg_city/common/widgets/web_page_title_widget.dart';
import 'package:non_veg_city/features/html/controllers/html_controller.dart';
import 'package:non_veg_city/features/html/enums/html_type.dart';
import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/helper/route_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/styles.dart';
import 'package:non_veg_city/common/widgets/custom_app_bar_widget.dart';
import 'package:non_veg_city/common/widgets/footer_view_widget.dart';
import 'package:non_veg_city/common/widgets/menu_drawer_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../home/widgets/arrow_icon_button_widget.dart';

class HtmlViewerScreen extends StatefulWidget {
  final HtmlType htmlType;
  const HtmlViewerScreen({super.key, required this.htmlType});

  @override
  State<HtmlViewerScreen> createState() => _HtmlViewerScreenState();
}

class _HtmlViewerScreenState extends State<HtmlViewerScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<HtmlController>().getHtmlText(widget.htmlType);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String htmlAboutContent = """
<h4>&nbsp;NonVegCity (NVC) is a non-veg aggregator platform that connects meat lovers with the best butchers, meat, chicken, fish markets, and restaurants in the city. Non Veg City is The Part Of CAT7 Business Group. Our mission is to provide a seamless and convenient experience for customers to order and enjoy high-quality non-veg products, while also supporting local businesses and promoting sustainable and ethical food practices. Our Vision: To create a one-stop-shop for all non-veg needs, providing a wide range of options, ease of ordering, and reliable delivery. We aim to revolutionize the way people purchase and enjoy non-veg products, promoting a culture of quality, convenience, and community. Key Features: - Wide range of non-veg products (Meat, Poultry, Fish, Seafood, Eggs, Pet Food, Pickles, Bakery etc.) - Partnered with local butchers, meat markets, and restaurants - Online ordering and delivery platform - Quality assurance and control measures - Customer reviews and ratings - Loyalty programs and promotions Target Audience: - Meat lovers and non-veg enthusiasts - Busy professionals and families - Foodies and adventurous eaters - Local businesses and restaurants</h4>
""";

    final String htmlTermsAndCondition = """
<h4>Terms of Use/Service</h4>

<h4>You are advised to read these Terms carefully. By accessing or using the NonVegCity (NVC) Platform, you are agreeing to these Terms and concluding a legally binding contract with CAT 7 Manpower Solutions Pvt. Ltd. and/or its affiliates (hereinafter collectively referred to as &ldquo;(NVC)&rdquo;. You may not use the Services if you do not accept the Terms or are unable to be bound by the Terms. Your use of the NVC Platform is at your own risk, including the risk that you might be exposed to content that is objectionable, or otherwise inappropriate.<br />
These Terms of Service (&ldquo;Agreement&rdquo;) apply to the use of website &ndash; www.nonvegcity.com (&quot;Website&quot;), the NVC mobile application on iOS or Android devices including phones, tablets or any other electronic device (&quot;NVC App&quot;); whereas the Website and the NVC App are together referred to as the &quot;NVC Platform&quot;.<br />
In order to use the Services, you must first agree to the Terms. You can accept the Terms by:</h4>

<ol>
	<li>
	<h4>Clicking to accept or agree to the Terms, where it is made available to you by NVC in the user interface for any particular Service; or</h4>
	</li>
	<li>
	<h4>Actually using the Services. In this case, you understand and agree that NVC will treat your use of the Services as acceptance of the Terms from that point onwards.</h4>
	</li>
</ol>

<h4>Definitions:</h4>

<h4>Customer</h4>

<h4>&ldquo;Customer&rdquo; or &ldquo;You&rdquo; or &ldquo;Your&rdquo; refers to you, as a customer of the Services. A customer is someone who accesses or uses the Services for the purpose of sharing, displaying, hosting, publishing, transacting, or uploading information or views or pictures and includes other persons jointly participating in using the Services including without limitation a user having access to &lsquo;Vendors (Cooked &amp; Uncooked)/Restaurants/Non Veg Food Suppliers business page&rsquo; to manage claimed business listings or otherwise.</h4>

<h4>Content</h4>

<h4>&ldquo;Content&rdquo; will include (but is not limited to) reviews, images, photos, audio, video, location data, nearby places, and all other forms of information or data. &ldquo;Your content&rdquo; or &ldquo;Customer Content&rdquo; means content that you upload, share or transmit to, through or in connection with the Services, such as likes, ratings, reviews, images, photos, messages, chat communication, profile information, or any other materials that you publicly display or displayed in your account profile. &ldquo;NVC Content&rdquo; means content that NVC creates and make available in connection with the Services including, but not limited to, visual interfaces, interactive features, graphics, design, compilation, computer code, products, software, aggregate ratings, reports and other usage-related data in connection with activities associated with your account and all other elements and components of the Services excluding Your Content and Third Party Content. &ldquo;Third Party Content&rdquo; means content that comes from parties other than NVC or its Customers, such as Vendors (Cooked &amp; Uncooked)/Restaurants/Food Suppliers Partners and is available on the Services.</h4>

<h4>Eligibility to use the services:</h4>

<ol>
	<li>
	<h4>You hereby represent and warrant that you are at least eighteen (18) years of age or above and are fully able and competent to understand and agree the terms, conditions, obligations, affirmations, representations, and warranties set forth in these Terms.</h4>
	</li>
	<li>
	<h4>Compliance with Laws. You are in compliance with all laws and regulations in the country in which you live when you access and use the Services. You agree to use the Services only in compliance with these Terms and applicable law, and in a manner that does not violate our legal rights or those of any third party(ies).</h4>
	</li>
</ol>

<h4>Changes to the terms</h4>

<h4>NVC may vary or amend or change or update these Terms, from time to time entirely at its own discretion. You shall be responsible for checking these Terms from time to time and ensure continued compliance with these Terms. Your use of NVC Platform after any such amendment or change in the Terms shall be deemed as your express acceptance to such amended/changed terms and you also agree to be bound by such changed/amended Terms.</h4>

<h4>Provision of the services being offered by NVC</h4>

<ol>
	<li>
	<h4>NVC is constantly evolving in order to provide the best possible experience and information to its Customers. You acknowledge and agree that the form and nature of the Services which NVC provides, may require affecting certain changes in it, therefore, NVC reserves the right to suspend/cancel, or discontinue any or all products or services at any time without notice, make modifications and alterations in any or all of its contents, products and services contained on the site without any prior notice.</h4>
	</li>
	<li>
	<h4>We, the software, or the software application store that makes the software available for download may include functionality to automatically check for updates or upgrades to the software. Unless your device, its settings, or computer software does not permit transmission or use of upgrades or updates, you agree that we, or the applicable software or software application store, may provide notice to you of the availability of such upgrades or updates and automatically push such upgrade or update to your device or computer from time-to-time. You may be required to install certain upgrades or updates to the software in order to continue to access or use the Services, or portions thereof (including upgrades or updates designed to correct issues with the Services). Any updates or upgrades provided to you by us under the Terms shall be considered part of the Services.</h4>
	</li>
	<li>
	<h4>You acknowledge and agree that if NVC disables access to your account, you may be prevented from accessing the Services, your account details or any files or other content, which is contained in your account.</h4>
	</li>
	<li>
	<h4>You acknowledge and agree that while NVC may not currently have set a fixed upper limit on the number of transmissions you may send or receive through the Services, NVC may set such fixed upper limits at any time, at NVC&rsquo;s discretion.</h4>
	</li>
	<li>
	<h4>In our effort to continuously improve the NVC Platform and Services, we undertake research and conduct experiments from time to time on various aspects of the Services and offerings, including our apps, websites, user interface and promotional campaigns. As a result of which, some Customers may experience features differently than others at any given time. This is for making the NVC Platform better, more convenient and easy to use, improving Customer experience, enhancing the safety and security of our services and offerings and developing new services and features.</h4>
	</li>
	<li>
	<h4>By using NVC&rsquo;s Services you agree to the following disclaimers:</h4>
	</li>
	<li>
	<h4>The Content on these Services is for informational purposes only. NVC disclaims any liability for any information that may have become outdated since the last time the particular piece of information was updated. NVC reserves the right to make changes and corrections to any part of the Content on these Services at any time without prior notice. NVC does not guarantee the quality of the Goods, the prices listed in menus or the availability of all menu items at any Vendors (Cooked &amp; Uncooked)/Restaurants/Food Suppliers/Merchant. Unless stated otherwise, all pictures and information contained on these Services are believed to be owned by or licensed to NVC. Please email a takedown request (by using the &ldquo;Contact Us&rdquo; link on the home page) to the webmaster if you are the copyright owner of any Content on these Services and you think the use of the above material violates Your copyright in any way. Please indicate the exact URL of the webpage in your request. We will verify and rectify or remove the same. All images shown here have been digitized by NVC team. No other party is authorized to reproduce or republish these digital versions in any format whatsoever without the prior written permission of NVC.</h4>
	</li>
	<li>
	<h4>Any certification, licenses or permits (&ldquo;Certification&rdquo;) or information in regard to such Certification that may be displayed on the Vendors (Cooked &amp; Uncooked)/Restaurants/Food Supplier&rsquo;s listing page on the NVC Platform is for informational purposes only. Such Certification is displayed by NVC on an &lsquo;as available&rsquo; basis that is provided to NVC by the Vendors (Cooked &amp; Uncooked)/Restaurants/Food Suppliers/partner(s)/Merchant(s). NVC does not make any warranties about the validity, authenticity, reliability and accuracy of such Certification or any information displayed in this regard. Any reliance by a Customer upon the Certification or information thereto shall be strictly at such Customer&rsquo;s own risk and NVC in no manner shall assume any liability whatsoever for any losses or damages in connection with the use of this information or for any inaccuracy, invalidity or discrepancy in the Certification or non-compliance of any applicable local laws or regulations by the Vendors (Cooked &amp; Uncooked)/Restaurants/Food Suppliers/Partners/Merchants&nbsp;</h4>
	</li>
	<li>
	<h4>NVC reserves the right to charge a subscription and/or membership fee in respect of any of its product or service and/or any other charge or fee on a per order level from Customers, in respect of any of its product or service on the NVC Platform anytime in future.</h4>
	</li>
	<li>
	<h4>NVC may from time to time introduce referral and/or incentive based programs for its Customers (Program). These Program(s) may be governed by their respective terms and conditions. By participating in the Program, Customers are bound by the Program terms and conditions as well as the NVC Platform terms. Further, NVC reserves the right to terminate / suspend the Customer&rsquo;s account and/or credits / points earned and/or participation of the Customer in the Program if NVC determines in its sole discretion that the Customer has violated the rules of the Program and/or has been involved in activities that are in contravention of the Program terms and/or NVC Platform terms or has engaged in activities which are fraudulent / unlawful in nature. Furthermore, NVC reserves the right to modify, cancel and discontinue its Program without notice to the Customer.</h4>
	</li>
	<li>
	<h4>NVC may from time to time offer to the Customers credits, promo codes, vouchers or any other form of cashback that NVC may decide at its discretion. NVC reserves the right to modify, convert, cancel and/or discontinue such credits, promo codes or vouchers, as it may deem fit.</h4>
	</li>
</ol>

<h4>Use of services by you or Customer:</h4>

<ol>
	<li>
	<h4>NVC Customer Account Including &lsquo;Business Listing&rsquo; on the service.</h4>
	</li>
	<li>
	<h4>You must create an account in order to use some of the features offered by the Services, including without limitation to &lsquo;Business listing&rsquo; on the service. Use of any personal information you provide to us during the account creation process is governed by our Privacy Policy. You must keep your password confidential and you are solely responsible for maintaining the confidentiality and security of your account, all changes and updates submitted through your account, and all activities that occur in connection with your account.</h4>
	</li>
	<li>
	<h4>You may also be able to register to use the Services by logging into your account with your credentials from certain third party social networking sites (e.g., Facebook, Instagram, Meta etc.). You confirm that you are the owner of any such social media account and that you are entitled to disclose your social media login information to us. You authorize us to collect your authentication information, and other information that may be available on or through your social media account consistent with your applicable settings and instructions.</h4>
	</li>
	<li>
	<h4>In creating an account and/or claiming your business&rsquo; listing, you represent to us that all information provided to us in such process is true, accurate and correct, and that you will update your information as and when necessary in order to keep it accurate. If you are creating an account or claiming a business listing, then you represent to us that you are the owner or authorized agent of such business. You may not impersonate someone else, create or use an account for anyone other than yourself, provide an email address other than your own, create multiple accounts or business listings except as otherwise authorized by us, or provide or use false information to obtain access to a business&rsquo; listing on the Services that you are not legally entitled to claim. You acknowledge that any false claiming of a business listing may cause NVC or third parties to incur substantial economic damages and losses for which you may be held liable and accountable.</h4>
	</li>
	<li>
	<h4>You are also responsible for all activities that occur in your account. You agree to notify us immediately of any unauthorized use of your account in order to enable us to take necessary corrective action. You also agree that you will not allow any third party to use your NVC account for any purpose and that you will be liable for such unauthorized access.</h4>
	</li>
	<li>
	<h4>By creating an account, you agree to receive certain communications in connection with NVC Platform or Services. For example, you might receive comments from other Customers or other Customers may follow the activity to do on your account. You can opt-out or manage your preferences regarding non-essential communications through account settings.</h4>
	</li>
</ol>

<h4>Others Terms:</h4>

<ol>
	<li>
	<h4>In order to connect you to certain Vendors (Cooked &amp; Uncooked)/Restaurants/Non Veg Food Suppliers, we provide value added telephony services through our phone lines, which are displayed on the specific Vendors (Cooked &amp; Uncooked)/Restaurants/Non Veg Food Suppliers listing page on the NVC Platform, which connect directly to Vendors (Cooked &amp; Uncooked)/Restaurants/Non Veg Food Suppliers phone lines. We record all information regarding this call including the voice recording of the conversation between you, and the Vendors (Cooked &amp; Uncooked)/Restaurants/Non Veg Food Suppliers (for internal billing tracking purposes and customer service improvement at the Vendors/Restaurants/Non Veg Food Suppliers end). If you do not wish that your information be recorded in such a manner, please do not use the telephone services provided by NVC. You explicitly agree and permit NVC to record all this information when you avail the telephony services through the NVC provided phone lines on the NVC Platform.</h4>
	</li>
	<li>
	<h4>You agree to use the Services only for purposes that are permitted by (a) the Terms and (b) any applicable law, regulation or generally accepted practices or guidelines in the relevant jurisdictions.</h4>
	</li>
	<li>
	<h4>You agree to use the data owned by NVC (as available on the Services or through any other means like API etc.) only for personal use/purposes and not for any commercial use (other than in accordance with &lsquo; Business Listing&rsquo; access) unless agreed to by/with NVC in writing.</h4>
	</li>
	<li>
	<h4>You agree not to access (or attempt to access) any of the Services by any means other than the interface that is provided by NVC, unless you have been specifically allowed to do so, by way of a separate agreement with NVC. You specifically agree not to access (or attempt to access) any of the Services through any automated means (including use of scripts or web crawlers) and shall ensure that you comply with the instructions set out present on the Services.</h4>
	</li>
	<li>
	<h4>You agree that you will not engage in any activity that interferes with or disrupts the Services (or the servers and networks which are connected to the Services). You shall not delete or revise any material or information posted by any other Customer(s), shall not engage in spamming, including but not limited to any form of emailing, posting or messaging that is unsolicited.</h4>
	</li>
</ol>

<h4>&nbsp;<br />
Content:</h4>

<ol>
	<li>
	<h4>Ownership of NVC Content and Proprietary Rights</h4>
	</li>
	<li>
	<h4>We are the sole and exclusive copyright owners of the Services and our Content. We also exclusively own the copyrights, trademarks, service marks, logos, trade names, trade dress and other intellectual and proprietary rights throughout the world (the &ldquo;IP Rights&rdquo;) associated with the Services and NVC Content, which may be protected by copyright, patent, trademark and other applicable intellectual property and proprietary rights and laws. You acknowledge that the Services contain original works and have been developed, compiled, prepared, revised, selected, and arranged by us and others through the application of methods and standards of judgment developed and applied through the expenditure of substantial time, effort, and money and constitutes valuable intellectual property of us and such others. You further acknowledge that the Services may contain information which is designated as confidential by NVC and that you shall not disclose such information without NVC prior written consent.</h4>
	</li>
	<li>
	<h4>You agree to protect NVC proprietary rights and the proprietary rights of all others having rights in the Services during and after the term of this agreement and to comply with all reasonable written requests made by us or our suppliers and licensors of content or otherwise to protect their and others&rsquo; contractual, statutory, and common law rights in the Services. You acknowledge and agree that NVC (or NVC&rsquo;s licensors or associates) own all legal right, title and interest in and to the Services, including any IP Rights which subsist in the Services (whether those rights happen to be registered or not, and wherever in the world those rights may exist). You further acknowledge that the Services may contain information which is designated as confidential by NVC and that you shall not disclose such information without NVC&rsquo;s prior written consent. Unless you have agreed otherwise in writing with NVC, nothing in the Terms gives you a right to use any of NVC&rsquo;s trade names, trademarks, service marks, logos, domain names, and other distinctive brand features.</h4>
	</li>
	<li>
	<h4>You agree not to use any framing techniques to enclose any trademark or logo or other proprietary information of NVC; or remove, conceal or obliterate any copyright or other proprietary notice or source identifier, including without limitation, the size, colour, location or style of any proprietary mark(s). Any infringement shall lead to appropriate legal proceedings against you at an appropriate forum for seeking all available/possible remedies under applicable laws of the country of violation. You cannot modify, reproduce, publicly display or exploit in any form or manner whatsoever any of the NVC&rsquo;s Content in whole or in part except as expressly authorized by NVC.</h4>
	</li>
	<li>
	<h4>To the fullest extent permitted by applicable law, we neither warrant nor represent that your use of materials displayed on the Services will not infringe rights of third parties not owned by or affiliated with us. You agree to immediately notify us upon becoming aware of any claim that the Services infringe upon any copyright trademark, or other contractual, intellectual, statutory, or common law rights by following the instructions contained below.</h4>
	</li>
</ol>

<h4>Your License to NVC Content</h4>

<h4>We grant you a personal, limited, non-exclusive and non-transferable license to access and use the Services only as expressly permitted in these Terms. You shall not use the Services for any illegal purpose or in any manner inconsistent with these Terms. You may use information made available through the Services solely for your personal, non-commercial use. You agree not to use, copy, display, distribute, modify, broadcast, translate, reproduce, reformat, incorporate into advertisements and other works, sell, promote, create derivative works, or in any way exploit or allow others to exploit any of NVC Content in whole or in part except as expressly authorized by us. Except as otherwise expressly granted to you in writing, we do not grant you any other express or implied right or license to the Services, NVC Content or our IP Rights.<br />
Any violation by you of the license provisions contained in this Section may result in the immediate termination of your right to use the Services, as well as potential liability for copyright and other IP Rights infringement depending on the circumstances.</h4>

<ul>
	<li>
	<h4>NVC License to Your or Customer Content</h4>
	</li>
	<li>
	<h4>In consideration of availing the Services on the NVC Platform and by submitting Your Content, you hereby irrevocably grant NVC a perpetual, irrevocable, world-wide, non-exclusive, fully paid and royalty-free, assignable, sub-licensable and transferable license and right to use Your Content (including content shared by any business user having access to a &lsquo;Vendors/Restaurants/Food Suppliers business page&rsquo; to manage business listings or otherwise) and all IP Rights therein for any purpose including API partnerships with third parties and in any media existing now or in future. By &ldquo;use&rdquo; we mean use, copy, display, distribute, modify, translate, reformat, incorporate into advertisements and other works, analyze, promote, commercialize, create derivative works, and in the case of third party services, allow their users and others to do the same. You grant us the right to use the name or username that you submit in connection with Your Content. You irrevocably waive, and cause to be waived, any claims and assertions of moral rights or attribution with respect to Your Content brought against NVC or its Customers, any third party services and their users.</h4>
	</li>
	<li>
	<h4>Representations Regarding Your or Customer Content</h4>
	</li>
	<li>
	<h4>You are responsible for Your Content. You represent and warrant that you are the sole author of, own, or otherwise control all of the rights of Your Content or have been granted explicit permission from the rights holder to submit Your Content; Your Content was not copied from or based in whole or in part on any other content, work, or website; Your Content was not submitted via the use of any automated process such as a script bot; use of Your Content by us, third party services, and our and any third party users will not violate or infringe any rights of yours or any third party; Your Content is truthful and accurate; and Your Content does not violate the Guidelines and Policies or any applicable laws</h4>
	</li>
	<li>
	<h4>If Your Content is a review, you represent and warrant that you are the sole author of that review; the review reflects an actual dining experience that you had; you were not paid or otherwise remunerated in connection with your authoring or posting of the review; and you had no financial, competitive, or other personal incentive to author or post a review that was not a fair expression of your honest opinion.</h4>
	</li>
	<li>
	<h4>You assume all risks associated with Your Content, including anyone&rsquo;s reliance on its quality, accuracy, or reliability, or any disclosure by you of information in Your Content that makes you personally identifiable. While we reserve the right to remove Content, we do not control actions or Content posted by our Customers and do not guarantee the accuracy, integrity or quality of any Content. You acknowledge and agree that Content posted by Customers and any and all liability arising from such Content is the sole responsibility of the Customer who posted the content, and not NVC.</h4>
	</li>
	<li>
	<h4>Content Removal</h4>
	</li>
	<li>
	<h4>We reserve the right, at any time and without prior notice, to remove, block, or disable access to any Content that we, for any reason or no reason, consider to be objectionable, in violation of the Terms or otherwise harmful to the Services or our Customers in our sole discretion. Subject to the requirements of applicable law, we are not obligated to return any of Your Content to you under any circumstances. Further, the Vendors/Restaurants/Food Suppliers reserves the right to delete any images and pictures forming part of Customer Content, from such Vendors/Restaurants/Food Suppliers&rsquo; listing page at its sole discretion.</h4>
	</li>
	<li>
	<h4>Third Party Content and Links</h4>
	</li>
	<li>
	<h4>Some of the content available through the Services may include or link to materials that belong to third parties, such as third party reservation services or food delivery/ordering or dining out. Please note that your use of such third party services will be governed by the terms of service and privacy policy applicable to the corresponding third party. We may obtain business addresses, phone numbers, and other contact information from third party vendors who obtain their data from public sources.</h4>
	</li>
	<li>
	<h4>We have no control over, and make no representation or endorsement regarding the accuracy, relevancy, copyright compliance, legality, completeness, timeliness or quality of any product, services, advertisements and other content appearing in or linked to from the Services. We do not screen or investigate third party material before or after including it on our Services.</h4>
	</li>
	<li>
	<h4>We reserve the right, in our sole discretion and without any obligation, to make improvements to, or correct any error or omissions in, any portion of the content accessible on the Services. Where appropriate, we may in our sole discretion and without any obligation, verify any updates, modifications, or changes to any content accessible on the Services, but shall not be liable for any delay or inaccuracies related to such updates. You acknowledge and agree that NVC is not responsible for the availability of any such external sites or resources, and does not endorse any advertising, products or other materials on or available from such web sites or resources.</h4>
	</li>
	<li>
	<h4>Third party content, including content posted by our Customers or Vendors/Restaurants/Food Suppliers Partners, does not reflect our views or that of our parent, subsidiary, affiliate companies, branches, employees, officers, directors, or shareholders. In addition, none of the content available through the Services is endorsed or certified by the providers or licensors of such third party content. We assume no responsibility or liability for any of Your Content or any third party content.</h4>
	</li>
	<li>
	<h4>You further acknowledge and agree that NVC is not liable for any loss or damage which may be incurred by you as a result of the availability of those external sites or resources, or as a result of any reliance placed by you on the completeness, accuracy or existence of any advertising, products or other materials on, or available from, such websites or resources. Without limiting the generality of the foregoing, we expressly disclaim any liability for any offensive, defamatory, illegal, invasive, unfair, or infringing content provided by third parties.</h4>
	</li>
	<li>
	<h4>Customer Reviews</h4>
	</li>
	<li>
	<h4>Customer reviews or ratings for Vendors/Restaurants/Food Suppliers do not reflect the opinion of NVC. NVC receives multiple reviews or ratings for Vendors/Restaurants/Food Suppliers by Customers, which reflect the opinions of the Customers. It is pertinent to state that each and every review posted on NVC is the personal opinion of the Customer/reviewer only. NVC is a neutral platform, which solely provides a means of communication between Customers/reviewers including Customers or Vendors/Restaurants/Food Suppliers owners/representatives with access to business page. The advertisements published on the NVC Platform are independent of the reviews received by such advertisers.</h4>
	</li>
	<li>
	<h4>We are a neutral platform and we don&rsquo;t arbitrate disputes, however in case if someone writes a review that the Vendors/Restaurants/Food Suppliers do not consider to be true, the best option for the Vendors/Restaurants/Food Suppliers representative would be to contact the reviewer or post a public response in order to clear up any misunderstandings. If the Vendors/Restaurants/Food Suppliers believe that any particular Customer&rsquo;s review violates any of the NVC&rsquo;s policies, the Vendors/Restaurants/Food Suppliers may write to us at&nbsp;support@nonvegcity.com&nbsp;and bring such violation to our attention. NVC may remove the review in its sole discretion if review is in violation of the Terms, or content guidelines and policies or otherwise harmful to the Services</h4>
	</li>
</ul>
""";
    final String htmlPrivacyContent = """
 <ul>
	<li>
	<h4>www.nonvegcity.com values your privacy and respects your personal sphere of life. We are committed to maintaining your confidence and trust with respect to the information we collect about you. We maintain strict confidentiality and the data collected is only used to serve you better and to improve your overall experience.</h4>
	</li>
	<li>
	<h4>As part of the process, we also collect information of your Bank account, Tax identification number, etc., to facilitate payments. Sometimes we might also collect your information from external agencies or websites.</h4>
	</li>
	<li>
	<h4>We collect your personal information, location, contact details, interests, etc. As part of our policy, we also collect information about your credit and debit cards to facilitate payments. However, we do not store your card details. We only use services of established third party client/vendor for all payment-related services. As part of our marketing campaigns, we also collect your information from external agencies or websites, which, in turn, is used for client servicing and marketing.</h4>
	</li>
	<li>
	<h4>We understand that your privacy is important, and therefore, we endeavour to keep your personal information secured. The personal information of each cutomer/client is stored on servers that are behind a firewall and are housed within secured data centres provided by established global players.</h4>
	</li>
	<li>
	<h4>We use the data collected to improve our features, research and to facilitate secured payments. Our internal policies and systems protect your privacy by limiting unauthorized employee access to use of your personal information.</h4>
	</li>
	<li>
	<h4>Company also collects information through the use of cookies. Cookies are anonymous, and unique alphanumeric identifiers sent from our website and stored in your web browser while you are browsing. With the use of these cookies, we collect your Internet Protocol (IP) address used to connect your computer to internet. We collect information such as your browser type and version, operating system and the content you viewed or searched on the&nbsp;www.nonvegcity.com.</h4>
	</li>
	<li>
	<h4>In the event of you voluntarily disclosing personally identifiable information along with any substantive content on your social media page or NVC social media page, such activities are beyond the control of the company. Company does not monitor or secure such information that can be collected, correlated and used by third parties from sources that are not secured. This may also result in unsolicited messages from third parties</h4>
	</li>
	<li>
	<h4>Our website may contain links to other websites that are beyond our control. In the event of you choosing to access such websites, company is not responsible for any actions or policies of such third parties. We recommend to you to check the privacy policy of such websites before submitting any information with them.</h4>
	</li>
	<li>
	<h4>www.nonvegcity.com is a NonVeg platform and meant for general customers. We review our policies from time to time and make necessary changes whenever required. Any changes to our privacy policy will be posted on this page so that you are always aware of our policies.</h4>
	</li>
</ul>
""";
    final String htmlShippingContent = """
<h4>This shipping policy explains how Non Veg City (NVC) (doing business as &ldquo;NVC&rdquo;) operates its shipping procedures and how we strive to meet your expectations with every order. Whether you&rsquo;re a first-time buyer or a returning customer, we want to ensure that your experience with us is smooth and satisfactory, right from placing your order to the moment it arrives at your doorstep. This policy has been created with the help of the shipping policy generator.<br />
Please read this shipping policy together with our terms and conditions to familiarize yourself with the rest of our general guidelines.<br />
&nbsp;<br />
Table of contents</h4>

<ul>
	<li>
	<h4>&nbsp;Shipping and Delivery Options</h4>
	</li>
	<li>
	<h4>&nbsp;Delayed Orders</h4>
	</li>
	<li>
	<h4>&nbsp;Returns and Exchanges</h4>
	</li>
	<li>
	<h4>&nbsp;Contact Information</h4>
	</li>
</ul>

<h4>&nbsp;<br />
Shipping and Delivery Options</h4>

<h4>We offer a variety of shipping options to suit the needs of our customers.<br />
&nbsp;<br />
Free Shipping<br />
&nbsp;<br />
As part of our commitment to an exceptional shopping experience, we are pleased to offer free shipping Orders qualify for free shipping when they meet the minimum order requirement set by the restaurant from which the food is ordered..<br />
Shipping Methods<br />
&nbsp;<br />
We offer a variety of shipping options to suit the needs of our customers:</h4>

<ul>
	<li>
	<h4>Standard</h4>
	</li>
	<li>
	<h4>Expedited</h4>
	</li>
	<li>
	<h4>Same day</h4>
	</li>
</ul>

<h4>&nbsp;<br />
Delayed Orders<br />
&nbsp;<br />
Unexpected delays can occur due to various reasons such as logistic challenges, inclement weather, high demand, or carrier issues. We are committed to handling these situations with transparency and efficiency. In the event of a delay, our priority is to keep you informed.&nbsp;</h4>

<h4>We will promptly notify you with updates on the status of your order and the expected new delivery time. Our goal is to provide clear and accurate information so you can plan accordingly.</h4>

<h4>Understanding the inconvenience caused by delays, we offer options to maintain your satisfaction. If your order is significantly delayed, you will have the choice to continue with the order, modify it, or cancel it for a full refund. Our customer service team is always available to assist with any changes to your order.<br />
&nbsp;<br />
Returns and Exchanges<br />
&nbsp;<br />
If you have any questions about refunds, returns or exchanges, please review our refund policy.<br />
&nbsp;<br />
Contact Information<br />
&nbsp;<br />
If you have any questions or concerns regarding our shipping policy, we encourage you to contact us using the details below:<br />
&nbsp; nonvegcity@gmail.com<br />
&nbsp;</h4>

""";

    final String htmlRefundContent = """
<h4>This shipping policy explains how Non Veg City (NVC) (doing business as &ldquo;NVC&rdquo;) operates its shipping procedures and how we strive to meet your expectations with every order. Whether you&rsquo;re a first-time buyer or a returning customer, we want to ensure that your experience with us is smooth and satisfactory, right from placing your order to the moment it arrives at your doorstep. This policy has been created with the help of the shipping policy generator.<br />
Please read this shipping policy together with our terms and conditions to familiarize yourself with the rest of our general guidelines.<br />
&nbsp;<br />
Table of contents</h4>

<ul>
	<li>
	<h4>&nbsp;Shipping and Delivery Options</h4>
	</li>
	<li>
	<h4>&nbsp;Delayed Orders</h4>
	</li>
	<li>
	<h4>&nbsp;Returns and Exchanges</h4>
	</li>
	<li>
	<h4>&nbsp;Contact Information</h4>
	</li>
</ul>

<h4>&nbsp;<br />
Shipping and Delivery Options</h4>

<h4>We offer a variety of shipping options to suit the needs of our customers.<br />
&nbsp;<br />
Free Shipping<br />
&nbsp;<br />
As part of our commitment to an exceptional shopping experience, we are pleased to offer free shipping Orders qualify for free shipping when they meet the minimum order requirement set by the restaurant from which the food is ordered..<br />
Shipping Methods<br />
&nbsp;<br />
We offer a variety of shipping options to suit the needs of our customers:</h4>

<ul>
	<li>
	<h4>Standard</h4>
	</li>
	<li>
	<h4>Expedited</h4>
	</li>
	<li>
	<h4>Same day</h4>
	</li>
</ul>

<h4>&nbsp;<br />
Delayed Orders<br />
&nbsp;<br />
Unexpected delays can occur due to various reasons such as logistic challenges, inclement weather, high demand, or carrier issues. We are committed to handling these situations with transparency and efficiency. In the event of a delay, our priority is to keep you informed.&nbsp;</h4>

<h4>We will promptly notify you with updates on the status of your order and the expected new delivery time. Our goal is to provide clear and accurate information so you can plan accordingly.</h4>

<h4>Understanding the inconvenience caused by delays, we offer options to maintain your satisfaction. If your order is significantly delayed, you will have the choice to continue with the order, modify it, or cancel it for a full refund. Our customer service team is always available to assist with any changes to your order.<br />
&nbsp;<br />
Returns and Exchanges<br />
&nbsp;<br />
If you have any questions about refunds, returns or exchanges, please review our refund policy.<br />
&nbsp;<br />
Contact Information<br />
&nbsp;<br />
If you have any questions or concerns regarding our shipping policy, we encourage you to contact us using the details below:<br />
&nbsp; nonvegcity@gmail.com<br />
&nbsp;</h4>
""";



    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.htmlType == HtmlType.termsAndCondition ? 'terms_conditions'.tr
          : widget.htmlType == HtmlType.aboutUs ? 'about_us'.tr : widget.htmlType == HtmlType.privacyPolicy
          ? 'privacy_policy'.tr :  widget.htmlType == HtmlType.shippingPolicy ? 'shipping_policy'.tr
          : widget.htmlType == HtmlType.refund ? 'refund_policy'.tr :  widget.htmlType == HtmlType.cancellation
          ? 'cancellation_policy'.tr  : 'no_data_found'.tr),
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<HtmlController>(builder: (htmlController) {
        return Center(
          child: /*htmlController.htmlText != null ? */Container(
            height: MediaQuery.of(context).size.height,
            color: Theme.of(context).cardColor,
            child: SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeLarge),
              child: FooterViewWidget(
                child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ?  Dimensions.paddingSizeLarge : 0),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                      const SizedBox(height: Dimensions.paddingSizeDefault,),
                      WebScreenTitleWidget(title: widget.htmlType == HtmlType.termsAndCondition ? 'terms_conditions'.tr
                          : widget.htmlType == HtmlType.aboutUs ? 'about_us'.tr : widget.htmlType == HtmlType.privacyPolicy
                      ? 'privacy_policy'.tr :  widget.htmlType == HtmlType.shippingPolicy ? 'shipping_policy'.tr
                          : widget.htmlType == HtmlType.refund ? "Refund & Cancellation Policy" :  widget.htmlType == HtmlType.cancellation
                      ? 'cancellation_policy'.tr  : 'no_data_found'.tr,tap: () {
                        Get.toNamed(RouteHelper.getMainRoute(1.toString()));
                      },),

                      // Align(alignment: Alignment.topLeft,
                      //   child: ArrowIconButtonWidget(isLeft: true,
                      //     paddingLeft: Dimensions.paddingSizeSmall,
                      //     onTap: () {
                      //     // Get.back();
                      //       Get.toNamed(RouteHelper.getMainRoute());
                      //     },
                      //   ),
                      // ),


                      // ResponsiveHelper.isDesktop(context) ? Container(
                      //   height: 50, alignment: Alignment.center, color: Theme.of(context).cardColor, width: Dimensions.webMaxWidth,
                      //   child: SelectableText(widget.htmlType == HtmlType.termsAndCondition ? 'terms_conditions'.tr
                      //       : widget.htmlType == HtmlType.aboutUs ? 'about_us'.tr : widget.htmlType == HtmlType.privacyPolicy
                      //       ? 'privacy_policy'.tr : widget.htmlType == HtmlType.shippingPolicy ? 'shipping_policy'.tr
                      //       : widget.htmlType == HtmlType.refund ? 'refund_policy'.tr :  widget.htmlType == HtmlType.cancellation
                      //       ? 'cancellation_policy'.tr : 'no_data_found'.tr,
                      //     style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor),
                      //   ),
                      // ) : const SizedBox(),
                      const SizedBox(height: Dimensions.paddingSizeDefault,),

                      HtmlWidget(widget.htmlType == HtmlType.termsAndCondition ? htmlTermsAndCondition
                                : widget.htmlType == HtmlType.aboutUs ? htmlAboutContent : widget.htmlType == HtmlType.privacyPolicy
                                ? htmlPrivacyContent : widget.htmlType == HtmlType.shippingPolicy ? htmlShippingContent
                                : widget.htmlType == HtmlType.refund ? htmlRefundContent :  widget.htmlType == HtmlType.cancellation
                                ? 'cancellation_policy'.tr : 'no_data_found'.tr,
                      textStyle: robotoBlack.copyWith(fontSize: Dimensions.fontSizeLarge,color: Colors.black.withOpacity(0.70)),)
                    /*  (htmlController.htmlText!.contains('<ol>') || htmlController.htmlText!.contains('<ul>')) ? HtmlWidget(
                        htmlController.htmlText ?? '',
                        key: Key(widget.htmlType.toString()),
                        onTapUrl: (String url) {
                          return launchUrlString(url, mode: LaunchMode.externalApplication);
                        },
                      ) : SelectableHtml(
                        data: htmlController.htmlText, shrinkWrap: true,
                        onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, element) {
                          if(url!.startsWith('www.')) {
                            url = 'https://$url';
                          }
                          if (kDebugMode) {
                            print('Redirect to url: $url');
                          }
                          html.window.open(url, "_blank");
                        },
                      ),*/
                    ]),
                  ),
                ),
              ),
            ),
          )/* : const CircularProgressIndicator()*/,
        );
      }),
    );
  }


}



