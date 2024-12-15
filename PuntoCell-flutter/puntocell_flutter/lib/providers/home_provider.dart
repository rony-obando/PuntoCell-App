import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier{
  Widget? body;
  void changeBodyWidget(Widget body){
    this.body=body;
    notifyListeners();
  }

}