import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:intl/intl.dart';
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

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


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
    final response = await http.get(Uri.parse(restaurantLogoUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load restaurant logo');
    }
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    final logoBytes = await _getLogoBytes();

    final fontData = await rootBundle.load('assets/font/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Image(pw.MemoryImage(logoBytes), height: 50, width: 50),
              pw.Divider(),
              pw.Text(restaurantName,
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Text('Address: $restaurantAddress'),
              pw.Text('Phone: $restaurantPhone'),
              pw.Text('Phone: $restaurantPhone'),
              pw.SizedBox(height: 16),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("S.No",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("Items",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("Qty",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("Price",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Divider(),
              ...orderController.orderDetails!.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final item = entry.value;
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("$index"),
                    pw.Text(item.foodDetails!.name!),
                    pw.Text(item.quantity.toString()),
                    pw.Text(item.price.toString()),
                    pw.Text(
                      '₹ ${item.price.toString()}',
                      style: pw.TextStyle(
                        font: ttf,

                      ),
                    ),
                  ],
                );
              }),
              pw.Divider(),
              pw.Text(
                'Total Amount: ₹ ${total.toStringAsFixed(2)}',
                style: pw.TextStyle(
                  font: ttf,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Divider(),
              pw.Text(
                'We are happy to serve you',
                style: pw.TextStyle(
                  font: ttf,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Non Veg City',
                style: pw.TextStyle(
                  font: ttf,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              // pw.Text('Total Amount: ₹ ${total.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/invoice_$orderID.pdf");
    await file.writeAsBytes(await pdf.save());
    OpenFilex.open(file.path);
  }
}

class InvoiceDialogWidget extends StatelessWidget {
  final String restaurantLogo;
  final String restaurantName;
  final String restaurantAddress;
  final String restaurantPhone;
  final String restaurantGst;
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
    required this.order, required this.restaurantGst,
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
              Text('Address : $restaurantAddress', style: robotoRegular,textAlign: TextAlign.center,),
              Text('Phone : $restaurantPhone', style: robotoRegular),
              restaurantGst.isEmpty ? const SizedBox() :
              Text('Gst : $restaurantGst', style: robotoRegular),
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
                          child: Text(item.foodDetails!.name!,
                              maxLines: 4, overflow: TextOverflow.ellipsis),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(item.quantity.toString(),
                                  maxLines: 4, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(item.price.toString(),
                              maxLines: 4, overflow: TextOverflow.ellipsis),
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
              SizedBox(
                height: Dimensions.paddingSizeDefault,
              ),
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
                    order: order,
                    restaurantLogoUrl: restaurantLogo,
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
