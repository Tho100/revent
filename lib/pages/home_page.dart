import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/update_navigation.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/provider/vent_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/vent_query/vent_data_setup.dart';
import 'package:revent/widgets/vent_widgets/vent_listview.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
  
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  final ventData = GetIt.instance<VentDataProvider>();
  final navigationIndex = GetIt.instance<NavigationProvider>();
  
  late TabController tabController;

  Future<void> _refreshVentData() async {

    ventData.deleteVentsData();

    await VentDataSetup().setup();

  }

  Widget _buildForYouListView() {
    return Expanded(
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 28,
          child: RefreshIndicator(
            color: ThemeColor.black,
            onRefresh: () async => await _refreshVentData(),
            child: const VentListView(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBarBody() {
    return TabBarView(
      controller: tabController,
      children: [
        _buildForYouListView(), 
        Container(),           
      ],
    );
  }

  PreferredSizeWidget _buildTabBar() {
    return TabBar(
      tabAlignment: TabAlignment.center,
      controller: tabController,
      labelColor: ThemeColor.white,              
      unselectedLabelColor: Colors.grey,      
      indicator: UnderlineTabIndicator(
        borderRadius: BorderRadius.circular(36),
        borderSide: const BorderSide(width: 2.5, color: ThemeColor.white),
        insets: const EdgeInsets.symmetric(horizontal: 25), 
      ),
      labelStyle: GoogleFonts.inter(             
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
      unselectedLabelStyle: GoogleFonts.inter(   
        fontSize: 14,
        fontWeight: FontWeight.w800,        
      ),
      tabs: const [
        Tab(text: 'For you'),
        Tab(text: 'Following'),
      ],
    );
  }

  SliverAppBar _buildCustomAppBar(BuildContext context) {
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
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 12),
          child: IconButton(
            icon: const Icon(CupertinoIcons.gear, size: 28),
            color: ThemeColor.thirdWhite,
            onPressed: () => NavigatePage.settingsPage(),
          ),
        ),
      ],
      bottom: _buildTabBar()
    );
  }

  @override
  void initState() {
    super.initState();
    navigationIndex.setPageIndex(0);
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, bool isScrolled) {
          return [_buildCustomAppBar(context)];
        },
        body: _buildTabBarBody()
      ),
      bottomNavigationBar: UpdateNavigation(
        context: context,
      ).showNavigationBar(),
    );
  }

}