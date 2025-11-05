import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/shared/widgets/no_content_message.dart';
import 'package:revent/shared/provider/profile/posts_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/buttons/main_button.dart';
import 'package:revent/shared/widgets/vent_widgets/default_vent_previewer.dart';

class ProfilePostsListView extends StatefulWidget {

  final bool isMyProfile;

  final String username;
  final Uint8List pfpData;

  const ProfilePostsListView({
    required this.isMyProfile,
    required this.username,
    required this.pfpData,
    super.key
  });

  @override
  State<ProfilePostsListView> createState() => _ProfilePostsListViewState();

}

class _ProfilePostsListViewState extends State<ProfilePostsListView> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  Widget _buildPreviewer(ProfilePostsData postsData, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DefaultVentPreviewer(
        isMyProfile: widget.isMyProfile,
        postId: postsData.postIds[index],
        title: postsData.titles[index],
        bodyText: postsData.bodyText[index],
        tags: postsData.tags[index],
        postTimestamp: postsData.postTimestamp[index],
        totalLikes: postsData.totalLikes[index],
        totalComments: postsData.totalComments[index],
        isNsfw: postsData.isNsfw[index],
        isPinned: postsData.isPinned[index],
        creator: widget.username,
        pfpData: widget.pfpData,
      ),
    );
  }

  Widget _buildNoPostedVents() {
    return widget.isMyProfile 
      ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Icon(CupertinoIcons.square_pencil, color: ThemeColor.contentSecondary, size: 32),

            const SizedBox(height: 14),
      
            NoContentMessage().headerCustomMessage(
              header: 'Create Vent', 
              subheader: 'Share your thoughts, stories and more!'
            ),
              
            const SizedBox(height: 25),
      
            MainButton(
              text: 'Create',
              customWidth: 90,
              customHeight: 40, 
              onPressed: () => NavigatePage.createVentPage()
            )
          
          ],
        )
      : NoContentMessage().customMessage(message: 'No vent posted yet.');
  }

  Widget _buildListView(ProfilePostsData postsData) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 25,
      child: ListView.builder(
        itemCount: postsData.titles.length + 1,
        itemBuilder: (_, index) {
    
          if (index == 0) {
            return const SizedBox(height: 10);
          }
    
          final adjustedIndex = index - 1;
    
          if (index >= 0) {
            return KeyedSubtree(
              key: ValueKey('${postsData.titles[adjustedIndex]}/${widget.username}'),
              child: _buildPreviewer(postsData, adjustedIndex)
            );
          }
    
          return const SizedBox.shrink();
    
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProfilePostsProvider>(
      builder: (_, postsData, __) {

        final profilePostsData = widget.isMyProfile 
          ? postsData.myProfile : postsData.userProfile;
          
        return profilePostsData.titles.isEmpty 
          ? _buildNoPostedVents()
          : _buildListView(profilePostsData);

      },
    );
  }
  
}