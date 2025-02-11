import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox(
      {super.key, required this.value, required this.onChanged, this.error});
  final bool value;
  final bool? error;
  final Function(bool val)? onChanged;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onChanged != null) onChanged!(!value);
      },
      child: AnimatedContainer(
        width: 5.5.w,
        height: 5.5.w,
        decoration: BoxDecoration(
          color: value
              ? Theme.of(context).secondaryHeaderColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.sp),
          border: Border.all(
            color: error == true
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).indicatorColor,
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        duration: Duration(milliseconds: 300),
        child: value
            ? Icon(
          Icons.check,
          color: Theme.of(context).cardColor,
          size: 3.5.w,
        )
            : null,
      ),
    );
  }
}
