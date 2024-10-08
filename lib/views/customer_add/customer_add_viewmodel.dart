

import 'package:flutter/foundation.dart';
import 'package:zeytin_app_v2/Models/CustomerModel.dart';
import 'package:zeytin_app_v2/app/locators/locator.dart';
import 'package:zeytin_app_v2/services/database_helper.dart';

class CustomerAddViewModel extends ChangeNotifier{

  void insertCustomerModel(CustomerModel customerModel) async{
    await locator<DataBaseHelper>().insertCustomer(customerModel);
    notifyListeners();

  }
}