import 'package:clippy_flutter/arc.dart';
import 'package:enjoyfood/widgets/appbarwidgets.dart';
import 'package:enjoyfood/widgets/cartProvider.dart';
import 'package:enjoyfood/widgets/drawer.dart';
import 'package:enjoyfood/widgets/itembotomnavbar.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ItemPage extends StatefulWidget {
  final dynamic item;

  ItemPage({required this.item});

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    int _itemCount = cartProvider.getItemCount(widget.item);

    return WillPopScope(
      onWillPop: () async {
        return true; // This allows the back button to work
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF1B285B)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Item Details",
            style: TextStyle(color: Color(0xFF1B285B)),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 5),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Image.network(
                  'http://${AppConstants.apiBaseUrl}:3000/images/${widget.item['image_path']}',
                  height: 300,
                ),
              ),
              Arc(
                edge: Edge.BOTTOM,
                height: 30,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 69, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "₹ ${widget.item['price']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Color(0xFF1B285B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.item['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                  color: Color(0xFF1B285B),
                                ),
                              ),
                              Container(
                                width: _itemCount == 0 ? 60 : 90,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[700]!,
                                      spreadRadius: 1,
                                      blurRadius: 6,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: _itemCount == 0
                                    ? InkWell(
                                  onTap: () {
                                    cartProvider.addItem(widget.item);
                                  },
                                  child: Center(
                                    child: Text(
                                      "ADD",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF1B285B),
                                      ),
                                    ),
                                  ),
                                )
                                    : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        cartProvider.removeItem(widget.item);
                                      },
                                      child: Icon(
                                        CupertinoIcons.minus,
                                        size: 20,
                                        color: Color(0xFF1B285B),
                                      ),
                                    ),
                                    Text(
                                      "$_itemCount",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF1B285B),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        cartProvider.addItem(widget.item);
                                      },
                                      child: Icon(
                                        CupertinoIcons.plus,
                                        color: Color(0xFF1B285B),
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            widget.item['description'],
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF1B285B),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: Drawerwidget(),
        bottomNavigationBar: Itembtmnav(),
      ),
    );
  }
}
