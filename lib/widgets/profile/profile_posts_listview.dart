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

  bool _isPostsEmpty(ProfilePostsProvider postsData) {
    return isMyProfile ? postsData.myProfileTitles.isEmpty : postsData.userProfileTitles.isEmpty;
  }

  int _itemCount(ProfilePostsProvider postsData) {

    final isPostsEmpty = _isPostsEmpty(postsData);
    
    if(isPostsEmpty) {
      return 1;

    } else {
      return isMyProfile 
        ? postsData.myProfileTitles.length : postsData.userProfileTitles.length;
    }

  }

  Map<String, List<dynamic>> _profilePostsData(ProfilePostsProvider postsData) {

    final titlesList = isMyProfile 
      ? postsData.myProfileTitles : postsData.userProfileTitles;

    final totalLikesList = isMyProfile 
      ? postsData.myProfileTotalLikes : postsData.userProfileTotalLikes;

    return {
      'titles': titlesList,
      'total_likes': totalLikesList,
    };

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilePostsProvider>(
      builder: (_, postsData, __) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _isPostsEmpty(postsData) ? 1 : 2,
            mainAxisSpacing: _isPostsEmpty(postsData) ? 1 : 2,
            crossAxisSpacing: _isPostsEmpty(postsData) ? 1 : 2,
            childAspectRatio: 0.85, 
          ),
          itemCount: _itemCount(postsData),
          itemBuilder: (_, index) {
            final data = _profilePostsData(postsData);
            final titles = data['titles']! as List<String>;
            final totalLikes = data['total_likes']! as List<int>;
            return titles.isNotEmpty 
              ? _buildPreviewer(titles[index], totalLikes[index])
              : _buildOnEmpty();
          }
        );
      },
    );
  }
    
}