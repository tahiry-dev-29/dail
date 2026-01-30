import 'package:flutter/material.dart';

class AppGap extends StatelessWidget {
  final double? width;
  final double? height;

  const AppGap({super.key, this.width, this.height});

  const AppGap.h(double value, {super.key}) : height = value, width = null;
  const AppGap.w(double value, {super.key}) : width = value, height = null;

  @override
  Widget build(BuildContext context) => SizedBox(width: width, height: height);
}
