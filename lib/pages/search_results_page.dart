import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/model/setup/search_setup.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
import 'package:revent/shared/widgets/navigation/page_navigation_bar.dart';
import 'package:revent/shared/widgets/search/results_tabbar_widgets.dart';

class SearchResultsPage extends StatefulWidget {

  final String searchText;

  const SearchResultsPage({
    required this.searchText, 
    super.key
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();

}

class _SearchResultsPageState extends State<SearchResultsPage> with SingleTickerProviderStateMixin {

  late TabController tabController;
  late SearchResultsTabBarWidgets resultsTabBarWidgets;
  late SearchSetup setupSearch;

  final pageIsLoadedNotifier = ValueNotifier<bool>(false);

  void _initializeClasses() {
    setupSearch = SearchSetup(searchText: widget.searchText);
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_onTabChanged);
    resultsTabBarWidgets = SearchResultsTabBarWidgets(
      controller: tabController, 
      searchText: widget.searchText
    );
  }

  void _clearSearchDataOnClose() {
    getIt.searchPostsProvider.clearVents();
    getIt.searchAccountsProvider.clearAccounts();
  }

  void _onTabChanged() async {
    
    if (tabController.index == 1) {
      await setupSearch.setupAccounts();
    }

  }

  void _initializeSearchPosts() async {
    
    try {

      await setupSearch.setupPosts().then((_) {
        pageIsLoadedNotifier.value = true;
      });

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Something went wrong.');
    }

  }

  Widget _buildResultsTabs() {
    return Column(
      children: [

        const SizedBox(height: 15),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            resultsTabBarWidgets.buildTabBar(),

            const Divider(color: ThemeColor.lightGrey, height: 1),

          ],
        ),

        ValueListenableBuilder(
          valueListenable: pageIsLoadedNotifier,
          builder: (_, isLoaded, __) {

            if(!isLoaded) {
              return const SizedBox(
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(color: ThemeColor.white, strokeWidth: 2)
                ),
              );
            }

            return Expanded(
              child: resultsTabBarWidgets.buildTabBarTabs()
            );

          }
        ),

      ],
    );
  }

  Widget _buildSearchTextContainer() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.84,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ThemeColor.thirdWhite)
          ),
          child: InkWellEffect(
            onPressed: () {
              _clearSearchDataOnClose();
              Navigator.pop(context);
            },
            child: Stack(
              children: [
            
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 18.0),
                    child: Icon(CupertinoIcons.search, color: ThemeColor.thirdWhite, size: 20),
                  ),
                ),
            
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.searchText,
                    style: GoogleFonts.inter(
                      color: ThemeColor.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
            
              ],
            )
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeClasses();
    _initializeSearchPosts();
    getIt.navigationProvider.setCurrentRoute(AppRoute.searchResults);
  }

  @override
  void dispose() {
    _clearSearchDataOnClose();
    tabController.dispose();
    pageIsLoadedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        actions: [_buildSearchTextContainer()]
      ).buildAppBar(),    
      body: _buildResultsTabs(),
      bottomNavigationBar: PageNavigationBar(),
    );
  }

}