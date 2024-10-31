import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/provider/profile_posts_provider.dart';
import 'package:revent/widgets/profile/profile_posts_previewer.dart';

class ProfilePostsListView extends StatelessWidget {

  final bool isMyProfile;

  const ProfilePostsListView({
    required this.isMyProfile,
    super.key
  });

  Widget _buildPreviewer(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.center,
        child: ProfilePostsPreviewer(
          title: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilePostsProvider>(
      builder: (_, postsData, __) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            childAspectRatio: 0.85, 
          ),
          itemCount: isMyProfile 
            ? postsData.myProfileTitles.length : postsData.userProfileTitles.length,
          itemBuilder: (_, index) {
            final titlesList = isMyProfile 
              ? postsData.myProfileTitles : postsData.userProfileTitles;
            return _buildPreviewer(titlesList[index]);
          }
        );
      },
    );
  }
    
}