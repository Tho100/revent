import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';

class VentPreviewer extends StatelessWidget {

  final String title;
  final String bodyText;
  final int totalLikes;
  final int totalComments;

  VentPreviewer({
    required this.title,
    required this.bodyText,
    required this.totalLikes,
    required this.totalComments,
    super.key
  });

  final defaultActionButtonsStyle = ElevatedButton.styleFrom(
    foregroundColor: ThemeColor.thirdWhite,
    backgroundColor: ThemeColor.black,
    shape: const StadiumBorder(
      side: BorderSide(
        color: ThemeColor.thirdWhite
      )
    ),
  );

  Widget _buildCommunityAndCreatorHeader() {
    return Row(
      children: [

        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: ThemeColor.white,
            shape: BoxShape.circle
          )
        ),

        const SizedBox(width: 10),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'motivation',
              style: GoogleFonts.inter(
                color: ThemeColor.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 2.5),

            Text(
              'By dan_isgay',
              style: GoogleFonts.inter(
                color: ThemeColor.thirdWhite,
                fontWeight: FontWeight.w800,
                fontSize: 12
              ),
            ),

          ],
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width-90,
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: ThemeColor.white,
          fontWeight: FontWeight.w800,
          fontSize: 16
        ),
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
    );
  }

  Widget _buildBodyText() {
    return Text(
      bodyText,
      style: GoogleFonts.inter(
        color: ThemeColor.secondaryWhite,
        fontWeight: FontWeight.w800,
        fontSize: 12.5
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2
    );
  }

  Widget _buildLikeButton() {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        style: defaultActionButtonsStyle,
        onPressed: () => () {},
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
  
            Transform.translate(
              offset: const Offset(0, -1),
              child: const Icon(
                CupertinoIcons.heart_fill, 
                color: Color.fromARGB(255, 127, 15, 50),
                size: 18.5, 
              ),
            ),
  
            const SizedBox(width: 6), 
  
            Text(
              totalLikes.toString(),
              style: GoogleFonts.inter(
                color: ThemeColor.white,
                fontWeight: FontWeight.w800,
                fontSize: 13.5,
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsButton() {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        style: defaultActionButtonsStyle,
        onPressed: () => () {},
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              totalComments.toString(),
              style: GoogleFonts.inter(
                color: ThemeColor.white,
                fontWeight: FontWeight.w800,
                fontSize: 13.5,
              ),
            ),
    
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: ThemeColor.black,
        border: Border.all(
          color: ThemeColor.secondaryWhite,
          width: 0.8
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildCommunityAndCreatorHeader(),

            const SizedBox(height: 14),

            _buildTitle(context),

            const SizedBox(height: 12),

            _buildBodyText(),
      
            const SizedBox(height: 22),

            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Row(
                children: [
                      
                  _buildLikeButton(),
                      
                  const SizedBox(width: 8),
                      
                  _buildCommentsButton(),
                      
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

} 