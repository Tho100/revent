import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/shared/provider/search/search_posts_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/vent_widgets/default_vent_previewer.dart';

class SearchPostsListView extends StatelessWidget {

  const SearchPostsListView({super.key});

  Widget _buildVentPreview(SearchVents ventData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.5),
      child: DefaultVentPreviewer(
        title: ventData.title,
        bodyText: '',
        creator: ventData.creator,
        postTimestamp: ventData.postTimestamp,
        totalLikes: ventData.totalLikes,
        totalComments: ventData.totalComments,
        pfpData: ventData.profilePic,
        useV2ActionButtons: true,
      ),
    );
  }

  Widget _buildOnEmpty() {
    return EmptyPage().customMessage(
      message: 'No results.'
    );
  }

  Widget _buildListView(List<SearchVents> ventDataList) {
    return DynamicHeightGridView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      crossAxisCount: 1,
      itemCount: ventDataList.length+1,
      builder: (_, index) {

        if(index < ventDataList.length) {
          
          final reversedVentIndex = ventDataList.length - 1 - index;
          final vents = ventDataList[reversedVentIndex];

          return _buildVentPreview(vents);

        } else if (ventDataList.length > 9) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14.0, top: 8.0),
            child: Center(
              child: Text(
                "You've reached the end.", 
                style: GoogleFonts.inter(
                  color: ThemeColor.thirdWhite,
                  fontWeight: FontWeight.w800,
                )
              ),
            ),
          );

        }
          
        return const SizedBox.shrink();

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchPostsProvider>(
      builder: (_, ventData, __) {

        final ventDataList = ventData.vents;

        return ventDataList.isEmpty 
          ? _buildOnEmpty() 
          : _buildListView(ventDataList);

      }
    );
  }

}
