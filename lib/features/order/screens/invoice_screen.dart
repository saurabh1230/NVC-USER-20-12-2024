import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/features/order/widgets/order_pricing_section.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';
import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';

class InvoicePdfGenerator {
  final String restaurantLogoUrl;
  final String restaurantName;
  final String restaurantAddress;
  final String restaurantPhone;
  final OrderController orderController;
  final double itemsPrice;
  final double addons;
  final double subtotal;
  final double couponDiscount;
  final double discount;
  final double tax;
  final double deliveryCharge;
  final double total;
  final int orderID;
  final OrderModel order;

  InvoicePdfGenerator({
    required this.restaurantLogoUrl,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.restaurantPhone,
    required this.orderController,
    required this.itemsPrice,
    required this.addons,
    required this.subtotal,
    required this.couponDiscount,
    required this.discount,
    required this.tax,
    required this.deliveryCharge,
    required this.total,
    required this.orderID,
    required this.order,
  });

  Future<Uint8List> _getLogoBytes() async {
    http.Response response = await http.get(Uri.parse(restaurantLogoUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load restaurant logo');
    }
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();

    // Get logo bytes
    Uint8List logoBytes = await _getLogoBytes();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Image(
                  pw.MemoryImage(logoBytes),
                  height: 50,
                  width: 50,
                ),
              ),
              pw.Divider(thickness: 1, color: PdfColors.black),
              pw.SizedBox(height: 8),
              pw.Text(restaurantName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('Address: $restaurantAddress'),
              pw.Text('Phone: $restaurantPhone'),
              pw.SizedBox(height: 16),
              pw.Divider(thickness: 1, color: PdfColors.black),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("S.No"),
                  pw.SizedBox(width: 8),
                  pw.Expanded(flex: 3, child: pw.Text("Items")),
                  pw.Expanded(child: pw.Text("Qty")),
                  pw.Expanded(child: pw.Text("Price")),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.ListView.builder(
                itemCount: orderController.orderDetails!.length,
                itemBuilder: (context, index) {
                  final item = orderController.orderDetails![index];
                  return pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("${index + 1}"),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(item.foodDetails!.name!, maxLines: 4, /*overflow: pw.TextOverflow.ellipsis*/),
                      ),
                      pw.Expanded(
                        child: pw.Text(item.quantity.toString(), maxLines: 4, /*overflow: pw.TextOverflow.ellipsis*/),
                      ),
                      pw.Expanded(
                        child: pw.Text(item.price.toString(), maxLines: 4,/* overflow: pw.TextOverflow.ellipsis*/),
                      ),
                    ],
                  );
                },
              ),
              pw.Divider(thickness: 1, color: PdfColors.black),
              pw.Text('Total Amount: \$${total.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/invoice_${orderID}.pdf");
    await file.writeAsBytes(await pdf.save());

    OpenFilex.open(file.path);
  }
}
class InvoiceDialogWidget extends StatelessWidget {
  final String restaurantLogo;
  final String restaurantName;
  final String restaurantAddress;
  final String restaurantPhone;
  final OrderController orderController;
  final double itemsPrice;
  final double addons;
  final double subtotal;
  final double couponDiscount;
  final double discount;
  final double tax;
  final double deliveryCharge;
  final double total;
  final int orderID;
  final OrderModel order;

  const InvoiceDialogWidget({
    super.key,
    required this.restaurantLogo,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.restaurantPhone,
    required this.orderController,
    required this.itemsPrice,
    required this.addons,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.deliveryCharge,
    required this.total,
    required this.orderID,
    required this.couponDiscount,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: SizedBox(
        width: Get.size.width,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: Dimensions.paddingSizeSmall),
              CustomImageWidget(image: restaurantLogo, height: 50, width: 50),
              const Divider(thickness: 1, color: Colors.black),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(restaurantName, style: robotoBold),
              Text('Address : $restaurantAddress', style: robotoRegular),
              Text('Phone : $restaurantPhone', style: robotoRegular),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              const Divider(thickness: 1, color: Colors.black),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("S.No"),
                  SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(flex: 3, child: Text("Items")),
                  Expanded(child: Text("Qty")),
                  Expanded(child: Text("Price")),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Expanded(
                child: ListView.builder(
                  itemCount: orderController.orderDetails!.length,
                  itemBuilder: (context, index) {
                    final item = orderController.orderDetails![index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${index + 1}"),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(
                          flex: 3,
                          child: Text(item.foodDetails!.name!, maxLines: 4, overflow: TextOverflow.ellipsis),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(item.quantity.toString(), maxLines: 4, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(item.price.toString(), maxLines: 4, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const Divider(thickness: 1, color: Colors.black),
              OrderPricingSection(
                itemsPrice: itemsPrice,
                addOns: 0,
                order: order,
                subTotal: subtotal,
                discount: discount,
                couponDiscount: couponDiscount,
                tax: tax,
                dmTips: 0,
                deliveryCharge: deliveryCharge,
                total: total,
                orderController: orderController,
                orderId: orderID,
                contactNumber: 'widget.contactNumber',
              ),
              SizedBox(height: Dimensions.paddingSizeDefault,),
              CustomButtonWidget(
                buttonText: 'Download Invoice',
                onPressed: () {
                  final pdfGenerator = InvoicePdfGenerator(
                    restaurantName: restaurantName,
                    restaurantAddress: restaurantAddress,
                    restaurantPhone: restaurantPhone,
                    orderController: orderController,
                    itemsPrice: itemsPrice,
                    addons: addons,
                    subtotal: subtotal,
                    couponDiscount: couponDiscount,
                    discount: discount,
                    tax: tax,
                    deliveryCharge: deliveryCharge,
                    total: total,
                    orderID: orderID,
                    order: order, restaurantLogoUrl: restaurantLogo,
                  );
                  pdfGenerator.generatePdf();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
