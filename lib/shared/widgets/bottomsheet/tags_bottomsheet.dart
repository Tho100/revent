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

  final customTagsController = TextEditingController();

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

        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.92,
            child: Row(
              children: [

                Text(
                  '#',
                  style: GoogleFonts.inter(
                    color: ThemeColor.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 21
                  )
                ),

                const SizedBox(width: 6),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.86,
                  child: TextFormField(
                    autofocus: true,
                    maxLines: 1,
                    controller: customTagsController,
                    style: GoogleFonts.inter(
                      color: ThemeColor.secondaryWhite,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Add tags...',
                      counterText: '',
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.inter(
                        color: ThemeColor.thirdWhite, 
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (tag) {}
                  ),
                ),

              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
          child: SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: chipsTags.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _buildChip(chipsTags[index], index),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 35),

      ]
    );
  }

}