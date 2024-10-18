import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';

class ActionsButton {

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required Widget child, 
  }) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: ThemeColor.thirdWhite,
          backgroundColor: ThemeColor.black,
          shape: const StadiumBorder(
            side: BorderSide(
              color: ThemeColor.thirdWhite
            )
          ),
        ),
        onPressed: onPressed,
        child: child
      )
    );
  }

  Widget buildLikeButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return _buildActionButton(
      onPressed: onPressed, 
      child: Row(
        children: [

          Transform.translate(
            offset: const Offset(0, -1),
            child: const Icon(
              CupertinoIcons.heart_fill, 
              color: Color.fromARGB(200, 255, 105, 180),
              size: 18.5, 
            ),
          ),

          const SizedBox(width: 6), 

          Text(
            text,
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
            ),
          ),
          
        ],
      ),
    );
  }

  Widget buildCommentsButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return _buildActionButton(
      onPressed: onPressed, 
      child: Row(
        children: [
  
          Transform.translate(
            offset: const Offset(0, -1),
            child: const Icon(
              CupertinoIcons.chat_bubble, 
              color: ThemeColor.white,
              size: 18, 
            ),
          ),
  
          const SizedBox(width: 6), 
  
          Text(
            text,
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
            ),
          ),
  
        ],
      ),
    );
  }

}