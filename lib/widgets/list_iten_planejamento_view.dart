import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreabilidade_pec_corte_app/model/planejamento.dart';
import 'package:rastreabilidade_pec_corte_app/screens/Planejamento/add_planning_form.dart';


class List_iten_panejamento_view extends StatelessWidget {
  final User currentUser;
  const List_iten_panejamento_view({
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
                  leading: Icon(Icons.room_preferences, color: Colors.yellow,),
                  title: Text('Planejamento:'),
                  subtitle: Text('${doc['description']} ;- Procedimento: ${doc['procedure']}'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('Situação do planejamento', style: TextStyle(color: Colors.black26, fontSize: 12), ),
                    Checkbox(
                        materialTapTargetSize:
                        MaterialTapTargetSize.padded,
                        value: doc['status'],
                        activeColor: Colors.white30,
                        checkColor: Colors.greenAccent,
                        onChanged: (val) async {
                          final Planning data = Planning(
                              doc.id,
                              doc['description'],
                              doc['dateBegin'],
                              doc['dateEnd'],
                              doc['idFlock'],
                              doc['procedure'],
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
                                AddPlanningForm(doc: doc.id, user: currentUser, ),
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