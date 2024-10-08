import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zeytin_app_v2/AppConst.dart';
import 'package:zeytin_app_v2/Models/CustomerModel.dart';
class
 Utils {
  /// XFile'dan dosya yolunu `String` olarak döndüren fonksiyon
  String _xFileToString(XFile? file) {
    if(file==null){
      return "null";
    }else{
      return file.path;
    }


  }

  /// String'den tekrar `XFile` oluşturan fonksiyon
  XFile _stringToXFile(String filePath) {
    return XFile(filePath);
  }

  /// TextEditingController ve müşteri listesi kullanarak Dropdown içeren bir padding oluşturma fonksiyonu
  Container _buildPadding({
    required TextEditingController textEditingController,
    required BuildContext context,
    required double mqWidth,
    String? selectedCustomer,
    required List<CustomerModel> customerList,
    required Function(String?) onChangedCallback,
  }) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 65,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selectedCustomer != null
              ? AppConst().blueRomance
              : Colors.grey.shade300,
          width: selectedCustomer != null ? 3 : 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField2<String>(
          dropdownStyleData: DropdownStyleData(
            width: width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.transparent,
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              selectedCustomer != null
                  ? Icons.keyboard_arrow_up_outlined
                  : Icons.keyboard_arrow_down_outlined,
            ),
          ),
          isExpanded: true,
          hint: Text("Cari Kart Seçin"),
          items: customerList
              .map((item) => DropdownMenuItem(
            value: item.toFormattedString(),
            child: Text(
              item.toFormattedString(),
            ),
          ))
              .toList(),
          value: selectedCustomer,
          onChanged: (String? newCustomer) {
            onChangedCallback(newCustomer);
          },
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: textEditingController,
            searchInnerWidgetHeight: 0,
            searchInnerWidget: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          width: 1.5, color: AppConst().blueRomance)),
                  isDense: true,
                  hintText: 'Search for an item...',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          width: 1.5, color: AppConst().disableColor)),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return item.value.toString().contains(searchValue);
            },
          ),
          onMenuStateChange: (isOpen) {

              textEditingController.clear();

          },
        ),
      ),
    );
  }

  TextField _buildTextField({
    required TextInputType textInputType,
    required double width,
    required String title,
    required TextEditingController controller,
    List<TextInputFormatter>? textInputFormatterList
  }) {
    OutlineInputBorder _enableDecoration = OutlineInputBorder(
      borderSide: BorderSide(width: 3, color: AppConst().blueRomance),
      borderRadius: BorderRadius.circular(16),
    );
    BoxDecoration _enableBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(16),
    );

    OutlineInputBorder _disableDecoration = OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: AppConst().disableColor),
      borderRadius: BorderRadius.circular(16),
    );
    BoxDecoration _disableBoxDecoration = BoxDecoration(border: Border.all(width: 1, color: AppConst().disableColor),
      borderRadius: BorderRadius.circular(16),
    );
    return TextField(
      style: TextStyle(fontWeight: FontWeight.w600),
      keyboardType: textInputType,
      controller: controller,
      inputFormatters: textInputFormatterList,
      decoration: InputDecoration(
        hintText: title,
        focusedBorder: _enableDecoration,
        enabledBorder:
        controller.text != "" ? _enableDecoration : _disableDecoration,
      ),
    );
  }

  Padding _buildDropdown({
    required double width,
    required String? selectedValue,
    required List<String> itemList,
    required String hintText,
    required Function(String?) onChangedCallback,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: selectedValue != null
                  ? AppConst().blueRomance
                  : AppConst().disableColor,
              width: selectedValue != null ? 3 : 1),
        ),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              borderRadius: BorderRadius.circular(16),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
              hint: Text(hintText),
              value: selectedValue,
              icon: Icon(
                selectedValue != null
                    ? Icons.keyboard_arrow_up_outlined
                    : Icons.keyboard_arrow_down_outlined,
              ),
              items: itemList.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                onChangedCallback(newValue);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomCheckBox({
    required double width,
    required String title,
    required ValueChanged<void> onChanged,
    required bool value,
  }) {
    return Container(
      height: 65,
      width: width / 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: value != false
                ? AppConst().blueRomance
                : AppConst().disableColor,
            width: value != false ? 3 : 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppConst().blueRomance,
            focusColor: AppConst().blueRomance,
            hoverColor: AppConst().blueRomance,
            checkColor: Colors.black,
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                return Colors.white.withOpacity(1);
              },
            ),
          ),
          Text(title),
        ],
      ),
    );
  }

  /// Getter Methods
  String Function(XFile?) get getXFileToString => _xFileToString;
  XFile Function(String) get getStringToXFile => _stringToXFile;
  Container Function({
  required TextEditingController textEditingController,
  required BuildContext context,
  required double mqWidth,
  String? selectedCustomer,
  required List<CustomerModel> customerList,
  required Function(String?) onChangedCallback,
  }) get getBuildSearchDropDown => _buildPadding;

  TextField Function({
  required TextInputType textInputType,
  required double width,
  required String title,
  required TextEditingController controller,
  List<TextInputFormatter>? textInputFormatterList
  }) get getBuildTextField => _buildTextField;

  Padding Function({
  required double width,
  required String? selectedValue,
  required List<String> itemList,
  required String hintText,
  required Function(String?) onChangedCallback,
  }) get getBuildDropdown => _buildDropdown;

  Widget Function({
  required double width,
  required String title,
  required ValueChanged<void> onChanged,
  required bool value,
  }) get getBuildCustomCheckBox => _buildCustomCheckBox;




  /// Ay sırasını harf olarak döndüren fonksiyon
  String _aySirasiHarfOlarak(int ay) {
    // Alfabeyi içeren bir liste oluşturuyoruz
    const List<String> alfabe = [
      'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'
    ];

    // Eğer girilen ay 1 ile 12 arasında değilse hata mesajı döner
    if (ay < 1 || ay > 12) {
      return "Geçersiz Ay Numarası";
    }

    // İlgili harfi bulup döndürüyoruz
    return alfabe[ay - 1];
  }
  String Function(int) get getAySirasiHarfOlarak => _aySirasiHarfOlarak;


  /// Image Picker ve Image File tanımları
  final ImagePicker imagePicker = ImagePicker();
  XFile? imageFile;

  /// Buton yapıcı fonksiyon
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

  // Formatlanmış bir stringi modele dönüştüren fonksiyon
  CustomerModel fromFormattedString(String formattedString) {
    try {
      // Düzenli ifade ile "id - isim soyisim - telefonNumarası" kalıbını ayırıyoruz
      final regex = RegExp(r'^(\d+) - (.+) - (\+?\d+)$');
      final match = regex.firstMatch(formattedString);

      if (match != null) {
        int? id = int.tryParse(match.group(1) ?? '');
        String fullName = match.group(2) ?? '';
        String? phoneNumber = match.group(3);

        // Soyadı ayırmak için son kelimeyi alıyoruz
        List<String> nameParts = fullName.split(' ');
        String? surname = nameParts.isNotEmpty ? nameParts.removeLast() : null;
        String? name = nameParts.join(' ');

        return CustomerModel(
          id: id,
          name: name,
          surname: surname,
          phoneNumber: phoneNumber,
        );
      }
    } catch (e) {
      print('Parsing error: $e');
    }

    return CustomerModel();
  }


  /// Getter Metodu
  GestureDetector Function(double,void Function(),) get getBuildChoosingPictureButton =>
      _buildChoosingPictureButton;




}

