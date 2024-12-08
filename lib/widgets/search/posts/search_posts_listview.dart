import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/provider/search/search_posts_provider.dart';
import 'package:revent/widgets/vent_widgets/home_vent_previewer.dart';

class SearchPostsListView extends StatelessWidget {

  const SearchPostsListView({super.key});

  Widget _buildVentPreview(dynamic ventData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.5),
      child: HomeVentPreviewer(
        title: ventData.title,
        bodyText: ventData.bodyText,
        creator: ventData.creator,
        postTimestamp: ventData.postTimestamp,
        totalLikes: ventData.totalLikes,
        totalComments: ventData.totalComments,
        pfpData: ventData.profilePic,
      ),
    );
  }

  Widget _buildVentList() {
    return Consumer<SearchPostsProvider>(
      builder: (_, ventData, __) {

        final ventDataList = ventData.vents;

        return DynamicHeightGridView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          crossAxisCount: 1,
          itemCount: ventDataList.length,
          builder: (_, index) {
            final reversedVentIndex = ventDataList.length - 1 - index;
            final vents = ventDataList[reversedVentIndex];
            return _buildVentPreview(vents);
          },
        );

      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildVentList();
  }

}
