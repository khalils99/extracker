import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../assets/app_images.dart';

class ButtonBack extends StatelessWidget {
  const ButtonBack({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          context.pop();
        },
        style:
            TextButton.styleFrom(shape: CircleBorder(), minimumSize: Size.zero),
        child: SvgPicture.asset(
          AppImages.backSvg,
          color: color ?? Theme.of(context).canvasColor,
        ));
  }
}
