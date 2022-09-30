import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../db/database.dart';

class AddAnimalForm extends StatefulWidget {
  const AddAnimalForm({Key? key}) : super(key: key);

  @override
  State<AddAnimalForm> createState() => _AddAnimalFormState();
}

class _AddAnimalFormState extends State<AddAnimalForm> {
  final userNameController = TextEditingController();
  final userAgeController = TextEditingController();
  final userSalaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inserting data'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Registro de animal',
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
                  await Database.addItem(
                      descricao: userNameController.text,
                      dataNascimento: userAgeController.text);
                },
                child: const Text('Insert Data'),
                color: Colors.blue,
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
