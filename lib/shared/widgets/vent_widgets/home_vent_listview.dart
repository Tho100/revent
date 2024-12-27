import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/follow_suggestion_listview.dart';
import 'package:revent/shared/widgets/vent_widgets/default_vent_previewer.dart';

class HomeVentListView extends StatefulWidget {

  final dynamic provider;
  final bool? showFollowSuggestion;

  const HomeVentListView({
    required this.provider,
    this.showFollowSuggestion = false,
    super.key
  });

  @override
  State<HomeVentListView> createState() => _HomeVentListViewState();

}

class _HomeVentListViewState extends State<HomeVentListView> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

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
  
  Widget _buildFollowSuggestion() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [

          const Divider(height: 1, color: ThemeColor.lightGrey),

          Text(
            'Follow suggestion',
            style: GoogleFonts.inter(
              color: ThemeColor.thirdWhite,
              fontWeight: FontWeight.w800,
              fontSize: 12
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Expanded(
              child: FollowSuggestionListView()
            ),
          ),

          const Divider(height: 1, color: ThemeColor.lightGrey),

        ],
      ),
    );
  }

  Widget _buildVentList() {
    
    final ventDataList = widget.provider.vents;

    return DynamicHeightGridView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      crossAxisCount: 1,
      itemCount: ventDataList.length+1,
      builder: (_, index) {

        final reversedVentIndex = ventDataList.length - 1 - index;
        final vents = ventDataList[reversedVentIndex];

        if(reversedVentIndex < ventDataList.length) {
          return KeyedSubtree(
            key: ValueKey('${vents.title}/${vents.creator}'),
            child: _buildVentPreview(vents),
          );
        } else if (reversedVentIndex == 5 && widget.showFollowSuggestion!) {
          return _buildFollowSuggestion();

        } else {
          return const SizedBox.shrink();

        }

      },
    );

  }

  Widget _buildOnEmpty() {
    return EmptyPage().customMessage(
      message: 'Nothing to see here.'
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.provider.vents.isEmpty 
      ? _buildOnEmpty()
      : _buildVentList();
  }

}