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

class HomePageState extends State<HomePage> {

  final ventData = GetIt.instance<VentDataProvider>();
  final navigationIndex = GetIt.instance<NavigationProvider>();

  Future<void> _refreshVentData() async {

    ventData.deleteVentData();
    
    await VentDataSetup().setup();

  }

  Widget _buildListView() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 28,
        child: RefreshIndicator(
          color: ThemeColor.black,
          onRefresh: () async => await _refreshVentData(),
          child: const VentListView()
        ),
      ),
    );
  }

  Widget _buildHomeBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        const SizedBox(height: 20),

        Expanded(
          child: _buildListView()
        ),

      ],
    );
  }

  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: Padding(
        padding: const EdgeInsets.only(top: 10, left: 5),
        child: Text(
          'Revent',
          style: GoogleFonts.inter(
            color: ThemeColor.white,
            fontWeight: FontWeight.w900,
            fontSize: 22.5
          )
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
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    navigationIndex.setPageIndex(0);
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCustomAppBar(context),
      body: _buildHomeBody(),
      bottomNavigationBar: UpdateNavigation(
        context: context,
      ).showNavigationBar(),
    );
  }

}