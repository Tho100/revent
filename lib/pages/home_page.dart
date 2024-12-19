import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/helper/call_refresh.dart';
import 'package:revent/main.dart';
import 'package:revent/model/filter/home_filter.dart';
import 'package:revent/shared/widgets/navigation/page_navigation_bar.dart';
import 'package:revent/shared/provider/vent/vent_for_you_provider.dart';
import 'package:revent/shared/provider/vent/vent_following_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/model/setup/vent_data_setup.dart';
import 'package:revent/shared/widgets/bottomsheet_widgets/vent_filter.dart';
import 'package:revent/shared/widgets/custom_tab_bar.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
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
  final filterTextNotifier = ValueNotifier<String>('Latest');

  final filterModel = HomeFilter();

  late TabController tabController;

  final homeTabs = const [
    Tab(text: 'For you'),
    Tab(text: 'Following'),
  ];

  void _onTabChanged() async {

    if (tabController.index == 1) {

      if(ventFollowingData.vents.isEmpty) {
        await VentDataSetup().setupFollowing().then((_) {
          followingIsLoadedNotifier.value = true;
        });
      }

    } 
    
    filterModel.filterHomeToLatest();
    filterTextNotifier.value = 'Latest';

    navigation.setHomeTabIndex(tabController.index);
    
  }

  void _initializeTabController() {
    tabController = TabController(
      length: homeTabs.length, vsync: this
    );
    tabController.addListener(_onTabChanged);
  }

  void _filterOnPressed({required String filter}) {

    switch (filter) {
      case == 'Trending':
      filterModel.filterHomeToTrending();
      break;
    case == 'Latest':
      filterModel.filterHomeToLatest();
      break;
    }

    filterTextNotifier.value = filter;

    Navigator.pop(context);

  }

  Future<void> _followingVentsOnRefresh() async {

    followingIsLoadedNotifier.value = false;

    await CallRefresh().refreshFollowingVents().then((_) {
      followingIsLoadedNotifier.value = true;
      filterTextNotifier.value = 'Latest';
      filterModel.filterHomeToLatest();
    });

  }

  Future<void> _forYouVentsOnRefresh() async {

    await CallRefresh().refreshVents().then((_) {
      filterTextNotifier.value = 'Latest';
      filterModel.filterHomeToLatest();
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

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 8),
      child: InkWellEffect(
        onPressed: () {
          BottomsheetVentFilter().buildBottomsheet(
            context: context, 
            currentFilter: filterTextNotifier.value,
            tabName: homeTabs[tabController.index].text!,
            trendingOnPressed: () => _filterOnPressed(filter: 'Trending'), 
            latestOnPressed: () => _filterOnPressed(filter: 'Latest'),
          );
        },
        child: Row(
          children: [
    
            const SizedBox(width: 10),

            const Icon(CupertinoIcons.chevron_down, color: ThemeColor.thirdWhite, size: 18),
    
            const SizedBox(width: 8),
    
            ValueListenableBuilder(
              valueListenable: filterTextNotifier,
              builder: (_, filterText, __) {
                return Text(
                  filterText,
                  style: GoogleFonts.inter(
                    color: ThemeColor.thirdWhite,
                    fontWeight: FontWeight.w800,
                    fontSize: 15
                  )
                );
              }
            ),

            const SizedBox(width: 10),
    
          ],
        ),
      )
    );
  }

  SliverAppBar _buildCustomAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      centerTitle: false,
      title: Padding(
        padding: const EdgeInsets.only(top: 10, left: 5),
        child: Text(
          'Revent',
          style: GoogleFonts.inter(
            color: ThemeColor.white,
            fontWeight: FontWeight.w900,
            fontSize: 22.5,
          ),
        ),
      ),
      actions: [_buildActionButton()],
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
    filterTextNotifier.dispose();
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