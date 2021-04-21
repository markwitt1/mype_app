import 'package:flutter/material.dart';

class BadText extends StatelessWidget {
  final String text;
  const BadText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ))),
    );
  }
}
