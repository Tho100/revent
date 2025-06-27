import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/app/app_widget_restart.dart';
import 'package:revent/helper/capitalizer.dart';
import 'package:revent/shared/themes/theme_updater.dart';
import 'package:revent/main.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/shared/themes/app_theme.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/boredered_container.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';

class ThemePage extends StatefulWidget {

  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();

}

class _ThemePageState extends State<ThemePage> {

  final localStorageModel = LocalStorageModel();

  final isSelectedThemeNotifier = ValueNotifier<List<bool>>([]);

  final themes = ['dark', 'light'];

  final themeColor = {
    'dark': Colors.black,
    'light': Colors.white,
  };

  String currentTheme = 'dark';

  void _initializeCurrentTheme() async {

    currentTheme = await localStorageModel.readThemeInformation();

    isSelectedThemeNotifier.value = List<bool>.generate(
      themes.length, (index) => currentTheme == themes[index]
    );

  }

  void _onUpdateThemePressed(int themeIndex) async {

    final selectedTheme = themes[themeIndex];

    if (selectedTheme == currentTheme) {
      return;
    }

    await localStorageModel.setupThemeInformation(theme: selectedTheme).then(
      (_) => ThemeUpdater(theme: selectedTheme).updateTheme()    
    );

    globalThemeNotifier.value = GlobalAppTheme().buildAppTheme();

    isSelectedThemeNotifier.value = List<bool>.generate(
      themes.length, (index) => index == themeIndex
    );
      
    currentTheme = selectedTheme;

    if (context.mounted) {
      RestartAppWidget.restartApp(context);
    }

    CustomAlertDialog.alertDialogTitle(
      'Theme Updated',
      'Restart the app to see full changes.', 
    );

  }

  Widget _buildThemeListView() {
    return SizedBox(
      height: 500,
      child: ListView.builder(
        itemCount: themes.length,
        itemBuilder: (_, index) {
          return BorderedContainer(
            doubleInternalPadding: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: InkWellEffect(
                onPressed: () => _onUpdateThemePressed(index),
                child: Row(
                  children: [
                  
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ThemeColor.contentPrimary, 
                          width: 3
                        ),
                        shape: BoxShape.circle,
                        color: themeColor[themes[index]]
                      ),
                    ),
                  
                    const SizedBox(width: 16),
                          
                    Text(
                      Capitalizer.capitalize(themes[index]),
                      style: GoogleFonts.inter(
                        color: ThemeColor.contentPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 17
                      ),
                    ),
              
                    const Spacer(),
              
                    ValueListenableBuilder(
                      valueListenable: isSelectedThemeNotifier,
                      builder: (_, isSelected, __) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Icon(
                            isSelected[index] ? CupertinoIcons.check_mark_circled : CupertinoIcons.circle, 
                            color: isSelected[index] ? ThemeColor.contentPrimary : ThemeColor.contentThird, 
                            size: 25
                          ),
                        );
                      },
                    ),
                  
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: _buildThemeListView()
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeCurrentTheme();
  }

  @override
  void dispose() {
    isSelectedThemeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        title: 'Theme'
      ).buildAppBar(),
      body: _buildBody(context),
    );
  }

}