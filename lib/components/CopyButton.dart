import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CopyButton extends HookWidget {
  final String? _text;
  const CopyButton(this._text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animationController =
        useAnimationController(duration: Duration(milliseconds: 500));
    final animation = ColorTween(begin: Colors.black, end: Colors.green)
        .animate(animationController);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => TextButton.icon(
          icon: Icon(
            Icons.copy,
            color: (animation.value),
          ),
          onPressed: _text != null
              ? () {
                  animationController.forward();
                  Timer((Duration(seconds: 2)), animationController.reverse);
                  FlutterClipboard.copy(_text!);
                  animationController.forward();
                }
              : null,
          label: Text("COPY TO CLIPBOARD")),
    );
  }
}
