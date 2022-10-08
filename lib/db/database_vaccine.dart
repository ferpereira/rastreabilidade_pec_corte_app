import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rastreabilidade_pec_corte_app/model/vacina.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference _mainCollection = _firestore.collection('vacina');

class DatabaseVaccine {
  static String? userUid;
  /*
   String  id = '';
  String? description; // descrição
  String? dateFabrication; // data Fabricação
  String? dateValidity; // data de validade
  String? laboratory; // procedimento
  bool? status = true ;
   */

  static Future<String> addItem(
      {required String description,
      required String dateFabrication,
      required String dateValidity,
      required String laboratory,
      bool? status}) async {
    DocumentReference documentReferencer = _mainCollection.doc(userUid);

    Map<String, dynamic> data = <String, dynamic>{
      'description': description,
      'dateFabrication': dateFabrication,
      'dateValidity': dateValidity,
      'laboratory': laboratory,
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
      required String dateFabrication,
      required String dateValidity,
      required String laboratory,
      bool? status}) async {
    DocumentReference documentReferencer = _mainCollection.doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      'description': description,
      'dateFabrication': dateFabrication,
      'dateValidity': dateValidity,
      'laboratory': laboratory,
      'status': status,
    };

    var value = await documentReferencer
        .update(data)
        .whenComplete(() => print('Dados alterados com sucesso!!'))
        .catchError((e) => print(e));

    return Future.value('done');
  }

  static readItemsN() {
    _firestore.collection("vacina").get().then(
          (res) => print('Successfully completed ${res.docs.last.id}'),
          onError: (e) => print("Error completing: $e"),
        );
  }

  static Future<List<Vaccine>> readItems() async {
    try {
      List<Vaccine> result = [];
      QuerySnapshot querySnapshot =
          await _firestore.collection('vacina').get().then((value) => value);
      var i = 0;
      querySnapshot.docs.forEach((doc) {
        result.add(Vaccine(doc.id, doc['description'], doc['dateFabrication'],
            doc['dateValidity'], doc['laboratory'], doc["status"]));
        //print(result[i].descricao);
        i++;
      });

      return result;
    } catch (error) {
      return [];
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> ListFlock() {
    return _firestore.collection('vacina').snapshots();
  }

  static Future<Vaccine> find(String id) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('vacina').get().then((value) => value);
    var result = querySnapshot.docs.where((element) => element.id == id);
    result.first.data();
    Vaccine retorn = Vaccine(
        result.first.id,
        result.first['description'],
        result.first['dateFabrication'],
        result.first['dateValidity'],
        result.first['laboratory'],
        result.first["status"]);
    return retorn;
  }
}
