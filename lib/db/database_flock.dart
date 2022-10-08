import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rastreabilidade_pec_corte_app/model/rebanho.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference _mainCollection = _firestore.collection('rebanho');

class DatabaseFlock {
  static String? userUid;
  /*
  String? description; // descrição
  String? maximumAmount; // quantidade máxima
  String? farm; //fazenda
  String? herdDate; //data rebanho
   */

  static Future<void> addItem(
      {required String description,
      required String maximumAmount,
      required String farm,
      required String herdDate,
      bool? status}) async {
    DocumentReference documentReferencer = _mainCollection.doc(userUid);

    Map<String, dynamic> data = <String, dynamic>{
      'description': description,
      'maximumAmount': maximumAmount,
      'farm': farm,
      'herdDate': herdDate,
      'status': status,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("dados registrado com sucesso "))
        .catchError((e) => print(e));
  }

  static Future<String> updateItem(
      {required String id,
      required String description,
      required String maximumAmount,
      required String farm,
      required String herdDate,
      bool? status}) async {
    DocumentReference documentReferencer = _mainCollection.doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      'description': description,
      'maximumAmount': maximumAmount,
      'farm': farm,
      'herdDate': herdDate,
      'status': status,
    };
    var value = await documentReferencer
        .update(data)
        .whenComplete(() => print('Dados alterados com sucesso!!'))
        .catchError((e) => print(e));

    return Future.value('done');
  }

  static readItemsN() {
    _firestore.collection("rebanho").get().then(
          (res) => print('Successfully completed ${res.docs.last.id}'),
          onError: (e) => print("Error completing: $e"),
        );
  }

  static Future<List<Flock>> readItems() async {
    try {
      List<Flock> result = [];
      QuerySnapshot querySnapshot =
          await _firestore.collection('animal').get().then((value) => value);
      var i = 0;
      querySnapshot.docs.forEach((doc) {
        result.add(Flock(doc.id, doc['description'], doc['maximumAmount'],
            doc['farm'], doc['herdDate'], doc["status"]));
        //print(result[i].descricao);
        i++;
      });

      return result;
    } catch (error) {
      return [];
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> ListFlock() {
    return _firestore.collection('rebanho').snapshots();
  }

  static Future<Flock> find(String id) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('rebanho').get().then((value) => value);
    var result = querySnapshot.docs.where((element) => element.id == id);
    result.first.data();
    Flock retorn = Flock(
        result.first.id,
        result.first['description'],
        result.first['maximumAmount'],
        result.first['farm'],
        result.first['herdDate'],
        result.first["status"]);
    return retorn;
  }
}
