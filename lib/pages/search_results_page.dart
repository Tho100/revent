import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/global/type/tabs_type.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/model/setup/search_results_setup.dart';
import 'package:revent/pages/main_search_page.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/dialog/page_loading.dart';
import 'package:revent/shared/widgets/dialog/snack_bar.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
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

class _SearchResultsPageState extends State<SearchResultsPage> with 
  SingleTickerProviderStateMixin, 
  SearchProviderService,
  NavigationProviderService {

  late TabController tabController;
  late SearchResultsTabBarWidgets resultsTabBarWidgets;
  late SearchResultsSetup setupSearch;

  final pageIsLoadedNotifier = ValueNotifier<bool>(false);

  void _initializeClasses() {

    setupSearch = SearchResultsSetup(searchText: widget.searchText);

    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(_onTabChanged);

    resultsTabBarWidgets = SearchResultsTabBarWidgets(controller: tabController);

  }

  void _clearSearchDataOnClose() {
    searchPostsProvider.clearVents();
    searchProfilesProvider.clearAccounts();
  }

  void _onTabChanged() async {
    
    final currentTab = SearchResultsTabs.values[tabController.index];

    if (currentTab == SearchResultsTabs.profiles) {
      await setupSearch.setupProfilesResults();
    }

  }

  void _initializeSearchPosts() async {
    
    try {

      await setupSearch.setupPostsResults().then(
        (_) => pageIsLoadedNotifier.value = true
      );

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }

  }

  Widget _buildResultsTabs() {
    return Column(
      children: [

        const SizedBox(height: 15),

        resultsTabBarWidgets.buildTabBar(),

        Divider(color: ThemeColor.divider, height: 1),

        ValueListenableBuilder(
          valueListenable: pageIsLoadedNotifier,
          builder: (_, isLoaded, __) {
      
            if (!isLoaded) {
              return const SizedBox(
                height: 300,
                child: PageLoading(),
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
    return Transform.translate(
      offset: const Offset(-10, 0),
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ThemeColor.contentThird)
          ),
          child: InkWellEffect(
            onPressed: () {
              _clearSearchDataOnClose();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MainSearchPage()
                )
              );
            },
            child: Stack(
              children: [
            
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Icon(CupertinoIcons.search, color: ThemeColor.contentThird, size: 20),
                  ),
                ),
            
                Center(
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.58,
                    child: Text(
                      widget.searchText,
                      style: GoogleFonts.inter(
                        color: ThemeColor.contentPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis
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
    navigationProvider.setCurrentRoute(AppRoute.searchResults);
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
        titleWidget: _buildSearchTextContainer()
      ).buildAppBar(),    
      body: _buildResultsTabs(),
    );
  }

}