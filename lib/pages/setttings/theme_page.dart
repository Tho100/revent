import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  final isSelectedThemeNotifier = ValueNotifier<List<bool>>([]);

  final themes = ['Dark', 'Light']; // TODO: Make them all underscore

  final themeColor = {
    'Dark': ThemeColor.black,
    'Light': ThemeColor.white,
  };

  String currentTheme = 'Dark';

  void _initializeCurrentTheme() {

    isSelectedThemeNotifier.value = List<bool>.generate(
      themes.length, (index) => currentTheme == themes[index]
    );

  }

  void _changeTheme(int themeIndex) {

    isSelectedThemeNotifier.value = List<bool>.generate(
      themes.length, (index) => index == themeIndex
    );
    
    currentTheme = themes[themeIndex];

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
                onPressed: () => _changeTheme(index),
                child: Row(
                  children: [
                  
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        border: Border.all(color: ThemeColor.white),
                        shape: BoxShape.circle,
                        color: themeColor[themes[index]]
                      ),
                    ),
                  
                    const SizedBox(width: 16),
                          
                    Text(
                      themes[index], // TOOD: capitalize the initial
                      style: GoogleFonts.inter(
                        color: ThemeColor.white,
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
                            color: isSelected[index] ? ThemeColor.white : ThemeColor.thirdWhite, 
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