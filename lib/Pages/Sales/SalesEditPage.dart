import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zeytin_app_v2/AppConst.dart';
import 'package:zeytin_app_v2/Models/SalesModel.dart';
import 'package:zeytin_app_v2/Pages/Customers/CustomerAddPage.dart';
import 'package:zeytin_app_v2/PdfViewer.dart';
import '../../DataBaseHelper.dart';
import '../../Models/CustomerModel.dart';
import '../../utlis/AppUtils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SalesEditPage extends StatefulWidget {
  final int? id;

  SalesEditPage({required this.id});

  @override
  State<SalesEditPage> createState() => _SalesEditPageState();
}

class _SalesEditPageState extends State<SalesEditPage> {
  Utils utils = Utils();

  TextEditingController? _kgTextController;
  TextEditingController? _aciklamaTextController;
  TextEditingController? _searchBarTextController;
  TextEditingController? _ambalajAciklamasiTextController;
  TextEditingController? _paletNoTextController;
  SalesModel? salesModel;

  bool _isPressed = false;
  bool? _isTek;
  bool? _isDip;

  String? _selectedCustomer;
  String? _no;
  String? _tarih;
  String? _palet;
  bool isLoading = true;

  int? spMonth;
  int? fisSira;
  XFile? imageFile;
  final imagePicker = ImagePicker();

  DataBaseHelper dbHelper = DataBaseHelper();
  List<CustomerModel> customerList = [];

  String? _imageFile;

  final List<String> _itemListZeytinTuru = [
    "Gemlik",
    "Aydın",
    "Item 3 ",
    "Item 4 "
  ];
  String? _selectedZeytinTuru;

