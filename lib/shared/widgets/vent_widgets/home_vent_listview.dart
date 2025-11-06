import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/shared/widgets/no_content_message.dart';
import 'package:revent/shared/provider/follow_suggestion_provider.dart';
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
      padding: const EdgeInsets.only(bottom: 16),
      child: DefaultVentPreviewer(
        postId: ventData.postId,
        title: ventData.title,
        bodyText: ventData.bodyText,
        tags: ventData.tags,
        postTimestamp: ventData.postTimestamp,
        totalLikes: ventData.totalLikes,
        totalComments: ventData.totalComments,
        isNsfw: ventData.isNsfw,
        creator: ventData.creator,
        pfpData: ventData.profilePic,
      ),
    );
  }
  
  Widget _buildFollowSuggestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 6.0, bottom: 4.0),
          child: Text(
            'Follow suggestion',
            style: GoogleFonts.inter(
              color: ThemeColor.contentThird,
              fontWeight: FontWeight.w800,
              fontSize: 13
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 14.0),
          child: FollowSuggestionListView()
        ),

      ],
    );
  }

  Widget _buildVentList() {
    
    final ventDataList = widget.provider.vents;
    final showSuggestion = widget.showFollowSuggestion ?? false;

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      itemCount: ventDataList.length + (showSuggestion ? 1 : 0),
      itemBuilder: (_, index) {

        if (index == 5 && showSuggestion) {
          return Consumer<FollowSuggestionProvider>(
            builder: (_, suggestionData, __) {
              if (suggestionData.suggestions.isEmpty) return const SizedBox.shrink();
              return _buildFollowSuggestion();
            },
          );
        }

        final adjustedIndex = (showSuggestion && index > 5) ? index - 1 : index;

        if (adjustedIndex < 0 || adjustedIndex >= ventDataList.length) {
          return const SizedBox.shrink();
        }

        final vents = ventDataList[adjustedIndex];

        return KeyedSubtree(
          key: ValueKey('${vents.title}/${vents.creator}'),
          child: _buildVentPreview(vents),
        );
        
      },
    );
  }

  Widget _buildEmptyState() {
    return NoContentMessage().customMessage(
      message: 'Nothing to see here.'
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.provider.vents.isEmpty 
      ? _buildEmptyState()
      : _buildVentList();
  }

}