import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeytin_app_v2/AppConst.dart';
import 'package:zeytin_app_v2/HomePage.dart';
import 'package:zeytin_app_v2/app/locators/locator.dart';
import 'package:zeytin_app_v2/views/customer_add/customer_add_view.dart';
import 'package:zeytin_app_v2/views/customer_add/customer_add_viewmodel.dart';
import 'package:zeytin_app_v2/views/customer_card_list/customer_card_list_view.dart';
import 'package:zeytin_app_v2/views/customer_card_list/customer_card_list_viewmodel.dart';
import 'package:zeytin_app_v2/views/olive_sales/olive_sales_view.dart';
import 'package:zeytin_app_v2/views/olive_sales/olive_sales_viewmodel.dart';
import 'package:zeytin_app_v2/views/sales_card_list/sales_card_list_view.dart';
import 'package:zeytin_app_v2/views/sales_card_list/sales_card_list_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) =>CustomerAddViewModel(),child: CustomerAddView() ,),
        ChangeNotifierProvider(create: (context) =>CustomerCardListViewModel(),child: CustomerCardListView(),),
        ChangeNotifierProvider(create: (context) =>OliveSalesViewModel(),child: OliveSalesView(),),
        ChangeNotifierProvider(create: (context) =>SalesCardListViewModel(),child: SalesCardListView(),),
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            color: AppConst().vistaBlue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16)))),
        useMaterial3: true,
      ),
      home: SafeArea(
        child: HomePage(),
      ),
    );
  }
}
