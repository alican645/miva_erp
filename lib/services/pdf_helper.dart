import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:zeytin_app_v2/Models/SalesModel.dart';

// SalesModel sınıfını içe aktardık
 // SalesModel sınıfının olduğu dosyayı ekleyin

class PdfHelper {
  // SalesModel nesnesini tutan değişken
  final SalesModel salesModel;
  final String fontPath;
  final bool showPdf;

  // Yapıcı metod (Constructor)
  PdfHelper({
    required this.fontPath,
    required this.salesModel,
    required this.showPdf,
  });

  // PDF oluşturma fonksiyonu
  Future<File?> createPdf() async {
    // 1. PDF Belgesi oluşturun
    final pdf = pw.Document();

    // 2. Yazı tipini rootBundle ile yükleyin
    final ByteData fontData = await rootBundle.load(fontPath);
    final ttf = pw.Font.ttf(fontData);

    // 3. Sayfa ekleyin
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(82 * PdfPageFormat.cm, 100 * PdfPageFormat.cm),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Padding(
              padding: pw.EdgeInsets.all(100),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Müşteri: ${salesModel.musteri ?? 'Belirtilmemiş'}",
                      style: pw.TextStyle(font: ttf, fontSize: 40)),
                  pw.Text("Müşteri ID: ${salesModel.customerid ?? 'Belirtilmemiş'}",
                      style: pw.TextStyle(font: ttf, fontSize: 40)),
                  pw.Divider(thickness: 10),
                  pw.Text("Kg: ${salesModel.kg ?? 'Belirtilmemiş'}",
                      style: pw.TextStyle(font: ttf, fontSize: 40)),
                  pw.Text("Açıklama: ${salesModel.aciklama?.isEmpty ?? true ? 'Yok' : salesModel.aciklama}",
                      style: pw.TextStyle(font: ttf, fontSize: 40)),
                  pw.Text("Zeytin Türü: ${salesModel.zeytin_turu ?? 'Belirtilmemiş'}",
                      style: pw.TextStyle(font: ttf, fontSize: 40)),
                  pw.Text("Tek Çekim: ${salesModel.tek == 1 ? 'Evet' : 'Hayır'}",
                      style: pw.TextStyle(font: ttf, fontSize: 40)),
                  pw.Text("Dip: ${salesModel.dip == 1 ? 'Evet' : 'Hayır'}",
                      style: pw.TextStyle(font: ttf, fontSize: 40)),
                  pw.Text(
                      "Palet No: ${salesModel.palet == null || salesModel.palet!.isEmpty ? 'Yok' : salesModel.palet}",
                      style: pw.TextStyle(font: ttf, fontSize: 40)),
                  pw.Text(
                      "Ambalaj Açıklaması: ${salesModel.ambalaj == null || salesModel.ambalaj!.isEmpty ? 'Yok' : salesModel.ambalaj}",
                      style: pw.TextStyle(font: ttf, fontSize: 40)),
                  pw.Text("Fiş Kesim Tarihi: ${salesModel.tarih ?? 'Belirtilmemiş'}",
                      style: pw.TextStyle(font: ttf, fontSize: 40)),
                  pw.Text("Fiş Kesim Numarası: ${salesModel.no ?? 'Belirtilmemiş'}",
                      style: pw.TextStyle(font: ttf, fontSize: 40)),
                ],
              ),
            ),
          );
        },
      ),
    );

    // 4. PDF'yi kaydetmek veya göstermek
    return await _saveOrShowPdf(pdf, showPdf);
  }

  // PDF'yi dosyaya kaydet veya sadece göster
  Future<File?> _saveOrShowPdf(pw.Document pdf, bool show) async {
    if (!show) {
      // Geçici dizine kaydetme işlemi
      final directory = await getExternalStorageDirectory();
      final path = directory!.path;
      final file = File("$path/${DateTime.now().toString()}.pdf");

      // PDF dosyasını kaydet
      await file.writeAsBytes(await pdf.save());
      print("PDF dosyası başarıyla kaydedildi: ${file.path}");
      return file;
    } else {
      // Geçici dizine kaydetme ve sadece gösterme işlemi
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/example.pdf");
      await file.writeAsBytes(await pdf.save());
      return file;
    }
  }
}
