import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rastreabilidade_pec_corte_app/model/registro_procedimento.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference _mainCollection =
    _firestore.collection('registro_procedimento');

class DatabaseRegisterProcedure {
  static String? userUid;
/*
 id = '';
 animalID; // idAnimal
 procedureID; // idProcedimento
 dateRegister; // dataRegistro
 */

  static Future<String> addItem(
      {required String animalID,
      required String procedureID,
      required String dateRegister}) async {
    DocumentReference documentReferencer = _mainCollection.doc(userUid);

    Map<String, dynamic> data = <String, dynamic>{
      'animalID': animalID,
      'procedureID': procedureID,
      'dateRegister': dateRegister,
    };

    var value = await documentReferencer
        .set(data)
        .whenComplete(() => print('Dados alterados com sucesso!!'))
        .catchError((e) => print(e));

    return Future.value('done');
  }

  static Future<String> updateItem(
      {required String id,
      required String animalID,
      required String procedureID,
      required String dateRegister}) async {
    DocumentReference documentReferencer = _mainCollection.doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      'animalID': animalID,
      'procedureID': procedureID,
      'dateRegister': dateRegister,
    };

    var value = await documentReferencer
        .update(data)
        .whenComplete(() => print('Dados alterados com sucesso!!'))
        .catchError((e) => print(e));

    return Future.value('done');
  }

  static readItemsN() {
    _firestore.collection('registro_procedimento').get().then(
          (res) => print('Successfully completed ${res.docs.last.id}'),
          onError: (e) => print("Error completing: $e"),
        );
  }

  static Future<List<RegisterProcedure>> readItems() async {
    try {
      List<RegisterProcedure> result = [];
      QuerySnapshot querySnapshot = await _firestore
          .collection('registro_procedimento')
          .get()
          .then((value) => value);
      var i = 0;
      querySnapshot.docs.forEach((doc) {
        result.add(RegisterProcedure(
            doc.id, doc['animalID'], doc['procedureID'], doc['dateRegister']));
        //print(result[i].animalID);
        i++;
      });

      return result;
    } catch (error) {
      return [];
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> ListFlock() {
    return _firestore.collection('registro_procedimento').snapshots();
  }

  static Future<RegisterProcedure> find(String id) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('registro_procedimento')
        .get()
        .then((value) => value);
    var result = querySnapshot.docs.where((element) => element.id == id);
    result.first.data();
    RegisterProcedure retorn = RegisterProcedure(
        result.first.id,
        result.first['animalID'],
        result.first['procedureID'],
        result.first['dateRegister']);
    return retorn;
  }
}
