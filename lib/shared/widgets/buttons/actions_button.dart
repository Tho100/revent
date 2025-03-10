import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';

class ActionsButton {

  final iconOffset = const Offset(0, -1);

  Widget _buildActionButton({
    bool? isLiked = false,
    bool? isSaved = false,
    required VoidCallback onPressed,
    required Widget child
  }) {

    Color? backgroundColor;
    Color? borderColor;

    if(isLiked! || isSaved!) {
      borderColor = ThemeColor.black; 
    }

    if(isLiked) {
      backgroundColor = ThemeColor.likedColor;
    } 

    if(isSaved!) {
      backgroundColor = ThemeColor.white;
    }

    if(!isSaved && !isLiked) {
      backgroundColor = ThemeColor.black;
      borderColor = ThemeColor.lightGrey;
    }

    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: ThemeColor.thirdWhite,
          backgroundColor: backgroundColor!,
          shape: StadiumBorder(
            side: BorderSide(
              color: borderColor!,
              width: isLiked || isSaved ? 0 : 1
            )
          ),
        ),
        child: child
      )
    );

  }

  Widget buildLikeButton({
    required int value,
    required bool isLiked,
    required VoidCallback onPressed,
  }) {
    return _buildActionButton(
      onPressed: onPressed, 
      isLiked: isLiked,
      child: Row(
        children: [

          Transform.translate(
            offset: iconOffset,
            child: Icon(
              isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart, 
              color: isLiked ? ThemeColor.white : ThemeColor.white,
              size: 18.5, 
            ),
          ),

          const SizedBox(width: 6), 

          AnimatedFlipCounter(
            value: value,
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
    required int value,
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
            value: value,
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
        isSaved: isSaved,
        child: Transform.translate(
          offset: iconOffset,
          child: Icon(
            isSaved ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark, 
            color: isSaved ? ThemeColor.black : ThemeColor.white,
            size: 16, 
          ),
        ),          
      ),
    );
  }

}