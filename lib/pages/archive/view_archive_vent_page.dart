import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/app_bar.dart';

class ViewArchiveVentPage extends StatelessWidget {

  final String title;
  final String bodyText;
  final String lastEdit;

  const ViewArchiveVentPage({
    required this.title,
    required this.bodyText,
    required this.lastEdit,
    super.key
  });

  Widget _buildLastEdit() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
    
          const Icon(CupertinoIcons.pencil, size: 15.5, color: ThemeColor.thirdWhite),
          
          const SizedBox(width: 6),
    
          Text(
            '${lastEdit == 'Just now' ? 'Last edit just now' : 'Last edit $lastEdit ago'} ',
            style: GoogleFonts.inter(
              color: ThemeColor.thirdWhite,
              fontWeight: FontWeight.w700,
              fontSize: 12.2
            )
          ),
    
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        lastEdit == '' 
          ? const SizedBox.shrink()
          : _buildLastEdit(),

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
      padding: const EdgeInsets.only(top: 8.0, left: 18.0, right: 18.0),
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