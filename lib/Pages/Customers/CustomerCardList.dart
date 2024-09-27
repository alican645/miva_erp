import 'package:flutter/material.dart';

import '../../AppConst.dart';
import '../../DataBaseHelper.dart';
import '../../Models/CustomerModel.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {



  List<String> list = [];
  DataBaseHelper dbHelper = DataBaseHelper();
  List<CustomerModel> customerList=[];



  @override
  void initState() {
    super.initState();
    _getCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cari Kart Listesi"),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(width: double.maxFinite,),
              ...List.generate(customerList.length, (index) => MusteriListItem(customerModel: customerList[index]))
            ],
          ),
        ),
      ),
    );
  }
  Container MusteriListItem({required CustomerModel customerModel}) {
    double width = MediaQuery.of(context).size.width;
    TextStyle _textStle = TextStyle(fontSize: 16);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(width * 0.02),
      width: width * 0.9,
      decoration: BoxDecoration(
        color: AppConst().blueRomance,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${customerModel.name} ${customerModel.surname}",
            style: _textStle.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(
            "Telefon Numarası:${customerModel.phoneNumber}",
            style: _textStle,
          ),


        ],
      ),
    );
  }

  void _getCustomers() async {
    var result = dbHelper.getCustomer();
    result.then((value) {
      //value değerini setstate ile beraber listeye aktarıyoruz ki widget tree tekrardan yapılandırılsın.
      setState(() {
        customerList = value;
      });
    });
  }
}
