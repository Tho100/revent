import 'package:flutter/cupertino.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_header.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_option_button.dart';

class BottomsheetCommentActions with UserProfileProviderService {

  Future buildBottomsheet({
    required BuildContext context,
    required String commenter,
    required VoidCallback editOnPressed,
    required VoidCallback copyOnPressed,
    required VoidCallback reportOnPressed,
    required VoidCallback blockOnPressed,
    required VoidCallback deleteOnPressed,
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetHeader(title: 'Comment Options'),

        if(userProvider.user.username == commenter)
        BottomsheetOptionButton(
          text: 'Edit Comment',
          icon: CupertinoIcons.square_pencil,
          onPressed: editOnPressed
        ),

        BottomsheetOptionButton(
          text: 'Copy Text',
          icon: CupertinoIcons.doc_on_doc,
          onPressed: copyOnPressed
        ),

        if(userProvider.user.username != commenter)
        BottomsheetOptionButton(
          text: 'Report Comment',
          icon: CupertinoIcons.flag,
          onPressed: reportOnPressed
        ),

        if(userProvider.user.username == commenter)
        BottomsheetOptionButton(
          text: 'Delete Comment',
          icon: CupertinoIcons.trash,
          onPressed: deleteOnPressed
        ),

        if(userProvider.user.username != commenter)
        BottomsheetOptionButton(
          text: 'Block @$commenter',
          icon: CupertinoIcons.clear_circled,
          onPressed: blockOnPressed
        ),

        const SizedBox(height: 25),

      ]
    );
  }

}