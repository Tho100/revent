import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/widgets/app_bar.dart';

class ViewArchiveVentPage extends StatelessWidget {

  final String title;
  final String bodyText;

  const ViewArchiveVentPage({
    required this.title,
    required this.bodyText,
    super.key
  });

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SelectableText(
          title,
          style: GoogleFonts.inter(
            color: ThemeColor.white,
            fontWeight: FontWeight.w800,
            fontSize: 21
          ),
        ),
        
        const SizedBox(height: 14),

        SelectableText(
          bodyText,
          style: GoogleFonts.inter(
            color: ThemeColor.secondaryWhite,
            fontWeight: FontWeight.w700,
            fontSize: 14
          ),
        ),

      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 18.0, right: 18.0),
      child: SingleChildScrollView(
        child: _buildHeader()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
      ).buildAppBar(),
      body: _buildBody(),
    );
  }

}