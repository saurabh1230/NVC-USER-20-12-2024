import 'package:non_veg_city/helper/responsive_helper.dart';
import 'package:non_veg_city/util/dimensions.dart';
import 'package:non_veg_city/util/styles.dart';
import 'package:flutter/material.dart';

class CustomSearchFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefix;
  final Function iconPressed;
  final Function? onSubmit;
  final Function? onChanged;
  final Function()? tap;
  const CustomSearchFieldWidget({super.key, required this.controller, required this.hint, required this.prefix, required this.iconPressed, this.onSubmit, this.onChanged, this.tap, });

  @override
  State<CustomSearchFieldWidget> createState() => _CustomSearchFieldWidgetState();
}

class _CustomSearchFieldWidgetState extends State<CustomSearchFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: widget.tap,
      controller: widget.controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : 25),
            borderSide: BorderSide(width: 1, color: Theme.of(context).primaryColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : 25),
            borderSide: BorderSide(width: 1, color: Theme.of(context).primaryColor)),
        hintText: widget.hint, hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : 25), borderSide: BorderSide.none),
        filled: true, fillColor: Theme.of(context).cardColor,
        isDense: true,
        prefixIcon: IconButton(
          onPressed: widget.iconPressed as void Function()?,
          icon: Icon(widget.prefix),
        ),
      ),
      onSubmitted: widget.onSubmit as void Function(String)?,
      onChanged: widget.onChanged as void Function(String)?,
    );
  }
}
