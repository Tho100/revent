import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/pages/search_results_page.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/app_bar.dart';

class MainSearchPage extends StatefulWidget {

  const MainSearchPage({super.key});

  @override
  State<MainSearchPage> createState() => _MainSearchPageState();

}

class _MainSearchPageState extends State<MainSearchPage> {

  final searchController = TextEditingController();

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0),
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.84,
          child: TextFormField(
            autofocus: true,
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
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchResultsPage(searchText: searchText))
              );
            },
          ),
        ),
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
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        actions: [_buildSearchBar()]
      ).buildAppBar(),
    );
  }

}