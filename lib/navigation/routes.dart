import 'package:facefinder/home/ui/home_page.dart';
import 'package:flutter/material.dart';

import '../blur_image/ui/blur_image.dart';
import '../text_test/ui/text_test.dart';

Map<String, WidgetBuilder> routes = {
  '/': (context) => HomePage(),
  '/text_test': (context) => const TextTest(),
  '/blur_image': (context) => const BlurImage(),
};
