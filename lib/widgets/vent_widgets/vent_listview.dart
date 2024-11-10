import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/provider/vent_data_provider.dart';
import 'package:revent/widgets/vent_widgets/vent_previewer.dart';

class VentListView extends StatelessWidget {

  const VentListView({super.key});

  Widget _buildVentPreview(Vent ventData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.5),
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

  @override
  Widget build(BuildContext context) {
    return Consumer<VentDataProvider>(
      builder: (_, ventData, __) {
        return DynamicHeightGridView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()
          ),
          crossAxisCount: 1,
          itemCount: ventData.vents.length,
          builder: (_, index) {
            final reversedVentIndex = ventData.vents.length - 1 - index;
            final vents = ventData.vents[reversedVentIndex]; 
            return _buildVentPreview(vents);
          }
        );
      },
    );
  }

}