import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_color.dart';

class PageLoading extends StatelessWidget {

  const PageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: ThemeColor.white, strokeWidth: 2)
    );
  }

}