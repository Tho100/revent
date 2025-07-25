import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/post_tags.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_header.dart';

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
              color: chipSelected[index] ? ThemeColor.foregroundPrimary : ThemeColor.contentSecondary,
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
          selectedColor: ThemeColor.contentPrimary,
          backgroundColor: ThemeColor.backgroundPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: chipSelected[index] ? ThemeColor.backgroundPrimary : ThemeColor.contentThird, 
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

        const BottomsheetHeader(title: 'Tags'),

        Align(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Add up to 3 tags',
              style: GoogleFonts.inter(
                color: ThemeColor.contentThird,
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
                    color: ThemeColor.contentPrimary,
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
                        maxLength: 48,
                        controller: customTagsController,
                        style: GoogleFonts.inter(
                          color: ThemeColor.contentSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add tags...',
                          counterText: '',
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.inter(
                            color: ThemeColor.contentThird, 
                            fontWeight: FontWeight.w700
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        },
                        onChanged: (tagText) {

                          final rawTags = tagText.split(' ');

                          List<String> processedTags = [];

                          for (final tag in rawTags) {

                            if (processedTags.length >= 3) break;

                            if (tag.length > 15) {

                              final chunks = RegExp('.{1,15}').allMatches(tag).map((m) => m.group(0)!);

                              for (final chunk in chunks) {

                                if (processedTags.length >= 3) break;
                                processedTags.add(chunk);

                              }

                            } else {
                              processedTags.add(tag);
                            }

                          }

                          final validText = processedTags.join(' ');

                          customTagsController.value = TextEditingValue(
                            text: validText,
                            selection: TextSelection.collapsed(offset: validText.length),
                          );

                          final cleanTags = processedTags.where((tag) => tag.isNotEmpty).toList();

                          tagsProvider.addTags(cleanTags);

                          chipsSelectedNotifier.value = List.generate(chipsTags.length, (index) {
                            return cleanTags.contains(chipsTags[index]);
                          });
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
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
          child: SizedBox(
            height: 40,
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

        const SizedBox(height: 25),

      ]
    );

  }

}