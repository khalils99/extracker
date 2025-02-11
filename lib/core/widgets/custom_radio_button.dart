import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton(
      {super.key, required this.value, required this.onChanged});
  final bool value;
  final Function(bool val)? onChanged;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50.sp),
      onTap: () => onChanged == null ? null : (onChanged!(!value)),
      child: Container(
        width: 2.4.h,
        height: 2.4.h,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: value
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).indicatorColor,
              width: 1.5,
            )),
        padding: EdgeInsets.all(0.9.w),
        child: value
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : null,
      ),
    );
  }
}
