import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/service/refresh_service.dart';
import 'package:revent/service/query/general/follow_suggestion_getter.dart';
import 'package:revent/shared/provider/follow_suggestion_provider.dart';
import 'package:revent/shared/provider/vent/vent_trending_provider.dart';
import 'package:revent/shared/widgets/navigation/page_navigation_bar.dart';
import 'package:revent/shared/provider/vent/vent_latest_provider.dart';
import 'package:revent/shared/provider/vent/vent_following_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/model/setup/vents_setup.dart';
import 'package:revent/shared/widgets/custom_tab_bar.dart';
import 'package:revent/shared/widgets/ui_dialog/page_loading.dart';
import 'package:revent/shared/widgets/vent_widgets/home_vent_listview.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage> with 
  SingleTickerProviderStateMixin, 
  VentProviderService, 
  NavigationProviderService,
  FollowSuggestionProviderService {

  final latestIsLoadedNotifier = ValueNotifier<bool>(false);
  final followingIsLoadedNotifier = ValueNotifier<bool>(false);
  final trendingIsLoadedNotifier = ValueNotifier<bool>(false);

  final localStorage = LocalStorageModel();
  final ventDataSetup = VentsSetup();
  final refreshService = RefreshService();

  late TabController tabController;

  final homeTabs = const [
    Tab(text: 'Latest'),
    Tab(text: 'Trending'),
    Tab(text: 'Following')
  ];

  void _initializeCurrentTab() async {

    final currentTab = await localStorage.readCurrentHomeTab();

    final currentTabIndex = homeTabs.indexWhere((tab) => tab.text == currentTab);

    tabController.index = currentTabIndex != -1 ? currentTabIndex : 0;

    if (currentTab == 'Latest' && latestVentProvider.vents.isNotEmpty) {
      latestIsLoadedNotifier.value = true;

    } else if (currentTab == 'Trending' && trendingVentProvider.vents.isNotEmpty) {
      trendingIsLoadedNotifier.value = true;

    } else if (currentTab == 'Following' && followingVentProvider.vents.isNotEmpty) {
      followingIsLoadedNotifier.value = true;

    }

    navigationProvider.setHomeTabIndex(currentTabIndex);

  }

  void _onTabChanged() async {

    final currentTab = homeTabs[tabController.index].text!;

    await localStorage.setupCurrentHomeTab(tab: currentTab);

    if (tabController.index == 0) {

      if (latestVentProvider.vents.isNotEmpty) {
        latestIsLoadedNotifier.value = true;
        return;
      }

      if (!latestIsLoadedNotifier.value && latestVentProvider.vents.isEmpty) {
        await ventDataSetup.setupLatest().then(
          (_) => latestIsLoadedNotifier.value = true
        );
      }

    } else if (tabController.index == 1) {

      if (trendingVentProvider.vents.isNotEmpty) {
        trendingIsLoadedNotifier.value = true;
        return;
      }

      if (!trendingIsLoadedNotifier.value && trendingVentProvider.vents.isEmpty) {
        await ventDataSetup.setupTrending().then(
          (_) => trendingIsLoadedNotifier.value = true
        );
      }

    } else if (tabController.index == 2) {

      if (followingVentProvider.vents.isNotEmpty) {
        followingIsLoadedNotifier.value = true;
        return;
      }

      if (!followingIsLoadedNotifier.value && followingVentProvider.vents.isEmpty) {
        await ventDataSetup.setupFollowing().then(
          (_) => followingIsLoadedNotifier.value = true
        );
      }

    }
    
    navigationProvider.setHomeTabIndex(tabController.index);
    
  }

  void _initializeTabController() {

    tabController = TabController(
      length: homeTabs.length, vsync: this
    );

    tabController.addListener(_onTabChanged);

  }

  void _initializeFollowSuggestion() async {

    if (followSuggestionProvider.suggestions.isEmpty) {

      final followSuggestions = await FollowSuggestionGetter().getSuggestion();

      final usernames = followSuggestions['usernames'];
      final profilePic = followSuggestions['profile_pic'];

      final suggestions = List.generate(usernames.length, (index) {
        return FollowSuggestionData(
          username: usernames[index], 
          profilePic: profilePic[index]
        );
      });

      followSuggestionProvider.setSuggestions(suggestions);

    }

  }

  Future<void> _onTabRefresh() async {

    switch (homeTabs[tabController.index].text) {
      case 'Latest':
        latestIsLoadedNotifier.value = false;
        await refreshService.refreshLatestVents().then(
          (_) => latestIsLoadedNotifier.value = true
        );
        break;
      case 'Trending':
        trendingIsLoadedNotifier.value = false;
        await refreshService.refreshTrendingVents().then(
          (_) => trendingIsLoadedNotifier.value = true
        );
        break;
      case 'Following':
        followingIsLoadedNotifier.value = false;
        await refreshService.refreshFollowingVents().then(
          (_) => followingIsLoadedNotifier.value = true
        );
        break;
    }

  }

  Widget _buildVentListViewBody({
    required Widget child,
    required Future<void> Function() onRefresh
  }) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 25,
        child: RefreshIndicator(
          backgroundColor: ThemeColor.contentPrimary,
          color: ThemeColor.backgroundPrimary,
          onRefresh: onRefresh,
          child: child
        ),
      ),
    );
  }

  Widget _buildLatestListView() {
    return ValueListenableBuilder(
      valueListenable: latestIsLoadedNotifier,
      builder: (_, isLoaded, __) {
        
        if (!isLoaded) {
          return const PageLoading();
        }

        return _buildVentListViewBody(
          onRefresh: () async => await _onTabRefresh(),
          child: HomeVentListView(
            provider: Provider.of<VentLatestProvider>(context),
            showFollowSuggestion: true
          ),
        );

      },
    );
  }

  Widget _buildTrendingListView() {
    return ValueListenableBuilder(
      valueListenable: trendingIsLoadedNotifier,
      builder: (_, isLoaded, __) {

        if (!isLoaded) {
          return const PageLoading();
        }

        return _buildVentListViewBody(
          onRefresh: () async => await _onTabRefresh(),
          child: HomeVentListView(
            provider: Provider.of<VentTrendingProvider>(context),
            showFollowSuggestion: true
          ),
        ); 

      },
    );
  }

  Widget _buildFollowingListView() {
    return ValueListenableBuilder(
      valueListenable: followingIsLoadedNotifier,
      builder: (_, isLoaded, __) {

        if (!isLoaded) {
          return const PageLoading();
        }

        return _buildVentListViewBody(
          onRefresh: () async => await _onTabRefresh(),
          child: HomeVentListView(
            provider: Provider.of<VentFollowingProvider>(context)
          ),
        ); 

      },
    );
  }

  Widget _buildTabBarTabs() {
    return TabBarView(
      controller: tabController,
      children: [
        _buildLatestListView(), 
        _buildTrendingListView(),
        _buildFollowingListView(),           
      ],
    );
  }

  PreferredSizeWidget _buildTabBar() {
    return CustomTabBar(
      controller: tabController, 
      tabAlignment: TabAlignment.center,
      tabs: homeTabs,
    ).buildTabBar();
  }

  SliverAppBar _buildCustomAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(top: 8, right: 10.5),
        child: Text(
          'Revent',
          style: GoogleFonts.inter(
            color: ThemeColor.contentPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 22.5,
          ),
        ),
      ),
      bottom: _buildTabBar()
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeCurrentTab();
    _initializeTabController();
    _initializeFollowSuggestion();
  }

  @override
  void dispose() {
    tabController.dispose();
    latestIsLoadedNotifier.dispose();
    followingIsLoadedNotifier.dispose();
    trendingIsLoadedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, __) {
          return [_buildCustomAppBar()];
        },
        body: _buildTabBarTabs()
      ),
      bottomNavigationBar: PageNavigationBar()
    );
  }

}