import 'package:flutter/material.dart';

extension NavigatorExtension on BuildContext {
  
  void popAndRun(VoidCallback action) {
    Navigator.pop(this);
    action();
  }

  Future<void> popAndRunAsync(Future<void> Function() action) async {
    Navigator.pop(this);
    await action();
  }

}