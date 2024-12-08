import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/app_route.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/provider/search/search_posts_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/vent_query/vent_data_setup.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/search/results_tabbar_widgets.dart';

class SearchResultsPage extends StatefulWidget {

  final String searchText;

  const SearchResultsPage({
    required this.searchText, 
    super.key
  });

  @override
  State<SearchResultsPage> createState() => SearchResultsPageState();

}

class SearchResultsPageState extends State<SearchResultsPage> with SingleTickerProviderStateMixin {

  late TabController tabController;
  late SearchResultsTabBarWidgets resultsTabBarWidgets;

  /// TODO: Add bottom-navigation bar
  void _initializeClasses() {
    tabController = TabController(length: 3, vsync: this);
    resultsTabBarWidgets = SearchResultsTabBarWidgets(
      controller: tabController, 
      searchText: widget.searchText
    );
  }

  Future<void> _initializeSearchData() async {

    try {

      await VentDataSetup().setupSearch(
        searchText: widget.searchText
      );

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Something went wrong.');
    }

  }

  Widget _buildResultsTabs() {
    return Column(
      children: [

        const SizedBox(height: 20),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            resultsTabBarWidgets.buildTabBar(),

            const Divider(color: ThemeColor.lightGrey, height: 1),

          ],
        ),

        Expanded(
          child: resultsTabBarWidgets.buildTabBarTabs()
        )

      ],
    );
  }

  Widget _buildSearchTextContainer() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.91,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ThemeColor.thirdWhite)
        ),
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
    );
  }

  Widget _buildBody() {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: _buildSearchTextContainer(),           
          ),
        ),
      ],
      body: _buildResultsTabs(),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeClasses();
    _initializeSearchData();
    GetIt.instance<NavigationProvider>().setCurrentRoute(AppRoute.searchResults);
  }

  @override
  void dispose() {
    GetIt.instance<SearchPostsProvider>().clearVents();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
      ).buildAppBar(),    
      body: _buildBody()
    );
  }

}