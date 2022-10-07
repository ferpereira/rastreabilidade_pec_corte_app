import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rastreabilidade_pec_corte_app/model/animal.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference _mainCollection = _firestore.collection('animal');

class Database {
  static String? userUid;

  static Future<void> addItem({
    required String description,
    required String sisbovEarring,
    required String birthDate,
    required String flock,
    required String breed,
    required String leatherColor,
    required String sex,
    required String slaughterRecord,
    bool? status
  }) async {
    DocumentReference documentReferencer = _mainCollection.doc(userUid);

    Map<String, dynamic> data = <String, dynamic>{
      'description': description,
      'sisbovEarring': sisbovEarring,
      'birthDate': birthDate,
      'flock': flock,
      'breed': breed,
      'leatherColor': leatherColor,
      'sex': sex,
      'slaughterRecord': slaughterRecord,
      'status':status,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("dados registrado com sucesso "))
        .catchError((e) => print(e));
  }

  static Future<String> updateItem({
    required String id,
    required String description,
    required String sisbovEarring,
    required String birthDate,
    required String flock,
    required String breed,
    required String leatherColor,
    required String sex,
    required String slaughterRecord,
    bool? status
  }) async {
    DocumentReference documentReferencer = _mainCollection.doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      'description': description,
      'sisbovEarring': sisbovEarring,
      'birthDate': birthDate,
      'flock': flock,
      'breed': breed,
      'leatherColor': leatherColor,
      'sex': sex,
      'slaughterRecord': slaughterRecord,
      'status':status,
    };
    var value = await documentReferencer
          .update(data)
          .whenComplete(() => print('Dados alterados com sucesso!!'))
          .catchError((e) => print(e));

    return Future.value('done');

  }

  static readItemsN() {
    _firestore.collection("animal").get().then(
          (res) => print('Successfully completed ${res.docs.last.id}'),
          onError: (e) => print("Error completing: $e"),
        );
  }

  static Future<List<Animal>> readItems() async {
    try {
      List<Animal> result = [];
      QuerySnapshot querySnapshot =
          await _firestore.collection('animal').get().then((value) => value);
      var i = 0;
      querySnapshot.docs.forEach((doc) {
        result.add(Animal(
            doc.id,
            doc['description'],
            doc['sisbovEarring'],
            doc['birthDate'],
            doc['flock'],
            doc['breed'],
            doc['leatherColor'],
            doc['sex'],
            doc['slaughterRecord'],
            doc["status"]));
        //print(result[i].descricao);
        i++;
      });

      return result;
    } catch (error) {
      return [];
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> listAnimal() {
    return _firestore.collection('animal').snapshots();
  }

  static Future<Animal> find(String id) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('animal').get().then((value) => value);
    var result = querySnapshot.docs.where((element) => element.id == id);
    result.first.data();
    Animal retorn = Animal(result.first.id,
        result.first['description'],
        result.first['sisbovEarring'],
        result.first['birthDate'],
        result.first['flock'],
        result.first['breed'],
        result.first['leatherColor'],
        result.first['sex'],
        result.first['slaughterRecord'],
        result.first["status"]);
    return retorn;
  }
}
