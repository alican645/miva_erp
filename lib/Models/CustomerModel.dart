

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

  // İsim, soyisim ve numarayı formatlayarak döndüren fonksiyon
  String toFormattedString() {
    return "${name ?? ''} ${surname ?? ''} - ${phoneNumber ?? ''}";
  }

  // Formatlanmış bir stringi modele dönüştüren fonksiyon
  static CustomerModel fromFormattedString(String formattedString) {
    try {
      // "isim soyisim - telefonNumarası" formatını parse ediyoruz
      List<String> parts = formattedString.split(' - ');
      if (parts.length == 2) {
        List<String> nameParts = parts[0].split(' ');
        String? phoneNumber = parts[1];

        String? name = nameParts.isNotEmpty ? nameParts[0] : null;
        String? surname = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : null;

        return CustomerModel(
          name: name,
          surname: surname,
          phoneNumber: phoneNumber,
        );
      }
    } catch (e) {
      // Hata durumunda boş bir model döndürüyoruz
      print('Parsing error: $e');
    }

    // Eğer format uygun değilse veya parse edilemezse boş bir model döndürülür
    return CustomerModel();
  }

}