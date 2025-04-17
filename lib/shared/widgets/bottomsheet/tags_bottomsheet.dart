import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/post_tags.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_title.dart';

class BottomsheetTagsSelection with TagsProviderService {
 
  final ValueNotifier<List<bool>> chipsSelectedNotifier;

  BottomsheetTagsSelection({required this.chipsSelectedNotifier});

  final customTagsController = TextEditingController();

  final chipsTags = PostTags.tags;

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

            final tags = customTagsController.text.split(' ').where((tag) => tag.isNotEmpty).toList();

            if (selected) {

              if (tags.length >= 3) {
                chipsSelectedNotifier.value[2] = false;
                tags.removeAt(2);
              }
              
              tags.add(label);

            } else {
              tags.remove(label);

            }

            customTagsController.text = tags.join(' ');

            tagsProvider.addTags(tags);

          },
          selectedColor: ThemeColor.white,
          backgroundColor: ThemeColor.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: chipSelected[index] ? ThemeColor.black : ThemeColor.thirdWhite, 
              width: 1,
            ),
          ),
        );
      },
    );
  }

  Future buildBottomsheet({required BuildContext context}) {

    customTagsController.text = tagsProvider.selectedTags.join(' ');

    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'Tags'),

        Align(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
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

                ValueListenableBuilder(
                  valueListenable: chipsSelectedNotifier,
                  builder: (_, chipsSelected, __) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.86,
                      child: TextFormField(
                        autofocus: true,
                        maxLines: 1,
                        maxLength: 45,
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
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        },
                        onChanged: (tagText) {

                          final spacesCount = tagText.split(' ').length - 1;

                          if (spacesCount > 2) {

                            final validText = tagText.split(' ').take(3).join(' ');

                            customTagsController.value = TextEditingValue(
                              text: validText,
                              selection: TextSelection.collapsed(offset: validText.length),
                            );

                          } else {

                            final currentTags = tagText.trim().split(' ').where(
                              (tag) => tag.isNotEmpty
                            ).toList();

                            tagsProvider.addTags(currentTags);

                            chipsSelectedNotifier.value = List.generate(chipsTags.length, (index) {
                              return currentTags.contains(chipsTags[index]);
                            });
                          }

                        },

                      ),
                    );
                  },
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