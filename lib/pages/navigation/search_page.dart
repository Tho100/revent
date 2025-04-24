import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/post_tags.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/pages/main_search_page.dart';
import 'package:revent/pages/search_results_page.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
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

  final chipsTags = PostTags.tags;

  Widget _buildSearchBar() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.91,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ThemeColor.thirdWhite)
        ),
        child: InkWellEffect(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MainSearchPage())
            );
          },
          child: Row(
            children: [

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Icon(CupertinoIcons.search, color: ThemeColor.thirdWhite, size: 20),
                ),
              ),

              const SizedBox(width: 10),
      
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Search for anything...',
                  style: GoogleFonts.inter(
                    color: ThemeColor.thirdWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagsChips(String label) {
    return GestureDetector(
      onTap: () async {
        await LocalStorageModel().addSearchHistory(text: '#$label').then((_) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SearchResultsPage(searchText: "#$label"))
          );
        });
      },
      child: Chip(
        label: Text(
          '#$label',
          style: GoogleFonts.inter(
            color: ThemeColor.secondaryWhite,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        backgroundColor: ThemeColor.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(
            color: ThemeColor.thirdWhite,
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildPopularTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          'Popular Tags',
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
              for(final tags in chipsTags) ... [
                _buildTagsChips(tags)
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
  
          _buildPopularTags(),

        ]
      ),
    );
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
          actions: [NavigationPagesWidgets.profilePictureLeading()]
        ).buildNavigationAppBar(),
        body: _buildBody(),
        bottomNavigationBar: PageNavigationBar()
      ),
    );
  }

}