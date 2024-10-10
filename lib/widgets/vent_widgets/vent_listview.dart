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
            final reversedIndex = ventData.ventTitles.length - 1 - index;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.5),
              child: VentPreviewer(
                title: ventData.ventTitles[reversedIndex],
                bodyText: ventData.ventBodyText[reversedIndex],
                creator: ventData.ventCreator[reversedIndex],
                postTimestamp: ventData.ventPostTimestamp[reversedIndex],
                totalLikes: ventData.ventTotalLikes[reversedIndex],
                totalComments: ventData.ventTotalComments[reversedIndex],
              ),
            );
      
          }
        );
      },
    );
  }

}