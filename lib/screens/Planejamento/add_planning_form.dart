import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:rastreabilidade_pec_corte_app/db/database_planning.dart';
import 'package:rastreabilidade_pec_corte_app/model/planejamento.dart';
import 'package:rastreabilidade_pec_corte_app/screens/Planejamento/list_planning.dart';

import '../../db/database.dart';

class AddPlanningForm extends StatefulWidget {
  final String? doc;
  final User user;
  const AddPlanningForm({Key? key, this.doc, required this.user})
      : super(key: key);

  @override
  State<AddPlanningForm> createState() => _AddPlanningFormState();
}

/*
id = '';
description; // descrição
dateBegin; // dataInicio
dateEnd; // dataFim
idFlock = []; // lista rebanhos
procedure; // precedimento
registerProcedure = []; //lista de registro
status = true ;
 */

class _AddPlanningFormState extends State<AddPlanningForm> {
  final descriptionController = TextEditingController();
  final dateBeginController = TextEditingController();
  final dateEndController = TextEditingController();
  final idFlockController = TextEditingController();
  final procedureController = TextEditingController();
  final statusController = TextEditingController();
  late String title = "Planejamento de procedimentos";
  late String? _docEdit = "";
  late Future<Planning> identification;
  late bool _findRegister = false;
  late String lbButton = "Gravar";
  bool isChecked = false;
  late String msg = "";
  Color? corToast = Colors.redAccent[400];
  IconData iconToast = Icons.error;
  late User user;
  String? selectedValue = null;
  Stream<QuerySnapshot>? _rebanho;
  String? rebanho;

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [

      DropdownMenuItem(child: Text("M"),value: "M"),
      DropdownMenuItem(child: Text("F"),value: "F"),
    ];
    return menuItems;
  }

  @override
  void initState() {
    cleanForm(false);
    if (widget.doc!.isNotEmpty) {
      _findRegister = true;
      _docEdit = widget.doc;
      title = "Editar Planejamento";
      lbButton = "Alterar";
      _asyncFindRegister();
    }
    _rebanho= FirebaseFirestore.instance.collection("rebanho").snapshots();
    user = widget.user;
    super.initState();

  }

  void cleanForm(bool r) {
    descriptionController.text = "";
    dateBeginController.text = "";
    dateEndController.text = "";
    idFlockController.text = "";
    procedureController.text = "";
    statusController.text = "";

    if (r) {
      _docEdit = "";
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ListPlanning(user: user)));
    }
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context, String action) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        if (action == "begin") {
          dateBeginController.text = selectedDate.toString();
        } else {
          dateEndController.text = selectedDate.toString();
        }
      });
    }
  }

  _asyncFindRegister() async {
    identification = DatabasePlanning.find(_docEdit!);
    identification.then((value) => {
      descriptionController.text = value.description.toString(),
      dateBeginController.text = value.dateBegin.toString(),
      dateEndController.text = value.dateEnd.toString(),
      idFlockController.text = value.idFlock.toString(),
      procedureController.text = value.procedure.toString(),
      setState(() {
        isChecked = value.status!;
        if (isChecked) {
          statusController.text = "true";
          print('ligado');
        } else {
          statusController.text = "false";
          print('desligado');
        }
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${title}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                '${title}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: descriptionController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Descrição',
                  hintText: 'Entre com informações do animal',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: dateBeginController,
                    keyboardType: TextInputType.text,
                    enabled: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Data Inicio planejado',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    onPressed: () => _selectDate(context, "begin"),
                    child: Text('Selecione a data'),
                    color: Colors.blueGrey,
                    textColor: Colors.white,
                    minWidth: 200,
                    height: 40,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: dateEndController,
                    keyboardType: TextInputType.text,
                    enabled: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Data fechamento do planejado',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    onPressed: () => _selectDate(context, ""),
                    child: Text('Selecione a data'),
                    color: Colors.blueGrey,
                    textColor: Colors.white,
                    minWidth: 200,
                    height: 40,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),

              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                  stream: _rebanho,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
                  return DropdownButton(
                          value: rebanho,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          hint: const Text("Rebanho"),
                          items: snapshot.data?.docs.map((doc) {
                          return DropdownMenuItem(
                                  value: doc.id,
                                  child: Text(doc['description']),
                                  );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                        rebanho = value!;
                                        print(value);
                                        idFlockController.text = value!;
                                    },
                                  );
                          },
                          );
                  }),
                  ],
                  ),

              const SizedBox(
                height: 30,
              ),

              TextField(
                controller: procedureController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Procedimento',
                  hintText: 'Descreva o procedimento realizado no planejamento',
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text('Situação do planejamento (Ativo/Inativo)',
                    textAlign: TextAlign.left),
                _MyStatefulWidgetState(context),
              ]),
              MaterialButton(
                onPressed: () async {
                  if (_findRegister) {
                    var s = await DatabasePlanning.updateItem(
                      id: _docEdit!,
                      description: descriptionController.text,
                      dateBegin: dateBeginController.text,
                      dateEnd: dateEndController.text,
                      idFlock: idFlockController.text,
                      procedure: procedureController.text,
                      status: isChecked,
                    );
                    if (s == 'done') {
                      msg = "Dados alterado com sucesso!";
                      corToast = Colors.green;
                      iconToast = Icons.update;
                      cleanForm(true);
                    } else {
                      msg = "Não foi possivel alterar os dados";
                      iconToast = Icons.error;
                      corToast = Colors.redAccent[400];
                    }
                    // ignore: use_build_context_synchronously
                    MotionToast(
                      color: corToast!,
                      description: "${msg}",
                      icon: iconToast,
                      enableAnimation: false,
                      animationDuration: Duration(seconds: 3),
                    ).show(context);
                  } else {
                    if(idFlockController.text == ""){
                      print('Erro');
                    }else{var s = await DatabasePlanning.addItem(
                      description: descriptionController.text,
                      dateBegin: dateBeginController.text,
                      dateEnd: dateEndController.text,
                      idFlock: idFlockController.text,
                      procedure: procedureController.text,
                      status: isChecked,
                    );
                    if (s == 'done') {
                      msg = "Dados registrado com sucesso!";
                      corToast = Colors.green;
                      iconToast = Icons.update;
                      cleanForm(false);
                    } else {
                      msg = "Não foi possivel registrar os dados";
                      iconToast = Icons.error;
                      corToast = Colors.redAccent[400];
                    }
                    // ignore: use_build_context_synchronously
                    MotionToast(
                      color: corToast!,
                      description: "${msg}",
                      icon: iconToast,
                      enableAnimation: false,
                      animationDuration: Duration(seconds: 3),
                    ).show(context);
                    }
                    }


                },
                child: Text('${lbButton}'),
                color: Colors.blueGrey,
                textColor: Colors.white,
                minWidth: 300,
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget _MyStatefulWidgetState(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.cyanAccent;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
          if (isChecked) {
            statusController.text = "true";
          } else {
            statusController.text = "false";
            isChecked = false;
          }
        });
      },
    );
  }


}
