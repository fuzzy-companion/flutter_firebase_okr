import 'package:flutter/material.dart';
import 'package:instagram_posts/core/utils/app_images.dart';

class LogoTitle extends StatelessWidget {
  final double? textSize;
  final double? logoSize;
  const LogoTitle({super.key, this.textSize, this.logoSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      spacing: 16,
      children: [
        AppImages.instagram(context).image(width: logoSize, fit: .contain),
        Text(
          'Instagramify',
          style: TextStyle(
            fontSize: textSize,
            fontWeight: .w900,
            fontFamily: 'DancingScript',
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
