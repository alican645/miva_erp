

import 'package:flutter/foundation.dart';
import 'package:zeytin_app_v2/Models/CustomerModel.dart';
import 'package:zeytin_app_v2/app/locators/locator.dart';
import 'package:zeytin_app_v2/services/database_helper.dart';

class CustomerCardListViewModel extends ChangeNotifier{

  final db_service=locator<DataBaseHelper>();
  ///Customer Card List View widgetı için oluşturulan fonksiyonu hazırladık bu sayede
  ///customer modelleri widget'ın olduğu sayfaya değil bu sayfaya çekiliyor ve liste bu sayfadan dinlerniyor.
  List<CustomerModel>? _customerList=[];
  List<CustomerModel>? get customerList => _customerList;
  void getCustomers() async{
    _customerList=await db_service.getCustomer();
    print(_customerList);
    notifyListeners();
  }


}