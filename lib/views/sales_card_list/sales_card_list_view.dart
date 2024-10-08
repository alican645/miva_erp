import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zeytin_app_v2/AppConst.dart';
import 'package:zeytin_app_v2/Models/SalesModel.dart';
import 'package:zeytin_app_v2/services/database_helper.dart';
import 'package:zeytin_app_v2/views/sales_card_list/sales_card_list_viewmodel.dart';
import 'package:zeytin_app_v2/views/sales_edit/SalesEditPage.dart';
import 'package:zeytin_app_v2/utlis/AppUtils.dart';

class SalesCardListView extends StatefulWidget {
  const SalesCardListView({super.key});

  @override
  State<SalesCardListView> createState() => _SalesCardListViewState();
}

class _SalesCardListViewState extends State<SalesCardListView> {
  List<String> list = [];
  DataBaseHelper dbHelper = DataBaseHelper();
  List<SalesModel> salesList = [];

  @override
  void initState() {
    context.read<SalesCardListViewModel>().getSales();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fiş Listesi"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(),
            Padding(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * 0.05,
              ),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: ListView.builder(
                      itemCount: context
                          .watch<SalesCardListViewModel>()
                          .getSalesList
                          .length,
                      itemBuilder: (context, index) => SalesModelItem(
                            salesModel: context
                                .watch<SalesCardListViewModel>()
                                .getSalesList[index],
                          ))),
            )
          ],
        ),
      ),
    );
  }

  Container SalesModelItem({required SalesModel salesModel}) {
    double width = MediaQuery.of(context).size.width;
    TextStyle _textStle = TextStyle(fontSize: 16);
    XFile? xfile;
    xfile = salesModel.image_path.toString() == "null"
        ? null
        : Utils().getStringToXFile(salesModel.image_path.toString());
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(width * 0.02),
      width: width * 0.9,
      decoration: BoxDecoration(
        color: AppConst().blueRomance,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                xfile != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Container(
                          height: 210,
                          width: width * 0.45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(xfile.path),
                                  fit: BoxFit
                                      .cover, // Resmi belirlenen alana sığdırmak için
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        width: width * 0.3,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppConst().paleTeal),
                        child: Center(child: Text("Düzenle")),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SalesEditPage(
                                    id: salesModel.id,
                                  )), // Yeni sayfaya geçiş
                        ).then((value) {
                          // Geri döndüğünde veriyi güncelle
                          context.read<SalesCardListViewModel>().getSales();
                        });
                      },
                    ),
                    SizedBox(
                      height: width * 0.01,
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                content: Container(
                              height: width * 0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Silmek İstediğinizden Eminmisiniz"),
                                  TextButton(
                                      onPressed: () {
                                        dbHelper.deleteSales(salesModel.id!);
                                        context
                                            .read<SalesCardListViewModel>()
                                            .getSales();
                                        Navigator.pop(context);
                                      },
                                      child: Text("Eminim"))
                                ],
                              ),
                            )),
                          );
                        });
                      },
                      child: Container(
                        width: width * 0.3,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.redAccent),
                        child: Center(child: Text("Sil")),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Text("ID: ${salesModel.id}"),
            Text(
              salesModel.musteri.toString(),
              style: _textStle.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              "Kg:${salesModel.kg}",
              style: _textStle,
            ),
            Text(
              salesModel.tek == 1 ? "Tek: Evet" : "Tek: Hayır",
              style: _textStle,
            ),
            Text(
              salesModel.dip == 1 ? "Dip: Evet" : "Dip: Hayır",
              style: _textStle,
            ),
            Text(
              "Zeytin Türü:${salesModel.zeytin_turu}",
              style: _textStle,
            ),
            Text(
              (salesModel.aciklama != "null" && salesModel.aciklama != null)
                  ? "Açıklama:${salesModel.aciklama.toString()}"
                  : "Açıklama: Yok",
              style: _textStle,
            ),
            Text(
              (salesModel.ambalaj != "null" &&
                      salesModel.ambalaj != null &&
                      salesModel.ambalaj != "")
                  ? "Ambalaj Açıklaması:${salesModel.ambalaj.toString()}"
                  : "Ambalaj Açıklaması: Yok",
              style: _textStle,
            ),
            Text(
              (salesModel.palet != "null" &&
                      salesModel.palet != null &&
                      salesModel.palet != "")
                  ? "Palet Numarası:${salesModel.palet.toString()}"
                  : "Palet Numarası: Yok",
              style: _textStle,
            ),
            Text("Fiş Yazdırılma Tarihi: ${salesModel.tarih}"),
            Text("Fiş Numarası : ${salesModel.no}"),
            Text("Müşteri İD : ${salesModel.customerid}"),
          ],
        ),
      ),
    );
  }
}
