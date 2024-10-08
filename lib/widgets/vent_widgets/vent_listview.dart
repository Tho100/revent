import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/provider/vent_data_provider.dart';
import 'package:revent/widgets/vent_widgets/vent_previewer.dart';

class VentListView extends StatelessWidget {

  const VentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VentDataProvider>(
      builder: (context, ventData, child) {
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()
          ),
          itemCount: ventData.ventTitles.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.5),
              child: VentPreviewer(
                title: ventData.ventTitles[index],
                bodyText: ventData.ventBodyText[index],
                creator: ventData.ventCreator[index],
                postTimestamp: ventData.ventPostTimestamp[index],
                totalLikes: ventData.ventTotalLikes[index],
                totalComments: ventData.ventTotalComments[index],
              ),
            );
      
          }
        );
      },
    );
  }

}