import 'package:flutter/material.dart';
import 'package:aplicativo/generated/l10n.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(S.of(context).home),
    );
  }
}
