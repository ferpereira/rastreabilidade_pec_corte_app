import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreabilidade_pec_corte_app/model/animal.dart';
import 'package:rastreabilidade_pec_corte_app/screens/profile_page.dart';

import '../widgets/add_animal_form.dart';

class Home extends StatefulWidget {
  final User user;
  const Home({required this.user});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool isSelectionMode = false;
  late int listLength = 0;
  bool _selectAll = false;
  late User _currentUser;
  final db = FirebaseFirestore.instance;
  final bool checked = false;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
    initializeSelection();
  }

  void initializeSelection() {
    // _selected = List<bool>.generate(listLength, (_) => false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => ProfilePage(user: _currentUser))),
          ),
          title: const Text(
            'Lista de Animal',
            style: TextStyle(color: Color(0xffffffff)),
          ),
          actions: <Widget>[
            if (isSelectionMode)
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  setState(() {
                    isSelectionMode = false;
                  });
                  initializeSelection();
                },
              ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: db.collection('animal').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.blueGrey),
                );
              } else {
                var listView = ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return Center(
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.edit),
                              iconSize: 32,
                              color: Colors.blueGrey,
                              tooltip: 'Toggle Bluetooth',
                              onPressed: () async {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddAnimalForm(doc: doc.id),
                                  ),
                                );
                              }),
                          Container(
                              padding: EdgeInsets.all(16.0),
                              width: max(0, 230),
                              height: 65,
                              child: Text('Animal - ${doc['descricao']}')),
                          Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              value: doc['status'],
                              activeColor: Colors.black,
                              checkColor: Colors.greenAccent,
                              onChanged: (val) async {
                                final Animal data = Animal(
                                    doc.id,
                                    doc["descricao"],
                                    doc["dataNascimento"],
                                    doc["status"]);
                                data.status = val;
                                await doc.reference.update(data.toMap());
                              }),
                        ],
                      ),
                    );
                  }).toList(),
                );
                return listView;
              }
            }));
  }
}
