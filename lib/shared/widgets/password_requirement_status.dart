import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';

class PasswordRequirementStatus extends StatefulWidget {

  final ValueNotifier isContinue;
  final String requirement;

  const PasswordRequirementStatus({
    required this.isContinue,
    required this.requirement,
    super.key
  });

  @override
  State<PasswordRequirementStatus> createState() => _PasswordRequirementStatusState();

}

class _PasswordRequirementStatusState extends State<PasswordRequirementStatus> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        ValueListenableBuilder(
          valueListenable: widget.isContinue,
          builder: (_, isEnabled, __) {
            return isEnabled 
              ? Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: ThemeColor.contentPrimary,
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Icon(Icons.check, color: ThemeColor.backgroundPrimary, size: 15)
              )
              : Text(
                ThemeStyle.dotSeparator,
                style: GoogleFonts.inter(
                  color: ThemeColor.contentThird,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              );
          }
        ),

        const SizedBox(width: 8),
        
        Text(
          widget.requirement,
          style: GoogleFonts.inter(
            color: ThemeColor.contentSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        )

      ],
    );
  }

}