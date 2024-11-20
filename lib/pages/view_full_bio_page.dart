import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/app_bar.dart';

class ViewFullBioPage extends StatelessWidget {

  final String bio;

  const ViewFullBioPage({
    required this.bio, 
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: 'Bio'
      ).buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 20.0, top: 20.0),
        child: SelectableText(
          bio,
          style: GoogleFonts.inter(
            color: ThemeColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 16
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

}