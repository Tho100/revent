import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_title.dart';

class BottomsheetTagsSelection {
 
  final ValueNotifier<List<bool>> chipsSelectedNotifier;
  final List<String> chipsTags;

  BottomsheetTagsSelection({
    required this.chipsSelectedNotifier,
    required this.chipsTags
  });

  Widget _buildChip(String label, int index) {
    return ValueListenableBuilder(
      valueListenable: chipsSelectedNotifier,
      builder: (_, chipSelected, __) {
        return ChoiceChip(
        label: Text(
          '#$label',
            style: GoogleFonts.inter(
              color: chipSelected[index] ?ThemeColor.mediumBlack : ThemeColor.secondaryWhite,
              fontWeight: FontWeight.w700,
              fontSize: 14
            )
          ),
          selected: chipSelected[index],
          onSelected: (bool selected) {
            chipsSelectedNotifier.value[index] = selected;
            chipsSelectedNotifier.value = List.from(chipSelected);
          },
          selectedColor: ThemeColor.white,
          backgroundColor: ThemeColor.mediumBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: chipSelected[index] ? ThemeColor.mediumBlack : ThemeColor.thirdWhite, 
              width: 1,
            ),
          ),
        );
      },
    );
  }

  Future buildBottomsheet({required BuildContext context}) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const SizedBox(height: 12),

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'Tags'),

        Transform.translate(
          offset: const Offset(0, -10),
          child: Align(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Add up to 3 tags',
                style: GoogleFonts.inter(
                  color: ThemeColor.thirdWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w800
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.88,
            child: Wrap(
              spacing: 8.0, 
              children: [
                for(int i=0; i<chipsTags.length; i++) ... [
                  _buildChip(chipsTags[i], i),
                ]
              ],
            ),
          ),
        ),        

        const SizedBox(height: 35),

      ]
    );
  }

}