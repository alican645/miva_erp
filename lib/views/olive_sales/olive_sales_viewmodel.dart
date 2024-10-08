
import 'package:flutter/material.dart';
import 'package:zeytin_app_v2/Models/CustomerModel.dart';
import 'package:zeytin_app_v2/Models/SalesModel.dart';
import 'package:zeytin_app_v2/app/locators/locator.dart';
import 'package:zeytin_app_v2/services/database_helper.dart';
import 'package:zeytin_app_v2/services/shared_preferences_helper.dart';

class OliveSalesViewModel extends ChangeNotifier{


  void insertOliveSalesModel  (SalesModel salesModel)  async {
    await locator<DataBaseHelper>().insertSale(salesModel);
    notifyListeners();
  }

  int? _fisSira;
  get fisSira => _fisSira;
  int? _month;
  get month => _month;
  ///Shared Preferences İşlemleri
  void getFisSira() async {
    _fisSira=await locator<SharedPreferencesHelper>().getInt("fisSira", def: 0);
  }

  void setFisSira(int value)async{
    locator<SharedPreferencesHelper>().setInt("fisSira", value);
  }

  void getMonth() async{
    _month=await locator<SharedPreferencesHelper>().getInt("month", def: 10);

  }

  void setMonth(int currentMonth) async {
    locator<SharedPreferencesHelper>().setInt("month",currentMonth);
  }

  List<CustomerModel>? _customerList=[];
  List<CustomerModel>? get customerList => _customerList;
  void getCustomers() async{
    _customerList=await locator<DataBaseHelper>().getCustomer();
    notifyListeners();
  }
  int? _lastSalesIndex;
  int get lastSalesIndex => _lastSalesIndex!;
  void getLastSalesIndex() async{
    _lastSalesIndex=await locator<DataBaseHelper>().getLastInsertedSaleId();
  }


}