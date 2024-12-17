import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';

class ActionsButton {

  final iconOffset = const Offset(0, -1);

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required Widget child, 
  }) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: ThemeColor.thirdWhite,
          backgroundColor: ThemeColor.black,
          shape: const StadiumBorder(
            side: BorderSide(
              color: ThemeColor.lightGrey
            )
          ),
        ),
        child: child
      )
    );
  }

  Widget buildLikeButton({
    required String text, // TODO: Convert this to int
    required bool isLiked,
    required VoidCallback onPressed,
  }) {
    return _buildActionButton(
      onPressed: onPressed, 
      child: Row(
        children: [

          Transform.translate(
            offset: iconOffset,
            child: Icon(
              isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart, 
              color: isLiked ? ThemeColor.likedColor : ThemeColor.white,
              size: 18.5, 
            ),
          ),

          const SizedBox(width: 6), 

          AnimatedFlipCounter(
            value: int.parse(text),
            textStyle: GoogleFonts.inter(
              color: ThemeColor.white,
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
            ),
          )
          
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
            offset: iconOffset,
            child: const Icon(
              CupertinoIcons.chat_bubble, 
              color: ThemeColor.white,
              size: 18, 
            ),
          ),
  
          const SizedBox(width: 6), 
  
          AnimatedFlipCounter(
            value: int.parse(text),
            textStyle: GoogleFonts.inter(
              color: ThemeColor.white,
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
            ),
          )
  
        ],
      ),
    );
  }

  Widget buildSaveButton({
    required bool isSaved,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 44,
      child: _buildActionButton(
        onPressed: onPressed, 
        child: Transform.translate(
          offset: iconOffset,
          child: Icon(
            isSaved ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark, 
            color: ThemeColor.white,
            size: 16, 
          ),
        ),          
      ),
    );
  }

}