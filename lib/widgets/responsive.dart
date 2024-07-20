import 'package:flutter/material.dart';
class ResponsiveWidget extends StatelessWidget {
  final Widget mobiView;
  final Widget webView;

  const ResponsiveWidget({super.key, required this.mobiView, required this.webView});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 950) {
        return mobiView;
      } else {
        return webView;
      }
    });
  }
}
