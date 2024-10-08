import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeytin_app_v2/AppConst.dart';
import 'package:zeytin_app_v2/Models/SalesModel.dart';
import 'package:zeytin_app_v2/main.dart';
import 'package:zeytin_app_v2/services/database_helper.dart';
import 'package:zeytin_app_v2/services/pdf_helper.dart';
import 'package:zeytin_app_v2/views/customer_add/customer_add_view.dart';
import 'package:zeytin_app_v2/PdfViewer.dart';
import 'package:zeytin_app_v2/utlis/AppUtils.dart';
import 'package:zeytin_app_v2/views/olive_sales/olive_sales_viewmodel.dart';
import '../../Models/CustomerModel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class OliveSalesView extends StatefulWidget {
  const OliveSalesView({super.key});

  @override
  State<OliveSalesView> createState() => _OliveSalesViewState();
}

class _OliveSalesViewState extends State<OliveSalesView> {
  final TextEditingController _kgTextController = TextEditingController();
  final TextEditingController _aciklamaTextController = TextEditingController();
  final TextEditingController _searchBarTextController =
      TextEditingController();
  final TextEditingController _paletNoTextController = TextEditingController();
  final TextEditingController _ambalajAciklamasiTextController =
      TextEditingController();

  Utils utils = Utils();
  
  PdfHelper? pdfHelper;

  int? currentMonth;
  int? fisSira;
  XFile? imageFile;
  final imagePicker = ImagePicker();
  File? file;

  DataBaseHelper dbHelper = DataBaseHelper();
  List<CustomerModel> customerList = [];
  String? _selectedCustomer;

  final List<String> _itemListZeytinTuru = [
    "Gemlik",
    "Aydın",
    "Item 3 ",
    "Item 4 "
  ];
  String? _selectedZeytinTuru;

  ///seçilen string tipindeki _selectedCustomer değişkeni
  ///utils.fromFormattedString(formattedString) metodu ile customer modele
  ///dönüştürüldü ve id si alındı böylelikle hangi fişte hangi id olduğu anlaşılıyor
  CustomerModel? _selectedCustomerModel;

  DateTime currentDate = DateTime.now();

  bool _isPressed = false;
  bool _isTek = false;
  bool _isDip = false;
  bool _isAmbalaj = false;
  bool _isPalet = false;
  String? _kg;
  String? path;
  String fontPath="assets/fonts/open_sans.ttf";

