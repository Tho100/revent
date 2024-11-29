import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/helper/call_refresh.dart';
import 'package:revent/helper/current_provider.dart';
import 'package:revent/model/format_date.dart';
import 'package:revent/widgets/navigation/page_navigation_bar.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/provider/vent/vent_data_provider.dart';
import 'package:revent/provider/vent/vent_following_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/vent_query/vent_data_setup.dart';
import 'package:revent/widgets/bottomsheet_widgets/vent_filter.dart';
import 'package:revent/widgets/custom_tab_bar.dart';
import 'package:revent/widgets/inkwell_effect.dart';
import 'package:revent/widgets/vent_widgets/home_vent_listview.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
  
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  final navigation = GetIt.instance<NavigationProvider>();

  final ventData = GetIt.instance<VentDataProvider>();
  final ventFollowingData = GetIt.instance<VentFollowingDataProvider>();

  final followingIsLoadedNotifier = ValueNotifier<bool>(false);

  final filterTextNotifier = ValueNotifier<String>('Latest');

  final formatTimestamp = FormatDate();
  final currentProvider = CurrentProvider();

  late TabController tabController;

  void _onTabChanged() async {

    if (tabController.index == 1) {
      await VentDataSetup().setupFollowing().then((_) {
        followingIsLoadedNotifier.value = true;
      });

    } else if (tabController.index == 0) {
      _filterVentsToLatest();

    }
    
    filterTextNotifier.value = 'Latest';

    navigation.setHomeTabIndex(tabController.index);
    
  }

  void _filterVentsToBest() {

    final ventData = currentProvider.getProviderOnly();

    if (ventData.vents is List<Vent>) {

      final vents = (ventData.vents as List<Vent>)
        ..sort((a, b) => a.totalLikes.compareTo(b.totalLikes));

      ventData.setVents(vents);

    } else if (ventData.vents is List<VentFollowing>) {

      final vents = (ventData.vents as List<VentFollowing>)
        ..sort((a, b) => a.totalLikes.compareTo(b.totalLikes));

      ventData.setVents(vents);

    } 

  }

  void _filterVentsToLatest() {

    final ventData = currentProvider.getProviderOnly();

    final sortedVents = ventData.vents
      .toList()
      ..sort((a, b) => formatTimestamp.parseFormattedTimestamp(b.postTimestamp)
        .compareTo(formatTimestamp.parseFormattedTimestamp(a.postTimestamp)));

    ventData.setVents(sortedVents);

  }

  void _filterVentsToOldest() {

    final ventData = currentProvider.getProviderOnly();

    final sortedVents = ventData.vents
      .toList()
      ..sort((a, b) => formatTimestamp.parseFormattedTimestamp(a.postTimestamp)
        .compareTo(formatTimestamp.parseFormattedTimestamp(b.postTimestamp)));

    ventData.setVents(sortedVents);

  }

  void _filterOnPressed({required String filter}) {
    
    switch (filter) {
      case == 'Best':
      _filterVentsToBest();
      break;
    case == 'Latest':
      _filterVentsToLatest();
      break;
    case == 'Oldest':
      _filterVentsToOldest();
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
      _filterVentsToLatest();
    });

  }

  Future<void> _forYouVentsOnRefresh() async {

    await CallRefresh().refreshVents().then((_) {
      filterTextNotifier.value = 'Latest';
      _filterVentsToLatest();
    });

  }

  Widget _buildVentListViewBody({
    required Widget child,
    required Future<void> Function() onRefresh
  }) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 28,
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
        provider: Provider.of<VentDataProvider>(context)
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
            provider: Provider.of<VentFollowingDataProvider>(context)
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
      tabs: const [
        Tab(text: 'For you'),
        Tab(text: 'Following'),
      ],
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
            bestOnPressed: () => _filterOnPressed(filter: 'Best'), 
            latestOnPressed: () => _filterOnPressed(filter: 'Latest'),
            oldestOnPressed: () => _filterOnPressed(filter: 'Oldest'),
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
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(_onTabChanged);
    _filterVentsToLatest();
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