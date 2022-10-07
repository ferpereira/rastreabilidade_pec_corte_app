import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/animal.dart';
import '../screens/Animal/add_animal_form.dart';

class List_iten_animal_view extends StatelessWidget {
  final User currentUser;
  const List_iten_animal_view({
    Key? key,
    required AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
    required this.currentUser,
  }) : _snapshot = snapshot,  super(key: key);

  final status = '';

  final AsyncSnapshot<QuerySnapshot<Object?>> _snapshot;

  @override
  Widget build(BuildContext context) {
    var listView = ListView(
      children: _snapshot.data!.docs.map((doc) {
        return Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.album, color: Colors.yellow,),
                  title: Text('Identificação do animal:'),
                  subtitle: Text('${doc['description']} brinco: ${doc['sisbovEarring']}'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('Situação do Animal', style: TextStyle(color: Colors.black26, fontSize: 12), ),
                    Checkbox(
                        materialTapTargetSize:
                        MaterialTapTargetSize.padded,
                        value: doc['status'],
                        activeColor: Colors.white30,
                        checkColor: Colors.greenAccent,
                        onChanged: (val) async {
                          final Animal data = Animal(
                              doc.id,
                              doc['description'],
                              doc['sisbovEarring'],
                              doc['birthDate'],
                              doc['flock'],
                              doc['breed'],
                              doc['leatherColor'],
                              doc['sex'],
                              doc['slaughterRecord'],
                              doc['status']);
                          data.status = val;
                          await doc.reference.update(data.toMap());
                        }),
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('Editar'),
                      onPressed: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                AddAnimalForm(doc: doc.id, user: currentUser, ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
    return listView;
  }
}