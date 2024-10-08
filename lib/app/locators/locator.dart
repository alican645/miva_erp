import 'package:get_it/get_it.dart';
import 'package:zeytin_app_v2/services/database_helper.dart';
import 'package:zeytin_app_v2/services/pdf_helper.dart';
import 'package:zeytin_app_v2/services/shared_preferences_helper.dart';


final locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton<DataBaseHelper>(() => DataBaseHelper(),);
  locator.registerLazySingleton<SharedPreferencesHelper>(() => SharedPreferencesHelper(),);

}