import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';

class MyPostsListView extends StatelessWidget {

  const MyPostsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics()
      ),
      itemCount: 3,
      itemBuilder: (_, index) {
        
      }
    );
  }
    
}