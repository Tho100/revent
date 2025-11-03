import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restart_app/restart_app.dart';
import 'package:revent/helper/general/capitalizer.dart';
import 'package:revent/shared/themes/theme_updater.dart';
import 'package:revent/main.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/shared/themes/app_theme.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/boredered_container.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';

class ThemePage extends StatefulWidget {

  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();

}

class _ThemePageState extends State<ThemePage> {

  final localStorageModel = LocalStorageModel();

  final isSelectedThemeNotifier = ValueNotifier<List<bool>>([]);

  final themes = ['dark', 'light', 'gray', 'pink', 'blue', 'green', 'cherry', 'grape'];

  final themeColor = {
    'dark': Colors.black,
    'light': Colors.white,
    'gray': const Color.fromARGB(255, 115, 115, 115),
    'pink': const Color.fromARGB(255, 248, 124, 165),
    'blue': const Color.fromARGB(255, 99, 135, 255),
    'green': const Color.fromARGB(255, 83, 232, 130),
    'cherry': const Color.fromARGB(255, 222, 73, 88),
    'grape': const Color.fromARGB(255, 153, 83, 252),
  };

  String currentTheme = 'dark';

  void _initializeCurrentTheme() async {

    currentTheme = await localStorageModel.readThemeInformation();

    if(!themes.contains(currentTheme)) {
      currentTheme = 'dark';
    }

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
      
    await Restart.restartApp();

  }

  Widget _buildSplitTheme(Color color) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        border: Border.all(
          color: ThemeColor.contentPrimary, 
          width: 3
        ),
        shape: BoxShape.circle,
      ),
      child: Row(
        children: [

          Container(
            width: 18,
            height: 42,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(21),
                bottomLeft: Radius.circular(21),
              ),
            ),
          ),

          Container(
            width: 18,
            height: 38,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(155),
                bottomRight: Radius.circular(155),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildThemeSelection(int index) {
    return BorderedContainer(
      doubleInternalPadding: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: InkWellEffect(
          onPressed: () => _onUpdateThemePressed(index),
          child: Row(
            children: [
            
              themes[index] == 'cherry' || themes[index] == 'grape'
                ? _buildSplitTheme(themeColor[themes[index]]!)
                : Container(
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

                  final selected = (isSelected.isNotEmpty && index < isSelected.length) 
                    ? isSelected[index] 
                    : false;

                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(
                      selected ? CupertinoIcons.check_mark_circled : CupertinoIcons.circle, 
                      color: selected ? ThemeColor.contentPrimary : ThemeColor.contentThird, 
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

  Widget _buildThemeListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.90,
      child: ListView.builder(
        itemCount: themes.length,
        itemBuilder: (_, index) {
          return _buildThemeSelection(index);
        }
      ),
    );
  }

  Widget _buildBody() {
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
      body: _buildBody(),
    );
  }

}