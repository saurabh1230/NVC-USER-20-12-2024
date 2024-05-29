import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class CustomCheckBoxWidget extends StatefulWidget {
  final String title;
  final bool value;
  final Function onClick;
  const CustomCheckBoxWidget({super.key, required this.title, required this.value, required this.onClick});

  @override
  State<CustomCheckBoxWidget> createState() => _CustomCheckBoxWidgetState();
}

class _CustomCheckBoxWidgetState extends State<CustomCheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onClick as void Function()?,
      child: Row(children: [
        Checkbox(
          value: widget.value,
          onChanged: (bool? isActive) => widget.onClick(),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), side: BorderSide.none),
        ),
        Text(widget.title, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
      ]),
    );
  }
}
