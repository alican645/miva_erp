import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeytin_app_v2/app/locators/locator.dart';
import 'package:zeytin_app_v2/main.dart';
import 'package:zeytin_app_v2/services/database_helper.dart';
import 'package:zeytin_app_v2/views/customer_card_list/customer_card_list_viewmodel.dart';

import '../../AppConst.dart';

import '../../Models/CustomerModel.dart';

class CustomerCardListView extends StatefulWidget {
  const CustomerCardListView({super.key});

  @override
  State<CustomerCardListView> createState() => _CustomerCardListViewState();
}

class _CustomerCardListViewState extends State<CustomerCardListView> {
  List<CustomerModel> customerList = [];

  @override
  void initState() {
    context.read<CustomerCardListViewModel>().getCustomers();
    super.initState();
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
              SizedBox(
                width: double.maxFinite,
              ),
              Padding(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.05,
                ),
                child: Container(
                  height: 200,
                  child: Consumer<CustomerCardListViewModel>(builder: (context, value, child) => ListView.builder(
                      itemCount:value.customerList!.length,
                      itemBuilder: (context, index) =>
                          MusteriListItem(
                            customerModel:value.customerList![index] ,
                          ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container MusteriListItem({
    required CustomerModel customerModel,
  }) {
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
}
