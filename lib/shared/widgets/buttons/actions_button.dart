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
      borderColor = ThemeColor.backgroundPrimary; 
    }

    if(isLiked) {
      backgroundColor = ThemeColor.likedColor;
    } 

    if(isSaved!) {
      backgroundColor = ThemeColor.contentPrimary;
    }

    if(!isSaved && !isLiked) {
      backgroundColor = ThemeColor.backgroundPrimary;
      borderColor = ThemeColor.divider;
    }

    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: ThemeColor.contentThird,
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
    required VoidCallback onPressed
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
              color: isLiked ? ThemeColor.contentPrimary : ThemeColor.contentPrimary,
              size: 18.5, 
            ),
          ),

          const SizedBox(width: 6), 

          AnimatedFlipCounter(
            value: value,
            textStyle: GoogleFonts.inter(
              color: ThemeColor.contentPrimary,
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
    VoidCallback? onPressed
  }) {
    return _buildActionButton(
      onPressed: onPressed ?? () {}, 
      child: Row(
        children: [
  
          Transform.translate(
            offset: iconOffset,
            child: Icon(
              CupertinoIcons.chat_bubble, 
              color: ThemeColor.contentPrimary,
              size: 18, 
            ),
          ),
  
          const SizedBox(width: 6), 
  
          AnimatedFlipCounter(
            value: value,
            textStyle: GoogleFonts.inter(
              color: ThemeColor.contentPrimary,
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
    required VoidCallback onPressed
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
            color: isSaved ? ThemeColor.backgroundPrimary : ThemeColor.contentPrimary,
            size: 16, 
          ),
        ),          
      ),
    );
  }

}