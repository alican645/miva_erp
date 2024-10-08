import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeytin_app_v2/AppConst.dart';
import 'package:zeytin_app_v2/services/database_helper.dart';
import 'package:zeytin_app_v2/views/customer_add/customer_add_viewmodel.dart';

import '../../Models/CustomerModel.dart';

class CustomerAddView extends StatefulWidget {
  const CustomerAddView({super.key});

  @override
  State<CustomerAddView> createState() => _CustomerAddViewState();
}

class _CustomerAddViewState extends State<CustomerAddView> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerSurname = TextEditingController();
  TextEditingController controllerPhoneNumber = TextEditingController();

  DataBaseHelper dbHelper = DataBaseHelper();

  @override
  void dispose() {
    controllerName.dispose();
    controllerSurname.dispose();
    controllerPhoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cari Kart Ekle"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTextField(
            textInputType: TextInputType.text,
              title: "İsim", controller: controllerName, width: width * 0.05),
          const SizedBox(
            height: 10,
          ),
          _buildTextField(
            textInputType: TextInputType.text,
              title: "Soyisim",
              controller: controllerSurname,
              width: width * 0.05),
          const SizedBox(
            height: 10,
          ),
          _buildTextField(
            textInputType: TextInputType.number,
              title: "Telefon Numarası",
              controller: controllerPhoneNumber,
              width: width * 0.05),
          const SizedBox(
            height: 10,
          ),
          Consumer<CustomerAddViewModel>(builder: (context, value, child) => GestureDetector(
                onTap: () async {
                  String _name = controllerName.text.toString();
                  String _surName = controllerSurname.text.toString();
                  String _phoneNumber = controllerPhoneNumber.text.toString();
                  if (_phoneNumber != ""  && _surName != "" && _name != "") {
                   value.insertCustomerModel(CustomerModel(
                       name: _name,
                       surname: _surName,
                       phoneNumber: _phoneNumber));
                    Navigator.pop(context);
                  }else{
                    showDialog(context: context, builder:(context) => const AlertDialog(
                      title: Text("Hata"),
                      content: Text("Lütfen tamamını doldurduğunuzdan emin olun."),
                    ),);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: AppConst().blueRomance,
                      borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.1, vertical: width * 0.05),
                  child: const Text("Müşteriyi Ekle"),
                )),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Padding _buildTextField(
      {
        required TextInputType textInputType,
        required String title,
      required TextEditingController controller,
      required double width}) {
    OutlineInputBorder _enableDecoration = OutlineInputBorder(
        borderSide: BorderSide(width: 3, color: AppConst().blueRomance),
        borderRadius: BorderRadius.circular(16));
    OutlineInputBorder _disableDecoration = OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: AppConst().disableColor),
      borderRadius: BorderRadius.circular(16),
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width),
      child: TextField(
        keyboardType: textInputType,
        onTap: () {
          setState(() {});
        },
        controller: controller,
        decoration: InputDecoration(
            hintText: title,
            focusedBorder: _enableDecoration,
            enabledBorder:
                controller.text != "" ? _enableDecoration : _disableDecoration),
      ),
    );
  }
}
