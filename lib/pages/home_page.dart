import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/helper/call_refresh.dart';
import 'package:revent/model/update_navigation.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/provider/vent_data_provider.dart';
import 'package:revent/provider/vent_following_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/vent_query/vent_data_setup.dart';
import 'package:revent/widgets/custom_tab_bar.dart';
import 'package:revent/widgets/inkwell_effect.dart';
import 'package:revent/widgets/vent_widgets/vent_listview.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
  
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  final navigationIndex = GetIt.instance<NavigationProvider>();
  
  final followingIsLoadedNotifier = ValueNotifier<bool>(false);

  late TabController tabController;

  Future<void> _followingVentsOnRefresh() async {

    followingIsLoadedNotifier.value = false;

    await CallRefresh().refreshFollowingVents().then((_) {
      followingIsLoadedNotifier.value = true;
    });

  }

  Widget _buildForYouListView() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 28,
        child: RefreshIndicator(
          color: ThemeColor.black,
          onRefresh: () async => await CallRefresh().refreshVents(),
          child: VentListView(provider: Provider.of<VentDataProvider>(context)),
        ),
      ),
    );
  }

  Widget _buildFollowingListView() {
    return ValueListenableBuilder(
      valueListenable: followingIsLoadedNotifier,
      builder: (_, isLoaded, __) {
        if(isLoaded) {
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 28,
              child: RefreshIndicator(
                color: ThemeColor.black,
                onRefresh: () async => await _followingVentsOnRefresh(),
                child: VentListView(provider: Provider.of<VentFollowingDataProvider>(context)),
              ),
            ),
          );

        } else {
          return const Center(
            child: CircularProgressIndicator(color: ThemeColor.white, strokeWidth: 2)
          );

        }
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
        onPressed: () => print('Filter'),
        child: Row(
          children: [
    
            const SizedBox(width: 10),

            const Icon(CupertinoIcons.chevron_down, color: ThemeColor.thirdWhite, size: 18),
    
            const SizedBox(width: 8),
    
            Text(
              'Best',
              style: GoogleFonts.inter(
                color: ThemeColor.thirdWhite,
                fontWeight: FontWeight.w800,
                fontSize: 15
              )
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
    navigationIndex.setPageIndex(0);
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() async {
      if (tabController.index == 1) {
        await VentDataSetup().setupFollowing().then((_) {
          followingIsLoadedNotifier.value = true;
        });
      } 
      navigationIndex.setTabIndex(tabController.index);
    });
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
      bottomNavigationBar: UpdateNavigation(
        context: context,
      ).showNavigationBar(),
    );
  }

}