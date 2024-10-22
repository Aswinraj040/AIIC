import 'package:flutter/material.dart';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SizeConfig {
  double heightSize(BuildContext context, double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(BuildContext context, double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }
}

class Appbarwidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[600]!,
                        spreadRadius: 1,
                        blurRadius: 6,
                      )
                    ]),
                child: Icon(
                  CupertinoIcons.bars,
                  color: Color(0xFF1B285B),
                  // color:Colors.white
                ),
              ),
            )
          ],
        ));
  }
}
