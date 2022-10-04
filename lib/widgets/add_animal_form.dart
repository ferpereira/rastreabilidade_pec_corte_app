import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../db/database.dart';
import '../model/animal.dart';

class AddAnimalForm extends StatefulWidget {
  final String? doc;
  const AddAnimalForm({Key? key, this.doc}) : super(key: key);

  @override
  State<AddAnimalForm> createState() => _AddAnimalFormState();
}

class _AddAnimalFormState extends State<AddAnimalForm> {
  final userNameController = TextEditingController();
  final userAgeController = TextEditingController();
  final userSalaryController = TextEditingController();
  late String title = "Registrar Animal";
  late String? _docEdit = "";
  late Future<Animal> identification;
  late bool _findRegister = false;
  late String lbButton = "Gravar";

  @override
  void initState() {
    if (widget.doc!.isNotEmpty) {
      _findRegister = true;
      _docEdit = widget.doc;
      title = "Editar Animal";
      lbButton = "Alterar";
      _asyncFindRegister();
    }
    super.initState();
  }

  _asyncFindRegister() async {
    identification = Database.find(_docEdit!);
    identification.then((value) => {
          print(value.descricao),
          userNameController.text = value.descricao.toString(),
          userAgeController.text = value.dataNascimento.toString(),
        });
  }

  @override
  Widget build(BuildContext context) {
    // if (_findRegister) {
    //   return Center(
    //     child: CircularProgressIndicator(color: Colors.blueGrey),
    //   );
    // } else {
    return Scaffold(
      appBar: AppBar(
        title: Text('${title}'),
      ),
      body: Center(
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
                controller: userNameController,
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
              TextField(
                controller: userAgeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Data nascimento',
                  hintText: 'Informe a data nascimento',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: () async {
                  // Map<String, String> students = {
                  //   'name': userNameController.text,
                  //   'age': userAgeController.text,
                  //   'salary': userSalaryController.text
                  // };
                  if (_findRegister) {
                    print("Gravar alteração");
                  } else {
                    await Database.addItem(
                        descricao: userNameController.text,
                        dataNascimento: userAgeController.text);
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
}
//}
