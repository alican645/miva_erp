

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zeytin_app_v2/AppConst.dart';
import 'package:zeytin_app_v2/views/customer_add/customer_add_view.dart';
import 'package:zeytin_app_v2/views/customer_card_list/customer_card_list_view.dart';
import 'package:zeytin_app_v2/views/olive_sales/olive_sales_view.dart';
import 'package:zeytin_app_v2/views/sales_card_list/sales_card_list_view.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Zeytin App"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              routerButton(title: "Cari Kart Ekle", onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerAddView()), // Yeni sayfaya geçiş
                );
              }, width: width),
              SizedBox(width: width*0.05,),
              routerButtonOfList(title: "Liste", onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>CustomerCardListView()), // Yeni sayfaya geçiş
                );
              }, width: width),

            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              routerButton(title: "Fiş Ekle", onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OliveSalesView()), // Yeni sayfaya geçiş
                );
              }, width: width),
              SizedBox(width: width*0.05,),
              routerButtonOfList(title: "Liste", onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SalesCardListView()), // Yeni sayfaya geçiş
                );
              }, width: width),

            ],
          )
        ],
      )

    );
  }

  GestureDetector routerButton({required String title,required VoidCallback onPressed,required double width}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width*0.5,
        decoration: BoxDecoration(
          color: AppConst().blueRomance,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppConst().elevationColor, // Gölge rengi
              spreadRadius: 1, // Gölgenin yayılma miktarı
              blurRadius: 7, // Gölgenin bulanıklığı
              offset: Offset(0, 3), // Gölgenin yatay ve dikey uzaklığı
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal:width*0.1,vertical: width*0.05),
        child: Center(
          child: Text(
              title
          ),
        ) ,
      ),
    );
  }
  GestureDetector routerButtonOfList({required String title,required VoidCallback onPressed,required double width}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: AppConst().blueRomance,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppConst().elevationColor, // Gölge rengi
              spreadRadius: 1, // Gölgenin yayılma miktarı
              blurRadius: 7, // Gölgenin bulanıklığı
              offset: Offset(0, 3), // Gölgenin yatay ve dikey uzaklığı
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal:width*0.1,vertical: width*0.05),
        child: Text(
            title
        ) ,
      ),
    );
  }
}