  @override
  void initState() {
    //context.read<OliveSalesViewModel>().setMonth(currentDate.month);
    context.read<OliveSalesViewModel>().getMonth();
    context.read<OliveSalesViewModel>().getFisSira();
    context.read<OliveSalesViewModel>().getCustomers();
    context.read<OliveSalesViewModel>().getLastSalesIndex();
    // getLastInsertedSaleId=context.watch<OliveSalesViewModel>().lastSalesIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fiş Yazdır"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildChoosingPictureButton(width, () async {
              XFile? pickedFile =
                  await imagePicker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  imageFile = pickedFile;
                });
              } else {
                Fluttertoast.showToast(msg: 'No image selected.');
              }
            }),
            const SizedBox(
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
                          border: Border.all(color: AppConst().blueRomance)),
                      child: const Icon(Icons.add),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const CustomerAddView()), // Yeni sayfaya geçiş
                      ).then((value) {
                        context.read<OliveSalesViewModel>().getCustomers();
                      });
                    },
                  ),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  Expanded(
                    flex: 3,
                    child: utils.getBuildSearchDropDown(
                        context: context,
                        textEditingController: _searchBarTextController,
                        onChangedCallback: (p0) {
                          setState(() {
                            _selectedCustomer = p0;
                            _selectedCustomerModel =
                                utils.fromFormattedString(_selectedCustomer!);
                          });
                        },
                        mqWidth: width,
                        customerList:
                            context.watch<OliveSalesViewModel>().customerList!,
                        selectedCustomer: _selectedCustomer),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: utils.getBuildTextField(
                textInputType: TextInputType.number,
                width: width * 0.05,
                title: "Kg",
                controller: _kgTextController,
                textInputFormatterList: [
                  // Sadece sayılara ve "/" karakterine izin veren input formatter
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: utils.getBuildTextField(
                  textInputType: TextInputType.text,
                  width: width * 0.05,
                  title: "Açıklama",
                  controller: _aciklamaTextController),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  utils.getBuildCustomCheckBox(
                    title: "Tek Çekim",
                    width: width,
                    value: _isTek,
                    onChanged: (newValue) {
                      setState(() {
                        _isTek = !_isTek;
                      });
                    },
                  ),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  utils.getBuildCustomCheckBox(
                    title: "Dip",
                    width: width,
                    value: _isDip,
                    onChanged: (newValue) {
                      setState(() {
                        _isDip = !_isDip;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Row(
                children: [
                  utils.getBuildCustomCheckBox(
                      width: width,
                      title: "Palet No",
                      onChanged: (value) {
                        setState(() {
                          _isPalet = !_isPalet;
                        });
                      },
                      value: _isPalet),
                ],
              ),
            ),
            SizedBox(
              child: _isPalet
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: utils.getBuildTextField(
                          textInputFormatterList: [
                            // Sadece sayılara ve "/" karakterine izin veren input formatter
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9/]')),
                          ],
                          textInputType: TextInputType.text,
                          width: width * 0.05,
                          title: "Palet No",
                          controller: _paletNoTextController),
                    )
                  : Container(),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Row(
                children: [
                  utils.getBuildCustomCheckBox(
                      width: width,
                      title: "Amabalaj",
                      onChanged: (value) {
                        setState(() {
                          _isAmbalaj = !_isAmbalaj;
                        });
                      },
                      value: _isAmbalaj),
                ],
              ),
            ),
            SizedBox(
              child: _isAmbalaj
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: utils.getBuildTextField(
                          textInputType: TextInputType.text,
                          width: width * 0.05,
                          title: "Ambalaj Açıklaması",
                          controller: _ambalajAciklamasiTextController),
                    )
                  : Container(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Consumer<OliveSalesViewModel>(
                    builder: (context, value, child) => GestureDetector(
                      onTap: () async {
                        //_updateOrder();
                        currentMonth = value.month;
                        fisSira = value.fisSira;
                        if (currentMonth != currentDate.month) {
                          value.setMonth(currentDate.month);
                          value.setFisSira(1);
                        }
                        setState(() {
                          _isPressed = true;
                          _kg = _kgTextController.text.toString();
                          String formattedDate =
                              DateFormat('dd-MM-yyyy HH:mm:ss')
                                  .format(currentDate);
                          if (_kg != "null" &&
                              _kg != "" &&
                              _selectedCustomer != null &&
                              _selectedZeytinTuru != null) {
                            path = utils.getXFileToString(
                                imageFile == null ? null : imageFile!);
                            String formattedDate =
                            DateFormat('dd-MM-yyyy HH:mm:ss')
                                .format(currentDate);

                            SalesModel salesModel = SalesModel(
                                aciklama: _aciklamaTextController.text != ""
                                    ? _aciklamaTextController.text.toString()
                                    : null,
                                ambalaj: _isAmbalaj
                                    ? _ambalajAciklamasiTextController.text
                                    .toString() ==
                                    ""
                                    ? null
                                    : _ambalajAciklamasiTextController.text
                                    .toString()
                                    : null,
                                tek: _isTek ? 1 : 0,
                                kg: _kg,
                                dip: _isDip ? 1 : 0,
                                zeytin_turu: _selectedZeytinTuru,
                                musteri: _selectedCustomer,
                                image_path: path,
                                tarih: formattedDate,
                                no: "${currentDate.year}${utils.getAySirasiHarfOlarak(currentMonth!)}${fisSira}",
                                palet: _paletNoTextController.text,
                                customerid: _selectedCustomerModel!.id);

                            value.insertOliveSalesModel(salesModel);
                            value.setFisSira(fisSira! + 1);
                            
                            PdfHelper(fontPath:fontPath , salesModel: salesModel, showPdf: false).createPdf().then((value) {
                              file=value;
                            },);

                            Navigator.pop(context);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                title: Text("Hata"),
                                content: Text(
                                    "Lütfen tamamını doldurduğunuzdan emin olun."),
                              ),
                            );
                          }
                        });
                      },
                      child: Container(
                          height: 65,
                          decoration: BoxDecoration(
                            color: _isPressed == false
                                ? AppConst().fringyFlower
                                : AppConst().blueRomance.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(200),
                          ),
                          child: const Center(
                              child: Text(
                            "Fiş Yazdır",
                          ))),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Consumer<OliveSalesViewModel>(
                    builder: (context, value, child) => GestureDetector(
                      onTap: () async {
                        currentMonth = value.month;
                        fisSira = value.fisSira;
                        if (currentMonth != currentDate.month) {
                          value.setMonth(currentDate.month);
                          value.setFisSira(1);
                        }
                        setState(() {
                          _isPressed = true;
                          _kg = _kgTextController.text.toString();

                          String formattedDate =
                              DateFormat('dd-MM-yyyy HH:mm:ss')
                                  .format(currentDate);
                          if (_kg != "null" &&
                              _kg != "" &&
                              _selectedCustomer != null &&
                              _selectedZeytinTuru != null) {
                            SalesModel salesModel = SalesModel(
                                aciklama: _aciklamaTextController.text != ""
                                    ? _aciklamaTextController.text.toString()
                                    : null,
                                ambalaj: _isAmbalaj
                                    ? _ambalajAciklamasiTextController.text
                                    .toString() ==
                                    ""
                                    ? null
                                    : _ambalajAciklamasiTextController.text
                                    .toString()
                                    : null,
                                tek: _isTek ? 1 : 0,
                                kg: _kg,
                                dip: _isDip ? 1 : 0,
                                zeytin_turu: _selectedZeytinTuru,
                                musteri: _selectedCustomer,
                                image_path: path,
                                tarih: formattedDate,
                                no: "${currentDate.year}${utils.getAySirasiHarfOlarak(currentMonth!)}${fisSira}",
                                palet: _paletNoTextController.text,
                                customerid: _selectedCustomerModel!.id);
                            PdfHelper(fontPath:fontPath , salesModel: salesModel, showPdf: false).createPdf().then((value) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewer(file: value),));
                            },);

                            // createPdf(
                            //         value,
                            //         formattedDate,
                            //         "${currentDate.year}${utils.getAySirasiHarfOlarak(currentMonth!)}${fisSira}",
                            //         true)
                            //     .then((value) => Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) =>
                            //               PdfViewer(file: value),
                            //         )));
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                title: Text("Hata"),
                                content: Text(
                                    "Lütfen tamamını doldurduğunuzdan emin olun."),
                              ),
                            );
                          }
                        });
                      },
                      child: Container(
                        height: 65,
                        decoration: BoxDecoration(
                          color: _isPressed == false
                              ? AppConst().fringyFlower
                              : AppConst().blueRomance.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(200),
                        ),
                        child: const Center(
                          child: Text(
                            "Görüntüle",
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }


  GestureDetector _buildChoosingPictureButton(
    double width,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Container(
          height: 210,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: imageFile != null
                      ? AppConst().blueRomance
                      : AppConst().disableColor,
                  width: imageFile != null ? 3 : 1)),
          child: Center(
            child: imageFile == null
                ? Image.asset("assets/gallery-send.png")
                : Padding(
                    padding: const EdgeInsets.all(1),
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
    );
  }
}
