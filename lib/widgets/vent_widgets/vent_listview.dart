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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VentDataProvider>(
      builder: (_, ventData, __) {
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()
          ),
          itemCount: ventData.vents.length,
          itemBuilder: (_, index) {
            final reversedVentIndex = ventData.vents.length - 1 - index;
            final vents = ventData.vents[reversedVentIndex]; 
            return _buildVentPreview(vents);
          }
        );
      },
    );
  }

}