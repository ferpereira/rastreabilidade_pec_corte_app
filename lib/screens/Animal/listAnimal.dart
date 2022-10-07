import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreabilidade_pec_corte_app/screens/home_page.dart';

import '../../widgets/list_iten_animal_view.dart';
import 'add_animal_form.dart';

class ListAnimal extends StatefulWidget {
  final User user;
  const ListAnimal({required this.user});

  @override
  ListAnimalState createState() => ListAnimalState();
}

class ListAnimalState extends State<ListAnimal> {
  bool isSelectionMode = false;
  late int listLength = 0;
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
                    builder: (context) => HomePage(user: _currentUser))),
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
                return List_iten_animal_view(
                  snapshot: snapshot, currentUser: _currentUser,
                );
              }
            }));
  }
}

