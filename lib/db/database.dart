import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rastreabilidade_pec_corte_app/model/animal.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference _mainCollection = _firestore.collection('animal');

class Database {
  static String? userUid;

  static Future<void> addItem({
    required String descricao,
    required String dataNascimento,
  }) async {
    DocumentReference documentReferencer = _mainCollection.doc(userUid);

    Map<String, dynamic> data = <String, dynamic>{
      "descricao": descricao,
      "dataNascimento": dataNascimento,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

  // static Stream<QuerySnapshot> readItems3() {
  //   CollectionReference notesItemCollection =
  //       _mainCollection.doc(userUid).collection('animal');
  //   print(notesItemCollection);
  //   return notesItemCollection.snapshots();
  // }

  static readItems4() {
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
            doc.id, doc["descricao"], doc["dataNascimento"], doc["status"]));
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
}
