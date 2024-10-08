class SalesModel {
  int? id;
  String? kg;
  int? tek;
  int? dip;
  String? zeytin_turu;
  String? musteri;
  String? aciklama;
  String? ambalaj;
  String? image_path;
  String? tarih;
  String? no;
  String? palet;
  int?  customerid;

  SalesModel(
      {this.id,
      this.kg,
      this.tek,
      this.dip,
      this.zeytin_turu,
      this.musteri,
      this.aciklama,
      this.ambalaj,
      this.image_path,
      this.tarih,
      this.no,
      this.palet,
      this.customerid,
      });

  SalesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kg = json['kg'];
    tek = json['tek'];
    dip = json['dip'];
    zeytin_turu = json['zeytin_turu'];
    musteri = json['musteri'];
    aciklama = json['aciklama'];
    ambalaj = json['ambalaj'];
    image_path = json['image_path'];
    tarih = json['tarih'];
    no = json['no'];
    palet = json['palet'];
    customerid = json['customerid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['kg'] = this.kg;
    data['tek'] = this.tek;
    data['dip'] = this.dip;
    data['zeytin_turu'] = this.zeytin_turu;
    data['musteri'] = this.musteri;
    data['aciklama'] = this.aciklama;
    data['ambalaj'] = this.ambalaj;
    data['image_path'] = this.image_path;
    data['tarih'] = this.tarih;
    data['no'] = this.no;
    data['palet'] = this.palet;
    data['customerid'] = this.customerid;
    return data;
  }
}
