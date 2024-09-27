


import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:zeytin_app_v2/Models/SalesModel.dart';

import 'Models/CustomerModel.dart';


class DataBaseHelper{
  Database? _database;


  Future<Database> openDb() async{
    //eğer uygulama lk açıldığında elimizde bir database yoksa
    //bir database oluşturup onu açtığımız blok

    //openDatabase(path,version:,onCreate: )>> SQLite veritabanını açmak
    //ve kullanıma hazır hale getirmek için kullanılır
    //
    // path: Veritabanının fiziksel olarak saklanacağı dosya yolunu belirtir.
    // version: Veritabanı şemasının versiyonunu belirtir. Bu, veritabanı şemasında değişiklik yaptığınızda kullanışlıdır.
    // onConfigure: Veritabanı yapılandırılmadan önce çalışacak bir fonksiyonu belirtir.
    //
    // onCreate: Veritabanı oluşturulduğunda çalışacak bir fonksiyonu belirtir.>>
    //oluşturulmuş bir veri tabanı yoksa oluşturan fonksiyon olarak da açıklayabiliriz.
    //
    // onUpgrade ve onDowngrade: Veritabanı sürümü yükseltildiğinde veya düşürüldüğünde çalışacak fonksiyonları belirtir.
    // onOpen: Veritabanı açıldığında çalışacak bir fonksiyonu belirtir.

    if(_database==null){
      return await openDatabase(await join(await getDatabasesPath().toString()),version: 1,onCreate: (db, version) async{
        //veri tabanı oluşturan ve oluşturulan veritabanına bir tablo ekleyen kod satırı
        await db.execute("create table customers(id integer primary key,name text,surname text,phoneNumber text)");
        await db.execute("create table sales(id integer primary key,kg text,tek int,dip int,zeytin_turu text,musteri text,aciklama text,ambalaj text,image_path text,tarih text,no text)");

      },) ;
    }
    return _database!;
  }



  //veri tabanına eklenen  tüm ögeleri bir liste olarak döndüren fonksiyon
  Future<List> getCustomerMap() async{
    Database db=await openDb();
    var result=await db.query("customers");
    return result;
  }
//yukarıdaki fonksiyonun çıktısı aşağıdaki gibi olur yani liste içerisinde
//map yapıları döndürür.
  // [
  // {'id': 1, 'name': 'John', 'surname': 'Doe', 'studentNumber': '12345'},
  // {'id': 2, 'name': 'Jane', 'surname': 'Smith', 'studentNumber': '67890'},
  // ]

// eğer döndürülen liste içerisinde map yapıları değil de Student sınıfından olan nesnelerin
// olmasını istiyorsak  bu fonksiyon aşağıdaki sekilde yazılır.


  //database içerisine eklenen map şeklindeki student modellerini Student nesnesine
  //çevirerek bir listeye ekleyen ve bu listeyi döndüren fonskiyon komutu
  Future<List<CustomerModel>> getCustomer() async{
    List<CustomerModel>? customers=[];
    Database db=await openDb();

    //database içerisindeki map şeklindeki srudent modellirini liste olarak çağıran datır
    var result=await db.query("customers");
    // bu listenin çıktısı aşağıdaki şekildedir.
    // [{'id': 1, 'name': 'John', 'surname': 'Doe', 'studentNumber': '12345'},
    // {'id': 2, 'name': 'Jane', 'surname': 'Smith', 'studentNumber': '67890'},]

    // Liste içerisindeki her bir student map modelini Student nesnesine çeviren kod bloğu
    for(int count=0;count<result.length;count++){
      customers.add(CustomerModel.fromJson(result[count]));
    }
    return  customers;
  }

