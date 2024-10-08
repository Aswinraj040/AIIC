import 'package:flutter/material.dart';
import 'dart:html';

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

class cartnav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: SizeConfig().heightSize(context, 10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Text("Total",
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B285B),
                            )),
                        SizedBox(width: 15),
                        Text("100",
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B285B),
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFF1B285B)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20)),
                        ),
                        child: Text("Order Now",
                            style: TextStyle(
                              color: Colors.white,
                            ))),
                  )
                ])));
  }
}
