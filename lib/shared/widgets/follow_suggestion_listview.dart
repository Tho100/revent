import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/shared/provider/follow_suggestion_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/buttons/main_button.dart';
import 'package:revent/shared/widgets/profile_picture.dart';

class FollowSuggestionListView extends StatelessWidget {

  const FollowSuggestionListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FollowSuggestionProvider>(
      builder: (_, suggestionData, __) {
        return ListView.builder(
          itemCount: 5,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (_, index) {
      
            final username = suggestionData.suggestions[index].username;
            final profilePic = suggestionData.suggestions[index].profilePic;
      
            return Container(
              width: 30,
              height: 45,
              decoration: BoxDecoration(
                color: ThemeColor.black,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: ThemeColor.lightGrey
                )
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  
                    ProfilePictureWidget(
                      pfpData: profilePic,
                      customHeight: 30,
                      customWidth: 30,
                    ),
                    
                    const SizedBox(height: 4),
              
                    Text(
                      username,
                      style: GoogleFonts.inter(
                        color: ThemeColor.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15
                      ),
                    ),
          
                    const SizedBox(height: 8),
              
                    MainButton(
                      text: 'Follow',
                      customWidth: 55,
                      customHeight: 35, 
                      onPressed: () {}
                    )
                  
                  ],
                ),
              ),
            );
            
          },
        );
      },
    );
  }

}