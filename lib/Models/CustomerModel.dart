class CustomerModel {
  int? id;
  String? name;
  String? surname;
  String? phoneNumber;

  CustomerModel({this.id, this.name, this.surname, this.phoneNumber});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }

  // ID, isim, soyisim ve numarayı formatlayarak döndüren fonksiyon
  String toFormattedString() {
    return "${id ?? ''} - ${name ?? ''} ${surname ?? ''} - ${phoneNumber ?? ''}";
  }


}
