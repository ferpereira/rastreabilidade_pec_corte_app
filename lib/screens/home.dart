import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreabilidade_pec_corte_app/db/database.dart';
import 'package:rastreabilidade_pec_corte_app/model/animal.dart';
import 'package:rastreabilidade_pec_corte_app/screens/profile_page.dart';

class Home extends StatefulWidget {
  final User user;
  const Home({required this.user});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool isSelectionMode = false;
  late int listLength = 0;
  late List<Animal> _selected = [];
  bool _selectAll = false;
  bool _isGridMode = false;
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
    initializeSelection();
  }

  _asyncMethod() async {
    Future<List<Animal>> db = Database.readItems();
    List<Animal> listAnimal = [];
    db.then((value) => (listAnimal.addAll(value)));
    listLength = listAnimal.length;
    _selected = listAnimal;
    //print(listAnimal[0].descricao);
  }

  void initializeSelection() {
    // _selected = List<bool>.generate(listLength, (_) => false);
  }

  @override
  void dispose() {
    _selected.clear();
    super.dispose();
  }

  final db = FirebaseFirestore.instance;
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
            // if (_isGridMode)
            //   IconButton(
            //     icon: const Icon(Icons.grid_on, color: Colors.white),
            //     onPressed: () {
            //       setState(() {
            //         _isGridMode = false;
            //       });
            //     },
            //   )
            // else
            // IconButton(
            //   icon: const Icon(Icons.list, color: Colors.white),
            //   onPressed: () {
            //     setState(() {
            //       _isGridMode = true;
            //     });
            //   },
            // ),
            if (isSelectionMode)
              TextButton(
                  child: !_selectAll
                      ? const Text(
                          'select all',
                          style: TextStyle(color: Colors.white),
                        )
                      : const Text(
                          'unselect all',
                          style: TextStyle(color: Colors.white),
                        ),
                  onPressed: () {
                    _selectAll = !_selectAll;
                    setState(() {
                      _selected.forEach((value) {
                        if (_selectAll) {
                          value.status = true;
                        } else {
                          value.status = false;
                        }
                      });
                    });
                  }),
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
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return Card(
                      child: ListTile(
                        title: Text(doc['descricao']),
                      ),
                    );
                  }).toList(),
                );
              }
            }));
  }
}

// class GridBuilder extends StatefulWidget {
//   const GridBuilder({
//     required this.selectedList,
//     required this.isSelectionMode,
//     required this.onSelectionChange,
//   });

//   final bool isSelectionMode;
//   final Function(bool)? onSelectionChange;
//   final List<Animal> selectedList;

//   @override
//   GridBuilderState createState() => GridBuilderState();
// }

// class GridBuilderState extends State<GridBuilder> {
//   void _toggle(int index) {
//     if (widget.isSelectionMode) {
//       setState(() {
//         widget.selectedList[index].status =
//             !(widget.selectedList[index].status);
//       });
//     }
//   }

// @override
// Widget build(BuildContext context) {
//   return GridView.builder(
//       itemCount: widget.selectedList.length,
//       gridDelegate:
//           const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//       itemBuilder: (_, int index) {
//         return InkWell(
//           onTap: () => _toggle(index),
//           onLongPress: () {
//             if (!widget.isSelectionMode) {
//               setState(() {
//                 widget.selectedList[index].status = true;
//               });
//               widget.onSelectionChange!(true);
//             }
//           },
//           child: GridTile(
//               child: Container(
//             child: widget.isSelectionMode
//                 ? Checkbox(
//                     onChanged: (bool? x) => _toggle(index),
//                     value: widget.selectedList[index].status)
//                 : const Icon(Icons.image),
//           )),
//         );
//       });
// }
//}

class ListBuilder extends StatefulWidget {
  const ListBuilder({
    required this.selectedList,
    required this.isSelectionMode,
    required this.onSelectionChange,
  });

  final bool isSelectionMode;
  final List<Animal> selectedList;
  final Function(bool)? onSelectionChange;

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  void _toggle(int index) {
    if (widget.isSelectionMode) {
      setState(() {
        widget.selectedList[index].status = !widget.selectedList[index].status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.selectedList.length,
        itemBuilder: (_, int index) {
          return ListTile(
              onTap: () => _toggle(index),
              onLongPress: () {
                if (!widget.isSelectionMode) {
                  setState(() {
                    widget.selectedList[index].status = true;
                  });
                  widget.onSelectionChange!(true);
                }
              },
              trailing: widget.isSelectionMode
                  ? Checkbox(
                      value: widget.selectedList[index].status,
                      onChanged: (bool? x) => _toggle(index),
                    )
                  : const SizedBox.shrink(),
              title: Text(widget.selectedList[index].descricao ?? ''));
        });
  }
}
