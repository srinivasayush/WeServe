import 'package:flutter/material.dart';

class BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(Icons.arrow_back),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
