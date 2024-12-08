import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/provider/search/search_posts_provider.dart';
import 'package:revent/widgets/vent_widgets/default_vent_previewer.dart';

class SearchPostsListView extends StatelessWidget {

  const SearchPostsListView({super.key});

  Widget _buildVentPreview(dynamic ventData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.5),
      child: DefaultVentPreviewer(
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

  Widget _buildOnEmpty() {
    return EmptyPage().customMessage(message: 'No results.');
  }

  Widget _buildVentList(List<SearchVents> ventDataList) {
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

  Widget _buildResults() {
    return Consumer<SearchPostsProvider>(
      builder: (_, ventData, __) {

        final ventDataList = ventData.vents;

        return ventDataList.isEmpty 
          ? _buildOnEmpty() 
          : _buildVentList(ventDataList);

      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildResults();
  }

}