  Future<List<SalesModel>> getSales() async{
    List<SalesModel>? sales=[];
    Database db=await openDb();

    //database içerisindeki map şeklindeki srudent modellirini liste olarak çağıran datır
    var result=await db.query("sales");
    // bu listenin çıktısı aşağıdaki şekildedir.
    // [{'id': 1, 'name': 'John', 'surname': 'Doe', 'studentNumber': '12345'},
    // {'id': 2, 'name': 'Jane', 'surname': 'Smith', 'studentNumber': '67890'},]

    // Liste içerisindeki her bir student map modelini Student nesnesine çeviren kod bloğu
    for(int count=0;count<result.length;count++){
      sales.add(SalesModel.fromJson(result[count]));
    }
    return  sales;
  }


/*
*insert fonksiyonlarında neden map yaıpısı isteniyor.
*Map yapısı ile Tablo Arasındaki Bağlantı
*Tablo oluşturan girdi>>CREATE TABLE student(id INTEGER PRIMARY KEY,age INTEGER,name TEXT,surName TEXT "
*                                            *                       *            *        *
*                                            *                       *            *        *
*                                            *                       *            *        *
*                                            *                       *            *        *
*
*                                            *                       *            *        *
*                                            *                       *            *        *
*                                            *                       *            *        *
*                                            *                       *            *        *
*                                            *                       *            *        *
*                                            *                       *            *        *
*                                            *                       *            *        *
*                                            *                       *            *        *
*                                            *                       *            *        ****>>map yapsındaki "surName" key ifadesi = tabloda oluşturulan "surName" kolon
*                                            *                       *            ****>>map yapsındaki "name" key ifadesi = tabloda oluşturulan "name" kolon
*                                            *                       ****>>map yapsındaki "age" key ifadesi = tabloda oluşturulan "age" kolon
*                                            ****>>map yapsındaki "id" key ifadesi = tabloda oluşturulan "id" kolon
*
* map yapısı {
* "id":"valueID"
* "age":"valueAge"
* "name":"valueName
* "surName":"valueSurname"
*
* }
*
*
*
*/

// add ve delete işlemleri sql fonskiyonlarını yerine getirsede integer bir değer döndürürler
// bu değer bir ise işlem gerçekleşti sıfır ise işlem gerçekleşmedi olarak kabul edilir.

  // Future<int> yazılan programa göre değişebilir eğer istenen sonuçlara göre bir durum olucaksa örneğin bir ya da sıfır durumu gibi int olarak kullanılabilir.
  // Ama bu durum önemsenmiyorsa Future<void> şeklinde de kullanılabilir.
  //////////////////////////////////////////////////////////////////////////////
  Future<int> insertCustomer(CustomerModel customerModel) async{
    Database db= await openDb();

    //istenilen Student nesnesini map formatına dönüştürür ve db ye ekler
    var result=await db.insert("customers", customerModel.toJson());
    return result;
  }
  /****************************************************************************/
  Future<int> insertSale(SalesModel salesModel) async{
    Database db= await openDb();

    //istenilen Student nesnesini map formatına dönüştürür ve db ye ekler
    var result=await db.insert("sales", salesModel.toJson());
    return result;
  }
 ///////////////////////////////////////////////////////////////////////////////
  Future<int> deleteCustomer(int id) async{
    Database db=await openDb();
    var result=db.rawDelete("delete from customers where id=$id");
    return result;
  }


  // update işlemi aslında bir bakıma insert işlemine benzer where ile
  // hangi sütun değerine göre update işlemi yapılacağı belirlenir
  // örneğin where="id=?" yazıldı ise id sütunu için gerilen değere göre işlem yapılır.
  // whereArgs ile hangi satır da update işlemi yapılacağı belirlenir.
  //whereArgs=3 ise id'nin 3 olduğu satırda update işlemi yapılır .
  Future<int> updateCustomers(CustomerModel customerModel) async{
    Database db= await openDb();
    var result= await db.update("customers", customerModel.toJson(),where:"id=?",whereArgs: [customerModel.id]);
    return result;
  }

  Future<int> updateSales(SalesModel salesModel) async{
    Database db= await openDb();
    var result= await db.update("sales", salesModel.toJson(),where:"id=?",whereArgs: [salesModel.id]);
    return result;
  }

  Future<SalesModel?> getSalesById(int id) async {
    // Veritabanını aç
    Database db = await openDb();

    // Veritabanından 'sales' tablosunda belirtilen id'yi sorgula
    List<Map<String, dynamic>> result = await db.query(
      "sales",
      where: "id = ?",
      whereArgs: [id],
    );

    // Eğer veri bulunursa, ilk sonucu SalesModel olarak döndür
    if (result.isNotEmpty) {
      return SalesModel.fromJson(result.first);
    }

    // Veri bulunmazsa null döndür
    return null;
  }





}