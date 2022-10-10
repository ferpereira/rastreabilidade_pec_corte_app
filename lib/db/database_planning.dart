import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rastreabilidade_pec_corte_app/model/planejamento.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference _mainCollection =
    _firestore.collection('planejamento');

class DatabasePlanning {
  static String? userUid;
  /*
    id = '';
  description; // descrição
  dateBegin; // dataInicio
  dateEnd; // dataFim
  idFlock = []; // lista de rebanhos
  procedure; // precedimento
  registerProcedure = []; //lista de registro
  bool? status = true ;
   */

  static Future<String> addItem(
      {required String description,
      required String dateBegin,
      required String dateEnd,
      required String idFlock,
      required String procedure,
      bool? status}) async {
    DocumentReference documentReferencer = _mainCollection.doc(userUid);

    Map<String, dynamic> data = <String, dynamic>{
      'description': description,
      'dateBegin': dateBegin,
      'dateEnd': dateEnd,
      'idFlock': idFlock,
      'procedure': procedure,
      'status': status,
    };

    var value = await documentReferencer
        .set(data)
        .whenComplete(() => print('Dados alterados com sucesso!!'))
        .catchError((e) => print(e));

    return Future.value('done');
  }

  static Future<String> updateItem(
      {required String id,
      required String description,
      required String dateBegin,
      required String dateEnd,
      required String idFlock,
      required String procedure,
      bool? status}) async {
    DocumentReference documentReferencer = _mainCollection.doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      'description': description,
      'dateBegin': dateBegin,
      'dateEnd': dateEnd,
      'idFlock': idFlock,
      'procedure': procedure,
      'status': status,
    };

    var value = await documentReferencer
        .update(data)
        .whenComplete(() => print('Dados alterados com sucesso!!'))
        .catchError((e) => print(e));

    return Future.value('done');
  }

  static readItemsN() {
    _firestore.collection('planejamento').get().then(
          (res) => print('Successfully completed ${res.docs.last.id}'),
          onError: (e) => print("Error completing: $e"),
        );
  }

  static Future<List<Planning>> readItems() async {
    try {
      List<Planning> result = [];
      QuerySnapshot querySnapshot = await _firestore
          .collection('planejamento')
          .get()
          .then((value) => value);
      var i = 0;
      querySnapshot.docs.forEach((doc) {
        result.add(Planning(doc.id, doc['description'], doc['dateBegin'],
            doc['dateEnd'], doc['idFlock'], doc['procedure'], doc["status"]));
        //print(result[i].description);
        i++;
      });

      return result;
    } catch (error) {
      return [];
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> ListFlock() {
    return _firestore.collection('planejamento').snapshots();
  }

  static Future<Planning> find(String id) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('planejamento')
        .get()
        .then((value) => value);
    var result = querySnapshot.docs.where((element) => element.id == id);
    result.first.data();
    Planning retorn = Planning(
        result.first.id,
        result.first['description'],
        result.first['dateBegin'],
        result.first['dateEnd'],
        result.first['idFlock'],
        result.first['procedure'],
        result.first["status"]);
    print(retorn.description);
    return retorn;
  }
}