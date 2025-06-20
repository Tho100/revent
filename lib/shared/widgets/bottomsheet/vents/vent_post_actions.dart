import 'package:flutter/cupertino.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_header.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_option_button.dart';

class BottomsheetVentPostActions with UserProfileProviderService {

  Future buildBottomsheet({
    required BuildContext context,
    required String title,
    required String creator,
    VoidCallback? editOnPressed,
    VoidCallback? reportOnPressed,
    VoidCallback? unSaveOnPressed,
    VoidCallback? unPinOnPressed,
    VoidCallback? blockOnPressed,
    VoidCallback? copyOnPressed,
    VoidCallback? pinOnPressed,
    VoidCallback? deleteOnPressed,
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetHeader(title: 'Post Options'),

        if (unSaveOnPressed != null)
        BottomsheetOptionButton(
          text: 'Unsave Post',
          icon: CupertinoIcons.bookmark_fill,
          onPressed: unSaveOnPressed
        ),

        if (userProvider.user.username == creator && editOnPressed != null)
        BottomsheetOptionButton(
          text: 'Edit Post',
          icon: CupertinoIcons.square_pencil,
          onPressed: editOnPressed
        ),

        if (copyOnPressed != null)
        BottomsheetOptionButton(
          text: 'Copy Body',
          icon: CupertinoIcons.doc_on_doc,
          onPressed: copyOnPressed
        ),

        if (userProvider.user.username == creator && unPinOnPressed != null)
        BottomsheetOptionButton(
          text: 'Unpin Post',
          icon: CupertinoIcons.pin_slash, 
          onPressed: unPinOnPressed
        ),

        if (userProvider.user.username == creator && pinOnPressed != null)
        BottomsheetOptionButton(
          text: 'Pin Post', 
          icon: CupertinoIcons.pin, 
          onPressed: pinOnPressed
        ),

        if (userProvider.user.username != creator && reportOnPressed != null)
        BottomsheetOptionButton(
          text: 'Report Post',
          icon: CupertinoIcons.flag,
          onPressed: reportOnPressed
        ),

        if (userProvider.user.username != creator && blockOnPressed != null)
        BottomsheetOptionButton(
          text: 'Block @$creator',
          icon: CupertinoIcons.clear_circled,
          onPressed: blockOnPressed
        ),

        if (userProvider.user.username == creator && deleteOnPressed != null)
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