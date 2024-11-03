import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/inkwell_effect.dart';

class ProfilePostsPreviewer extends StatelessWidget {

  final String title;
  final int totalLikes;

  const ProfilePostsPreviewer({
    required this.title,
    required this.totalLikes,
    super.key
  });

  Widget _buildChild() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    
          SizedBox(
            height: 155,
            child: Text(
              title,
              style: GoogleFonts.inter(
                color: ThemeColor.white,
                fontWeight: FontWeight.w800,
                fontSize: 16
              ),
              textAlign: TextAlign.start,
            ),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [

                  const Icon(CupertinoIcons.heart_fill, color: ThemeColor.likedColor, size: 16),
                  
                  Text(
                    totalLikes.toString(),
                    style: GoogleFonts.inter(
                      color: ThemeColor.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14
                    ),
                    textAlign: TextAlign.start,
                  )

                ],
              )
            ),
          )
    
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWellEffect(
      onPressed: () => print('Pressed'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: ThemeColor.thirdWhite,
            width: 0.8
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: _buildChild()
      ),
    );
  }

}