import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/provider/profile_posts_provider.dart';
import 'package:revent/widgets/profile/profile_posts_previewer.dart';

class ProfilePostsListView extends StatelessWidget {

  final bool isMyProfile;

  const ProfilePostsListView({
    required this.isMyProfile,
    super.key
  });

  Widget _buildPreviewer(String title, int totalLikes) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.center,
        child: ProfilePostsPreviewer(
          title: title,
          totalLikes: totalLikes
        ),
      ),
    );
  }

  Widget _buildOnEmpty() {
    return EmptyPage()
      .customMessage(message: 'No vent posted yet.');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilePostsProvider>(
      builder: (_, postsData, __) {

        final titles = isMyProfile 
          ? postsData.myProfileTitles 
          : postsData.userProfileTitles;

        final totalLikes = isMyProfile 
          ? postsData.myProfileTotalLikes 
          : postsData.userProfileTotalLikes;
        
        final isPostsEmpty = titles.isEmpty;
        final itemCount = isPostsEmpty ? 1 : titles.length;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isPostsEmpty ? 1 : 2,
            crossAxisSpacing: isPostsEmpty ? 1 : 2,
            childAspectRatio: 0.85, 
          ),
          itemCount: itemCount,
          itemBuilder: (_, index) {
            return isPostsEmpty 
              ? _buildOnEmpty() 
              : _buildPreviewer(titles[index], totalLikes[index]);
          },
        );
      },
    );
  }
    
}