import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';

class CountryPickerModel {

  final BuildContext context;

  CountryPickerModel({required this.context});

  Future<String> startCountryPicker() async {

    final completer = Completer<String>();

    showCountryPicker(
      context: context, // TODO: Put this inside its own organized function as List<String>
      exclude: ['AI', 'AX', 'AS', 'BQ', 'BZ', 'BM', 'BL', 'AW', 'IO', 'KY', 'FO', 'CK', 'VG', 'FK', 'MQ', 'SH', 'ST', 'MF', 'PM', 'VC', 'GF', 'GP', 'GS', 'GI', 'NC', 'YT', 'EH', 'WF', 'KP', 'CC', 'CX', 'HM', 'AC', 'FM', 'NF', 'MP', 'MS', 'VI', 'TC', 'RE', 'GU', 'JE', 'CV', 'KM', 'PF', 'FJ', 'NU', 'SJ', 'TV', 'VU', 'TK', 'DJ', 'GG', 'GD', 'GN', 'GW', 'SB', 'IM', 'NI'],
      onSelect: (Country country) => completer.complete(country.name),
      useSafeArea: true,
      showSearch: false,
      countryListTheme: CountryListThemeData(
        backgroundColor: ThemeColor.backgroundPrimary,
        bottomSheetHeight: 500,
        flagSize: 27,
        padding: const EdgeInsets.only(top: 16),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
        textStyle: GoogleFonts.inter(
          color: ThemeColor.contentPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w700
        ),
      ),
    );

    return completer.future;

  }

}