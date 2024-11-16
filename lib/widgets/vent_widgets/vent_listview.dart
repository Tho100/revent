import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/widgets/vent_widgets/vent_previewer.dart';

class VentListView extends StatelessWidget {

  final dynamic provider;

  const VentListView({
    required this.provider,
    super.key,
  });

  Widget _buildVentPreview(dynamic ventData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.5),
      child: VentPreviewer(
        title: ventData.title,
        bodyText: ventData.bodyText,
        creator: ventData.creator,
        postTimestamp: ventData.postTimestamp,
        totalLikes: ventData.totalLikes,
        totalComments: ventData.totalComments,
        pfpData: ventData.profilePic,
        isPostLiked: ventData.isPostLiked,
      ),
    );
  }

  Widget _buildVentList(BuildContext context) {

    final ventDataList = provider.vents;

    return DynamicHeightGridView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics()
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

  Widget _buildOnEmpty() {
    return EmptyPage().customMessage(message: 'Nothing to see here.');
  }

  @override
  Widget build(BuildContext context) {
    return provider.vents.isEmpty 
      ? _buildOnEmpty()
      : _buildVentList(context);
  }

}
