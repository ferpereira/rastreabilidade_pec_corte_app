import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreabilidade_pec_corte_app/screens/home_page.dart';
import 'package:rastreabilidade_pec_corte_app/widgets/list_iten_planejamento_view.dart';


class ListPlanning extends StatefulWidget {
  final User user;
  const ListPlanning({required this.user});

  @override
  ListPlanningState createState() => ListPlanningState();
}

class ListPlanningState extends State<ListPlanning> {
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
            'Lista de planejamento',
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
            stream: db.collection('planejamento').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.blueGrey),
                );
              } else {
                return List_iten_panejamento_view(
                  snapshot: snapshot, currentUser: _currentUser,
                );
              }
            }));
  }
}

