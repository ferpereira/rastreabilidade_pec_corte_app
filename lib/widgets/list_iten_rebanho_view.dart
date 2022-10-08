import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreabilidade_pec_corte_app/model/rebanho.dart';
import 'package:rastreabilidade_pec_corte_app/screens/Rebanho/add_flock_from.dart';

class List_iten_rebanho_view extends StatelessWidget {
  final User currentUser;
  const List_iten_rebanho_view({
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
                  title: Text('Identificação do rebanho:'),
                  subtitle: Text('${doc['description']} Fazenda: ${doc['farm']}'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('Situação do Rebanho', style: TextStyle(color: Colors.black26, fontSize: 12), ),
                    Checkbox(
                        materialTapTargetSize:
                        MaterialTapTargetSize.padded,
                        value: doc['status'],
                        activeColor: Colors.white30,
                        checkColor: Colors.greenAccent,
                        onChanged: (val) async {
                          final Flock data = Flock(
                              doc.id,
                              doc['description'],
                              doc['maximumAmount'],
                              doc['farm'],
                              doc['herdDate'],
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
                                AddFlockForm(doc: doc.id, user: currentUser, ),
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