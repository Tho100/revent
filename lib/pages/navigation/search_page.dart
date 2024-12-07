import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/navigation/page_navigation_bar.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/text_field/main_textfield.dart';

class SearchPage extends StatefulWidget {

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => SearchPageState();

}

class SearchPageState extends State<SearchPage> {

  final searchController = TextEditingController();

  final chipsSelectedNotifier = ValueNotifier<List<bool>>([]);

  List<String> chipsTags = [];

  void _initializeTags() {
    
    chipsTags = [
      'vent', 
      'random',
      'support',
      'life',
      'family',
      'parents',
      'lgbtq+',
      'help',
      'question',
      'religion',
    ];

    chipsSelectedNotifier.value = List<bool>.generate(chipsTags.length, (_) => false);

  }

  Widget _buildSearchBar() {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.89,
        child: MainTextField(
          controller: searchController, 
          hintText: 'Search for anything...'
        ),
      ),
    );
  }

  Widget _buildChip(String label, int index) {
    return ValueListenableBuilder(
      valueListenable: chipsSelectedNotifier,
      builder: (_, chipSelected, __) {
        return ChoiceChip(
        label: Text(
          '#$label',
            style: GoogleFonts.inter(
              color: ThemeColor.mediumBlack,
              fontWeight: FontWeight.w700,
              fontSize: 14
            )
          ),
          selected: chipSelected[index],
          onSelected: (bool selected) {
            chipsSelectedNotifier.value[index] = selected;
            chipsSelectedNotifier.value = List.from(chipSelected);
          },
          selectedColor: ThemeColor.thirdWhite,
          backgroundColor: ThemeColor.white,
        );
      },
    );
  }
  
  Widget _buildTagsChoiceChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          'Tags',
          style: GoogleFonts.inter(
            color: ThemeColor.secondaryWhite,
            fontWeight: FontWeight.w800,
            fontSize: 14
          ),
        ),

        const SizedBox(height: 8),

        SizedBox(
          width: MediaQuery.of(context).size.width * 0.86,
          child: Wrap(
            spacing: 8.0, 
            children: [
              for(int i=0; i<chipsSelectedNotifier.value.length; i++) ... [
                _buildChip(chipsTags[i], i),
              ]
            ],
          ),
        ),

      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
    
          _buildSearchBar(),

          const SizedBox(height: 32),
  
          _buildTagsChoiceChips(),

        ]
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeTags();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        NavigatePage.homePage();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Search',
          context: context,
          customLeading: const SizedBox(),
        ).buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: PageNavigationBar()
      ),
    );
  }

}