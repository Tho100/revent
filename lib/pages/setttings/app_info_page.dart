import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:revent/app/app_cache.dart';
import 'package:revent/pages/setttings/app_info/pp_page.dart';
import 'package:revent/pages/setttings/app_info/tp_page.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/boredered_container.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/settings_button.dart';
import 'package:revent/shared/widgets/buttons/sub_button.dart';

class AppInfoPage extends StatefulWidget {

  const AppInfoPage({super.key});

  @override
  State<AppInfoPage> createState() => _AppInfoPageState();

}

class _AppInfoPageState extends State<AppInfoPage> {
  
  final cacheNotifier = ValueNotifier<String>('');

  void _clearAppCache() async {
    
    final cacheSizeInMb = await AppCache().cacheSizeInMb();
    
    await DefaultCacheManager().emptyCache();

    final tempDir = await getTemporaryDirectory();

    if(tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }

    SnackBarDialog.temporarySnack(message: "Freed up ${cacheSizeInMb.toDouble().toStringAsFixed(2)}Mb.");

    _initializeCacheSize();

  }

  void _initializeCacheSize() async {

    final cacheSizeInMb = await AppCache().cacheSizeInMb();

    cacheNotifier.value = "${cacheSizeInMb.toDouble().toStringAsFixed(2)}Mb";

  }

  Widget _buildHeaders(String header, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text(
            header,
            style: GoogleFonts.inter(
              color: ThemeColor.thirdWhite,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
    
          const SizedBox(height: 8),
    
          Text(
            value,
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
    
          const SizedBox(height: 20),
    
        ],
      ),
    );
  }

  Widget _buildClearCacheButton() {
    return SubButton(
      text: 'Clear cache', 
      onPressed: () => _clearAppCache()
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    
          BorderedContainer(
            doubleInternalPadding: true,
            child: Row(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      _buildHeaders('Version', '1.4.2'),
                          
                      ValueListenableBuilder(
                        valueListenable: cacheNotifier,
                        builder: (_, cacheSize, __) {
                          return _buildHeaders('Cache', cacheSize);
                        },
                      ),
                          
                      Padding(
                        padding: const EdgeInsets.only(left: 14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            Text(
                              "You can free up storage by clearing cache.\nYour data won't be affected.",
                              style: GoogleFonts.inter(
                                color: ThemeColor.thirdWhite,
                                fontWeight: FontWeight.w800,
                                fontSize: 14
                              ),
                            ),
                            
                            const SizedBox(height: 15),
                                      
                            _buildClearCacheButton(),
                      
                          ],
                        ),
                      ),
                  
                    ],
                  ),
                ),

                const Spacer(),

              ],
            ),
          ),
              
          BorderedContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                      
                  SettingsButton(
                    text: 'Term and Conditions', 
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TermAndConditionsPage())
                      );
                    }
                  ),
                
                  const SizedBox(height: 8),
                
                  SettingsButton(
                    text: 'Privacy Policy', 
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PrivacyPolicyPage())
                      );
                    }
                  ),
                  
                ],
              ),
            ),
          ),
    
        ],
      ),
    );
  }

  @override 
  void initState() {
    super.initState();
    _initializeCacheSize();
  }

  @override 
  void dispose() {
    cacheNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        title: 'Info'
      ).buildAppBar(),
      body: _buildBody(),
    );
  }

}