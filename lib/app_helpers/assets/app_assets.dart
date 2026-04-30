import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppAssets {
  AppAssets._();

  static const _images = 'assets/images';
  static const _icons = 'assets/icons';
  static final Image bgImage = Image.asset(
    '$_images/bg.png',
    height: double.infinity,
    width: double.infinity,
    filterQuality: .high,
    fit: .fill,
  );
  static final SvgPicture appIcon = SvgPicture.asset('$_icons/hms_icon.svg');
  static final SvgPicture loginIcon = SvgPicture.asset(
    '$_icons/login_icon.svg',
  );
}
