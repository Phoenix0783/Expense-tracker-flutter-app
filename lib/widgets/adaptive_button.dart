import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AdaptiveButton extends StatelessWidget {
  final String text;
  final Function handler;

  AdaptiveButton(this.handler, this.text);

  @override
  Widget build(BuildContext context) {
    print('build() adaptive');
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: handler)
        : FlatButton(
            textColor: Theme.of(context).primaryColor,
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: handler,
          );
  }
}
