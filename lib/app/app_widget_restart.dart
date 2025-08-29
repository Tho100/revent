import 'package:flutter/material.dart';
// TODO: Remove this
class RestartAppWidget extends StatefulWidget {

  final Widget child;

  const RestartAppWidget({Key? key, required this.child}) : super(key: key);

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  // ignore: library_private_types_in_public_api
  _RestartWidgetState createState() => _RestartWidgetState();

}

class _RestartWidgetState extends State<RestartAppWidget> {

  Key key = UniqueKey();

  void restartApp() => setState(() => key = UniqueKey());

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }

}
