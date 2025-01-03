import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/user/user_actions.dart';
import 'package:revent/shared/provider/follow_suggestion_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/buttons/main_button.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
import 'package:revent/shared/widgets/profile_picture.dart';

class FollowSuggestionListView extends StatelessWidget {

  const FollowSuggestionListView({super.key});

  void _followOnPressed(String username, Uint8List pfpData, int index) async {

    await UserActions(username: username).userFollowAction(follow: true).then(
      (_) => getIt.followSuggestionProvider.removeSuggestion(index)
    ); 

    NavigatePage.userProfilePage(username: username, pfpData: pfpData);

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FollowSuggestionProvider>(
      builder: (_, suggestionData, __) {
        return SizedBox(
          height: 180,
          child: ListView.builder(
            itemCount: suggestionData.suggestions.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              
              final username = suggestionData.suggestions[index].username;
              final profilePic = suggestionData.suggestions[index].profilePic;
              
              return Padding(
                padding: const EdgeInsets.only(right: 14.0, left: 2.0),
                child: Container(
                  width: 140,
                  height: 155,
                  decoration: BoxDecoration(
                    color: ThemeColor.black,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: ThemeColor.lightGrey
                    )
                  ),
                  child: InkWellEffect(
                    onPressed: () => NavigatePage.userProfilePage(username: username, pfpData: profilePic),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        
                          ProfilePictureWidget(
                            pfpData: profilePic,
                            customHeight: 65,
                            customWidth: 65,
                          ),
                          
                          const SizedBox(height: 14),
                    
                          Text(
                            username,
                            style: GoogleFonts.inter(
                              color: ThemeColor.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                            
                          const SizedBox(height: 16),
                    
                          MainButton(
                            text: 'Follow',
                            customWidth: 85,
                            customHeight: 35, 
                            onPressed: () => _followOnPressed(username, profilePic, index)
                          )
                        
                        ],
                      ),
                    ),
                  ),
                ),
              );
              
            },
          ),
        );
      },
    );
  }
}