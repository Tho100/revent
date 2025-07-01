import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';

class TextFormattingToolbar extends StatelessWidget {

  final TextEditingController controller;

  final double customBottomPadding;

  const TextFormattingToolbar({
    required this.controller, 
    this.customBottomPadding = 8.0,
    super.key
  });

  void _wrapTextSelection({required String symbol}) {

    final selection = controller.selection;

    if (!selection.isValid || selection.start == selection.end) {
      SnackBarDialog.temporarySnack(message: 'No text selected.');
      return;
    }

    final text = controller.text;

    final selectedText = text.substring(selection.start, selection.end);

    final newText = text.replaceRange(
      selection.start, selection.end, '$symbol$selectedText$symbol'
    );

    controller.value = controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + symbol.length + selectedText.length + symbol.length - symbol.length - symbol.length
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, bottom: customBottomPadding),
      child: Row(
        children: [
    
          SizedBox(
            height: 50,
            width: 35,
            child: IconButton(
              icon: Icon(CupertinoIcons.bold, color: ThemeColor.contentPrimary, size: 24),
              onPressed: () => _wrapTextSelection(symbol: '**')
            ),
          ),
      
          SizedBox(
            height: 50,
            width: 35,
            child: IconButton(
              icon: Icon(CupertinoIcons.italic, color: ThemeColor.contentPrimary, size: 24),
              onPressed: () => _wrapTextSelection(symbol: '*')
            ),
          ),
      
          SizedBox(
            height: 50,
            width: 35,
            child: IconButton(
              icon: Icon(CupertinoIcons.strikethrough, color: ThemeColor.contentPrimary, size: 24),
              onPressed: () => _wrapTextSelection(symbol: '~~')
            ),
          ),

        ],
      ),
    );
  }

}