  @override
  void initState() {
    _getCustomers();
    _getSalesModel(widget.id!).then((value) {
      setState(() {
        _kgTextController = TextEditingController(text: salesModel?.kg ?? '');
        _aciklamaTextController =
            TextEditingController(text: salesModel?.aciklama ?? '');
        _searchBarTextController =
            TextEditingController(text: salesModel?.musteri ?? '');
        _ambalajAciklamasiTextController =
            TextEditingController(text: salesModel?.ambalaj ?? '');
        _paletNoTextController =
            TextEditingController(text: salesModel?.palet ?? '');
        _selectedZeytinTuru = salesModel?.zeytin_turu;
        imageFile =
            utils.getStringToXFile(salesModel?.image_path.toString() ?? '');
        _isDip = salesModel?.dip == 1 ? true : false;
        _isTek = salesModel?.tek == 1 ? true : false;
        _imageFile = salesModel?.image_path.toString();
        _selectedCustomer = salesModel?.musteri;
        _tarih = salesModel?.tarih;
        _no = salesModel?.no!;
        isLoading = false; // Veriler yüklendiğinde isLoading = false yapıyoruz
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Fiş Yazdır"),
        centerTitle: true,
      ),
      body: isLoading // isLoading değişkenini kontrol ediyoruz
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Container(
                      height: 210,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: AppConst().blueRomance, width: 3)),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(1),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(imageFile!.path),
                              fit: BoxFit
                                  .cover, // Resmi belirlenen alana sığdırmak için
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Row(
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 65,
                            width: width * 0.2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    Border.all(color: AppConst().blueRomance)),
                            child: Icon(Icons.add),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CustomerAddPage()), // Yeni sayfaya geçiş
                            ).then((value) {
                              // Geri döndüğünde veriyi güncelle
                              _getCustomers();
                            });
                          },
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Expanded(
                          flex: 3,
                          child: utils.getBuildPadding(
                              context: context,
                              textEditingController: _searchBarTextController!,
                              onChangedCallback: (p0) {
                                setState(() {
                                  _selectedCustomer = p0;
                                });
                              },
                              mqWidth: width,
                              customerList: customerList,
                              selectedCustomer: _selectedCustomer),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: utils.getBuildTextField(
                      textInputType: TextInputType.text,
                      width: width * 0.05,
                      title: "Kg",
                      controller: _kgTextController!,
                      textInputFormatterList: [
                        // Sadece sayılara ve "/" karakterine izin veren input formatter
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: utils.getBuildTextField(
                        textInputType: TextInputType.text,
                        width: width * 0.05,
                        title: "Açıklama",
                        controller: _aciklamaTextController!),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        utils.getBuildCustomCheckBox(
                          title: "Tek Çekim",
                          width: width,
                          value: _isTek!,
                          onChanged: (newValue) {
                            setState(() {
                              _isTek = !_isTek!;
                            });
                          },
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        utils.getBuildCustomCheckBox(
                          title: "Dip",
                          width: width,
                          value: _isDip!,
                          onChanged: (newValue) {
                            setState(() {
                              _isDip = !_isDip!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  utils.getBuildDropdown(
                    width: width,
                    selectedValue: _selectedZeytinTuru,
                    itemList: _itemListZeytinTuru,
                    hintText: "Zeytin Turunu Seçiniz",
                    onChangedCallback: (p0) {
                      setState(() {
                        _selectedZeytinTuru = p0;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: utils.getBuildTextField(
                      textInputType: TextInputType.text,
                      width: width * 0.05,
                      title: "Palet No",
                      controller: _paletNoTextController!,
                      textInputFormatterList: [
                        // Sadece sayılara ve "/" karakterine izin veren input formatter
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: utils.getBuildTextField(
                        textInputType: TextInputType.text,
                        width: width * 0.05,
                        title: "Ambalaj Açıklaması",
                        controller: _ambalajAciklamasiTextController!),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      // updateSalesModel(widget.id!);
                      // Navigator.pop(context);
                      
                      createPdf().then((value) => Navigator.push(context,MaterialPageRoute(builder: (context) => PdfViewer(file: value),)));
                    },
                    child: Container(
                        width: width * 0.8,
                        height: 65,
                        decoration: BoxDecoration(
                          color: _isPressed == false
                              ? AppConst().fringyFlower
                              : AppConst().blueRomance.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(200),
                        ),
                        child: Center(
                            child: Text(
                          "Kaydet",
                        ))),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _getCustomers() async {
    var result = await dbHelper.getCustomer();
    setState(() {
      customerList = result;
    });
  }

  Future<void> _getSalesModel(int id) async {
    var result = await dbHelper.getSalesById(id);
    if (result != null) {
      salesModel = result;
    } else {
      Fluttertoast.showToast(msg: 'No sales data found.');
      Navigator.of(context).pop();
    }
  }
////data/user/0/com.example.zeytin_app_v2/cache/example.pdf
  Future<void> updateSalesModel(int id) async {
    dbHelper.updateSales(
      SalesModel(
        id: widget.id,
        image_path: _imageFile,
        aciklama: _aciklamaTextController!.text,
        ambalaj: _ambalajAciklamasiTextController!.text,
        tek: _isTek! ? 1 : 0,
        dip: _isDip! ? 1 : 0,
        zeytin_turu: _selectedZeytinTuru,
        kg: _kgTextController!.text,
        musteri: _selectedCustomer,
        no: _no,
        tarih: _tarih,
        palet: _paletNoTextController!.text,
      ),
    );
  }

  Future<File> createPdf() async {
    // 1. PDF Belgesi oluşturun
    final pdf = pw.Document();

    // 2. Yazı tipini rootBundle ile yükleyin
    final ByteData fontData = await rootBundle.load('assets/fonts/open_sans.ttf');
    final ttf = pw.Font.ttf(fontData);

    // 3. Sayfa ekleyin
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              "Hello World",
              style: pw.TextStyle(font: ttf, fontSize: 20),
            ),
          );
        },
      ),
    );

    // 4. Geçici dizine kaydedin
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/example.pdf");
    await file.writeAsBytes(await pdf.save());

    // 5. Dosya oluşturulduğunda konsola yazdırın
    print("PDF dosyası başarıyla kaydedildi: ${file.path}");

    return file;
  }
}
