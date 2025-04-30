import 'package:flutter/cupertino.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_option_button.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_title.dart';

class BottomsheetVentPostActions with UserProfileProviderService {

  Future buildBottomsheet({
    required BuildContext context,
    required String title,
    required String creator,
    VoidCallback? editOnPressed,
    VoidCallback? reportOnPressed,
    VoidCallback? removeSavedPostOnPressed,
    VoidCallback? blockOnPressed,
    VoidCallback? copyOnPressed,
    VoidCallback? pinOnPressed,
    VoidCallback? deleteOnPressed,
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetBar(), // TODO: Merge these two into one class "BottomsheetHeader"

        const BottomsheetTitle(title: 'Post Options'),

        if(removeSavedPostOnPressed != null)
        BottomsheetOptionButton(
          text: 'Unsave',
          icon: CupertinoIcons.bookmark_fill,
          onPressed: removeSavedPostOnPressed
        ),

        if(userProvider.user.username == creator && editOnPressed != null)
        BottomsheetOptionButton(
          text: 'Edit Post',
          icon: CupertinoIcons.square_pencil,
          onPressed: editOnPressed
        ),

        if(copyOnPressed != null)
        BottomsheetOptionButton(
          text: 'Copy Body',
          icon: CupertinoIcons.doc_on_doc,
          onPressed: copyOnPressed
        ),

        if(userProvider.user.username == creator && pinOnPressed != null)
        BottomsheetOptionButton(
          text: 'Pin Post', 
          icon: CupertinoIcons.pin, 
          onPressed: pinOnPressed
        ),

        if(userProvider.user.username != creator && reportOnPressed != null)
        BottomsheetOptionButton(
          text: 'Report Post',
          icon: CupertinoIcons.flag,
          onPressed: reportOnPressed
        ),

        if(userProvider.user.username != creator && blockOnPressed != null)
        BottomsheetOptionButton(
          text: 'Block @$creator',
          icon: CupertinoIcons.clear_circled,
          onPressed: blockOnPressed
        ),

        if(userProvider.user.username == creator && deleteOnPressed != null)
        BottomsheetOptionButton(
          text: 'Delete Post',
          icon: CupertinoIcons.trash,
          onPressed: deleteOnPressed
        ),

        const SizedBox(height: 25),

      ]
    );
  }

}