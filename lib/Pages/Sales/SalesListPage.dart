import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zeytin_app_v2/AppConst.dart';
import 'package:zeytin_app_v2/DataBaseHelper.dart';
import 'package:zeytin_app_v2/Models/SalesModel.dart';
import 'package:zeytin_app_v2/Pages/Sales/SalesEditPage.dart';
import 'package:zeytin_app_v2/utlis/AppUtils.dart';

class SalesListPages extends StatefulWidget {
  const SalesListPages({super.key});

  @override
  State<SalesListPages> createState() => _SalesListPagesState();
}

class _SalesListPagesState extends State<SalesListPages> {
  List<String> list = [];
  DataBaseHelper dbHelper = DataBaseHelper();
  List<SalesModel> salesList = [];

  @override
  void initState() {
    super.initState();
    _getSales();
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
            ...List.generate(salesList.length,
                (index) => SalesModelItem(salesModel: salesList[index]))
          ],
        ),
      ),
    );
  }

  void _getSales() async {
    var result = dbHelper.getSales();
    result.then((value) {
      //value değerini setstate ile beraber listeye aktarıyoruz ki widget tree tekrardan yapılandırılsın.
      setState(() {
        salesList = value;
      });
    });
  }

  Container SalesModelItem({required SalesModel salesModel}) {
    double width = MediaQuery.of(context).size.width;
    TextStyle _textStle = TextStyle(fontSize: 16);
    XFile xfile;
    xfile = Utils().getStringToXFile(salesModel.image_path.toString());
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Container(
                    height: 210,
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
                ),
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
                        );
                      },
                    ),
                    SizedBox(
                      height: width * 0.01,
                    ),
                    GestureDetector(
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
              (salesModel.ambalaj != "null" && salesModel.ambalaj != null)
                  ? "Ambalaj Açıklaması:${salesModel.ambalaj.toString()}"
                  : "Ambalaj Açıklaması: Yok",
              style: _textStle,
            ),
            Text("Fiş Yazdırılma Tarihi: ${salesModel.tarih}"),
            Text("Fiş Numarası : ${salesModel.no}"),
          ],
        ),
      ),
    );
  }
}
