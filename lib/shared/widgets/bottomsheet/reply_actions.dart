import 'package:flutter/cupertino.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_option_button.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_title.dart';

class BottomsheetReplyActions with UserProfileProviderService {

  Future buildBottomsheet({
    required BuildContext context,
    required String repliedBy,
    required VoidCallback copyOnPressed,
    required VoidCallback reportOnPressed,
    required VoidCallback blockOnPressed,
    required VoidCallback deleteOnPressed,
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const SizedBox(height: 12),

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'Reply Action'),

        BottomsheetOptionButton(
          text: 'Copy text',
          icon: CupertinoIcons.doc_on_doc,
          onPressed: copyOnPressed
        ),

        if(userProvider.user.username != repliedBy)
        BottomsheetOptionButton(
          text: 'Report reply',
          icon: CupertinoIcons.flag,
          onPressed: reportOnPressed
        ),

        if(userProvider.user.username == repliedBy)
        BottomsheetOptionButton(
          text: 'Delete reply',
          icon: CupertinoIcons.trash,
          onPressed: deleteOnPressed
        ),

        if(userProvider.user.username != repliedBy)
        BottomsheetOptionButton(
          text: 'Block @$repliedBy',
          icon: CupertinoIcons.clear_circled,
          onPressed: blockOnPressed
        ),

        const SizedBox(height: 25),

      ]
    );
  }

}