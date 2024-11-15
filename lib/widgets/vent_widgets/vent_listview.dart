import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/provider/vent_data_provider.dart';
import 'package:revent/provider/vent_following_data_provider.dart';
import 'package:revent/widgets/vent_widgets/vent_previewer.dart';

class VentListView extends StatelessWidget {

  final bool loadForFollowingTab;

  const VentListView({
    required this.loadForFollowingTab,
    super.key
  });

  Widget _buildForYouVentPreview(Vent ventData) {
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

  Widget _buildFollowingVentPreview(VentFollowing ventData) {
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

  Widget _buildForYouVents() {
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
            return _buildForYouVentPreview(vents);
          }
        );
      },
    );
  }

  Widget _buildFollowingVents() {
    return Consumer<VentFollowingDataProvider>(
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
            return _buildFollowingVentPreview(vents);
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return loadForFollowingTab 
      ? _buildFollowingVents()
      : _buildForYouVents();
  }

}