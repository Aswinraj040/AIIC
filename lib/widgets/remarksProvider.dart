import 'package:flutter/material.dart';


class RemarksProvider with ChangeNotifier {

  String _remarks = "";
  String _selectedOption = "Dine In";

  void setOrderType(String type) {
    _selectedOption = type;
    notifyListeners();
  }

  String get remarks => _remarks;
  String get selectedOption => _selectedOption;


  void setRemarks(String newRemarks) {
    _remarks = newRemarks;
    notifyListeners();
  }
}
