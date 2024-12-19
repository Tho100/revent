import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/search_results_page.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/navigation/page_navigation_bar.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/navigation_pages_widgets.dart';

class SearchPage extends StatefulWidget {

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();

}

class _SearchPageState extends State<SearchPage> {

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
        width: MediaQuery.of(context).size.width * 0.91,
        child: TextFormField(
          maxLines: 1,
          controller: searchController,
          style: GoogleFonts.inter(
            color: ThemeColor.secondaryWhite,
            fontWeight: FontWeight.w700,
          ),
          decoration: ThemeStyle.txtFieldStye(
            customBottomPadding: 18,
            customTopPadding: 18,
            hintText: 'Search for anything...',
            customPrefix: const Padding(
              padding: EdgeInsets.only(left: 8.0), 
              child: Icon(CupertinoIcons.search, color: ThemeColor.thirdWhite, size: 20),
            ),
          ),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (searchText) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SearchResultsPage(searchText: searchText))
            );
          },
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
          width: MediaQuery.of(context).size.width * 0.88,
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
          customLeading: NavigationPagesWidgets.profilePictureLeading(),
          actions: [NavigationPagesWidgets.settingsActionButton()]
        ).buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: PageNavigationBar()
      ),
    );
  }

}