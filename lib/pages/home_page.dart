import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/helper/call_refresh.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/provider/vent/vent_trending_provider.dart';
import 'package:revent/shared/widgets/navigation/page_navigation_bar.dart';
import 'package:revent/shared/provider/vent/vent_for_you_provider.dart';
import 'package:revent/shared/provider/vent/vent_following_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/model/setup/vent_data_setup.dart';
import 'package:revent/shared/widgets/custom_tab_bar.dart';
import 'package:revent/shared/widgets/vent_widgets/home_vent_listview.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  final navigation = getIt.navigationProvider;
  final ventData = getIt.ventForYouProvider;
  final ventFollowingData = getIt.ventFollowingProvider;

  final followingIsLoadedNotifier = ValueNotifier<bool>(false);
  final trendingIsLoadedNotifier = ValueNotifier<bool>(false);

  final ventDataSetup = VentDataSetup();

  late TabController tabController;

  final homeTabs = const [
    Tab(text: 'For you'),
    Tab(text: 'Trending'),
    Tab(text: 'Following')
  ];

  void _onTabChanged() async {

    if (tabController.index == 1) {

      if(trendingIsLoadedNotifier.value == false) {
        await ventDataSetup.setupTrending().then(
          (_) => trendingIsLoadedNotifier.value = true
        );
      }

    } else if (tabController.index == 2) {

      if(followingIsLoadedNotifier.value == false) {
        await ventDataSetup.setupFollowing().then(
          (_) => followingIsLoadedNotifier.value = true
        );
      }

    }
    
    navigation.setHomeTabIndex(tabController.index);
    
  }

  void _initializeTabController() {
    tabController = TabController(
      length: homeTabs.length, vsync: this
    );
    tabController.addListener(_onTabChanged);
  }

  // TODO: Create separated single function for refresh
  Future<void> _forYouVentsOnRefresh() async {

    await CallRefresh().refreshVents();

  }

  Future<void> _trendingVentsOnRefresh() async {

    trendingIsLoadedNotifier.value = false;

    await CallRefresh().refreshTrendingVents().then((_) {
      trendingIsLoadedNotifier.value = true;
    });

  }

  Future<void> _followingVentsOnRefresh() async {

    followingIsLoadedNotifier.value = false;

    await CallRefresh().refreshFollowingVents().then((_) {
      followingIsLoadedNotifier.value = true;
    });

  }

  Widget _buildVentListViewBody({
    required Widget child,
    required Future<void> Function() onRefresh
  }) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 25,
        child: RefreshIndicator(
          color: ThemeColor.black,
          onRefresh: onRefresh,
          child: child
        ),
      ),
    );
  }

  Widget _buildForYouListView() {
    return _buildVentListViewBody(
      onRefresh: () async => await _forYouVentsOnRefresh(),
      child: HomeVentListView(
        provider: Provider.of<VentForYouProvider>(context)
      ),
    );
  }

  Widget _buildTrendingListView() {
    return ValueListenableBuilder(
      valueListenable: trendingIsLoadedNotifier,
      builder: (_, isLoaded, __) {

        if(!isLoaded) {
          return const Center(
            child: CircularProgressIndicator(color: ThemeColor.white, strokeWidth: 2)
          );
        }

        return _buildVentListViewBody(
          onRefresh: () async => await _trendingVentsOnRefresh(),
          child: HomeVentListView(
            provider: Provider.of<VentTrendingProvider>(context)
          ),
        ); 

      },
    );
  }

  Widget _buildFollowingListView() {
    return ValueListenableBuilder(
      valueListenable: followingIsLoadedNotifier,
      builder: (_, isLoaded, __) {

        if(!isLoaded) {
          return const Center(
            child: CircularProgressIndicator(color: ThemeColor.white, strokeWidth: 2)
          );
        }

        return _buildVentListViewBody(
          onRefresh: () async => await _followingVentsOnRefresh(),
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
        _buildForYouListView(), 
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
            color: ThemeColor.white,
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
    _initializeTabController();
  }

  @override
  void dispose() {
    tabController.dispose();
    followingIsLoadedNotifier.dispose();
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