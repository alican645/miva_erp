
import 'package:flutter/cupertino.dart';
import 'package:zeytin_app_v2/Models/SalesModel.dart';
import 'package:zeytin_app_v2/app/locators/locator.dart';
import 'package:zeytin_app_v2/services/database_helper.dart';

class SalesCardListViewModel extends ChangeNotifier{

  List<SalesModel> _salesList=[];
  List<SalesModel> get getSalesList =>_salesList;
  void getSales() async{
    _salesList = await locator<DataBaseHelper>().getSales();
    notifyListeners();
  }



}