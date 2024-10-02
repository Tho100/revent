import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/update_navigation.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/themes/theme_color.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
  
}

class HomePageState extends State<HomePage> {

  final navigationIndex = GetIt.instance<NavigationProvider>();

  Widget _buildHomeBody() {
    return Stack(
      children: [
        ListView.builder(
          itemCount: 5,
          itemBuilder: ((context, index) {
            return ListTile(
              title: Text(index.toString(), 
                style: GoogleFonts.inter(
                  color: ThemeColor.white,
                  fontWeight: FontWeight.w700,
                )
              )
            );
          }),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: Padding(
        padding: const EdgeInsets.all(8),
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
          padding: const EdgeInsets.all(8),
          child: IconButton(
            icon: const Icon(CupertinoIcons.gear, size: 20),
            color: ThemeColor.thirdWhite,
            onPressed: () => NavigatePage.settingsPage(context),
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