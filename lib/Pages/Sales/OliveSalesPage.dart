import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeytin_app_v2/AppConst.dart';
import 'package:zeytin_app_v2/Models/SalesModel.dart';
import 'package:zeytin_app_v2/Pages/Customers/CustomerAddPage.dart';
import 'package:zeytin_app_v2/utlis/AppUtils.dart';
import '../../DataBaseHelper.dart';
import '../../Models/CustomerModel.dart';

class OliveSalesPage extends StatefulWidget {
  const OliveSalesPage({super.key});

  @override
  State<OliveSalesPage> createState() => _OliveSalesPageState();
}

class _OliveSalesPageState extends State<OliveSalesPage> {
  TextEditingController _kgTextController = TextEditingController();
  TextEditingController _aciklamaTextController = TextEditingController();
  TextEditingController _searchBarTextController = TextEditingController();
  TextEditingController _ambalajAciklamasiTextController =
      TextEditingController();


  bool _isPressed = false;
  bool _isTek = false;
  bool _isDip = false;
  bool _isAmbalaj = false;

  int? spMonth;
  int? fisSira;
  XFile? imageFile;
  final imagePicker = ImagePicker();

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

  FocusNode focusNode = FocusNode();

  DateTime currentDate = DateTime.now();

  @override
 void initState()  {
    _loadMonth();
   _getCustomers();
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildChoosingPictureButton(width,() async {
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
                          border: Border.all(color: AppConst().blueRomance)),
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
                    child: Utils().getBuildPadding(
                        context: context,
                        textEditingController: _searchBarTextController,
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
              child: Utils().getBuildTextField(
                textInputType: TextInputType.number,
                  width: width * 0.05,
                  title: "Kg",
                  controller: _kgTextController),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Utils().getBuildTextField(
                textInputType: TextInputType.text,
                  width: width * 0.05,
                  title: "Açıklama",
                  controller: _aciklamaTextController),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Utils().getBuildCustomCheckBox(
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
                  Utils().getBuildCustomCheckBox(
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
            SizedBox(height: 10),
            Utils().getBuildDropdown(
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
              child: Row(
                children: [
                  Utils().getBuildCustomCheckBox(
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
            SizedBox(height: 10),
            SizedBox(
              child: _isAmbalaj
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: Utils().getBuildTextField(
                        textInputType: TextInputType.text,
                          width: width * 0.05,
                          title: "Ambalaj Açıklaması",
                          controller: _ambalajAciklamasiTextController),
                    )
                  : Container(),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTapDown: (_)async {
                _updateOrder();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                fisSira=await prefs.getInt("fis_sira")??1;
                print("//////////////////////////////////////a");
                print(fisSira);
                print("//////////////////////////////////////a");

                setState(()  {
                  _isPressed = true;
                  String _kg = _kgTextController.text.toString();

                  String formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(currentDate);
                  if (_kg != "null" &&
                      _selectedCustomer != null &&imageFile!=null&&
                      _selectedZeytinTuru != null) {
                    String path=Utils().getXFileToString(imageFile!);
                    dbHelper.insertSale(SalesModel(
                      aciklama: _aciklamaTextController.text!=""?_aciklamaTextController.text.toString():null,
                        ambalaj: (_isAmbalaj&&_ambalajAciklamasiTextController.text!="")?_ambalajAciklamasiTextController.text.toString():null,
                        tek: _isTek?1:0,
                        kg: _kg,
                        dip: _isDip?1:0,
                        zeytin_turu: _selectedZeytinTuru,
                        musteri: "${_selectedCustomer}",
                    image_path: path,
                    tarih: formattedDate,
                      no: "${currentDate.year}${Utils().getAySirasiHarfOlarak(spMonth!)}${fisSira}"

                    ));

                    prefs.setInt("fis_sira",fisSira!+1);
                    print("//////////////////////////////////////b");
                    fisSira=prefs.getInt("fis_sira");
                    print(fisSira);
                    print("//////////////////////////////////////b");
                    Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Hata"),
                        content:
                            Text("Lütfen tamamını doldurduğunuzdan emin olun."),
                      ),
                    );
                  }
                });
              },
              onTapUp: (_) {
                setState(() {
                  _isPressed = false;
                });
              },
              onTapCancel: () {
                setState(() {
                  _isPressed = false;
                });
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
                    "Fiş Yazdır",
                  ))),
            ),
          ],
        ),
      ),
    );
  }



  ///ayı sp'den çeken fonksiyon
  Future<void> _loadMonth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    spMonth = prefs.getInt('month') ?? 9;
    print("////////////////////////////////////e");
    print(spMonth);
    print("////////////////////////////////////e");
  }

  /// ayı sp'e yükleyen fonksiyon
  void _updateOrder() async {
    print("_updateOrder");
    if(spMonth!=currentDate.month){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('month',currentDate.month);
      spMonth=prefs.getInt("month");
      prefs.setInt("fis_sira", 1);
    }
  }

  Future<void> _getCustomers() async {
    var result = dbHelper.getCustomer();
    result.then((value) {
      setState(() {
        customerList = value;
      });
    });
  }

  GestureDetector _buildChoosingPictureButton(double width,VoidCallback onPressed,  ) {

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
              padding: EdgeInsets.all(1),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(imageFile!.path),
                  fit: BoxFit.cover, // Resmi belirlenen alana sığdırmak için
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }




}
