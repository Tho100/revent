import 'package:flutter/material.dart';
import 'package:revent/widgets/vent_widgets/vent_previewer.dart';

class VentListView extends StatelessWidget {

  const VentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics()
      ),
      itemCount: 3,
      itemBuilder: (context, index) {

        final titles = ['I dont know what im doing with my life anymore fuck this shit fr bro', 'hey guys', 'test title'];
        final bodyText = ['helll yeah man whats going on', 'aaaaaaaaaaaaaaaaaaa', 'iim testing 123123_3'];

        final totalLikes = [110, 40, 2];
        final totalComments = [444, 2, 11];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.5),
          child: VentPreviewer(
            title: titles[index],
            bodyText: bodyText[index],
            totalLikes: totalLikes[index],
            totalComments: totalComments[index],
          ),
        );

      }
    );
  }

}