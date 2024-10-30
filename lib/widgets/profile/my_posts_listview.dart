import 'package:flutter/material.dart';
import 'package:revent/widgets/profile/my_posts_previewer.dart';

class MyPostsListView extends StatelessWidget {

  const MyPostsListView({super.key});

  Widget _buildPreviewer() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.center,
        child: MyPostsPreviewer(
          title: 'Whats your guys thoughts on Mr Robot?',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 0.85, 
      ),
      itemCount: 5,
      itemBuilder: (_, index) {
        return _buildPreviewer();
      }
    );
  }
    
}