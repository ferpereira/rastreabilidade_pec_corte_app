import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:rastreabilidade_pec_corte_app/screens/Animal/listAnimal.dart';
import 'package:rastreabilidade_pec_corte_app/utils/validator.dart';

import '../../db/database.dart';
import '../../model/animal.dart';
import '../../widgets/dropdown.dart';

class AddAnimalForm extends StatefulWidget {
  final String? doc;
  final User user;
  const AddAnimalForm({Key? key, this.doc, required this.user}) : super(key: key);

  @override
  State<AddAnimalForm> createState() => _AddAnimalFormState();
}

/*
descrição -> description
brinco sisbov - sisbovEarring
data nascimento -> birthDate
rebanho -> flock
raça -> breed
cor do couro -> leatherColor
sexo -> sex
registro de abate -> slaughterRecord
 */

class _AddAnimalFormState extends State<AddAnimalForm> {
  final descriptionController = TextEditingController();
  final sisbovEarringController = TextEditingController();
  final birthDateController = TextEditingController();
  final flockController = TextEditingController();
  final breedController = TextEditingController();
  final leatherColorController = TextEditingController();
  final sexController = TextEditingController();
  final slaughterRecordController = TextEditingController();
  final statusController = TextEditingController();
  late String title = "Registrar Animal";
  late String? _docEdit = "";
  late Future<Animal> identification;
  late bool _findRegister = false;
  late String lbButton = "Gravar";
  bool isChecked = false;
  late String msg = "";
  Color? corToast = Colors.redAccent[400];
  IconData iconToast = Icons.error;
  late User user;

  @override
  void initState() {
    cleanForm(false);
    if (widget.doc!.isNotEmpty) {
      _findRegister = true;
      _docEdit = widget.doc;
      title = "Editar Animal";
      lbButton = "Alterar";
      _asyncFindRegister();
    }
    user = widget.user;
    super.initState();
  }

  void cleanForm(bool r){
    descriptionController.text = "";
    sisbovEarringController.text = "";
    birthDateController.text = "";
    flockController.text = "";
    breedController.text = "";
    leatherColorController.text = "";
    sexController.text = "";
    slaughterRecordController.text = "";
    statusController.text = "";

    if(r){
      _docEdit = "";
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => ListAnimal(user: user)));
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
        if(action == "nasc"){
          birthDateController.text = selectedDate.toString();
        }else{
          slaughterRecordController.text = selectedDate.toString();
        }

      });
    }
  }

  _asyncFindRegister() async {
    identification = Database.find(_docEdit!);
    identification.then((value) => {
          descriptionController.text = value.description.toString(),
          sisbovEarringController.text = value.sisbovEarring.toString(),
          birthDateController.text = value.birthDate.toString(),
          flockController.text = value.flock.toString(),
          breedController.text = value.breed.toString(),
          leatherColorController.text = value.leatherColor.toString(),
          sexController.text = value.sex.toString(),
          slaughterRecordController.text = value.slaughterRecord.toString(),
          setState(() {
            isChecked = value.status!;
            if(isChecked){
              statusController.text = "true";
              print('ligado');
            }else{
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
              TextField(
                controller: sisbovEarringController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Brinco sisbov',
                  hintText: 'Informe a código sisbov',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                  controller: birthDateController,
                  keyboardType: TextInputType.text,
                  enabled: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Data Nascimento',
                  ),
                ),
                  SizedBox(height: 10,),
                  MaterialButton(

                    onPressed: () => _selectDate(context, "nasc"),
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
              TextField(
                controller: flockController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Rebanho',
                  hintText: 'Informe o rebanho',
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              TextField(
                controller: breedController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Raça do animal',
                  hintText: 'Informe a raça do animal',
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              TextField(
                controller: leatherColorController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Cor do couro do animal',
                  hintText: 'Informe a cor do couro',
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              Dropdown(),
              TextField(
                controller: sexController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Sexo do Animal',
                  hintText: 'Informe o sexo do animal',
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: slaughterRecordController,
                    keyboardType: TextInputType.text,
                    enabled: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Data do abate do animal',
                    ),
                  ),
                  SizedBox(height: 10,),
                  MaterialButton(
                    onPressed: () => _selectDate(context, "" ),
                    child: Text('Selecione a data abate'),
                    color: Colors.blueGrey[200],
                    textColor: Colors.white,
                    minWidth: 180,
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
              Text('Situação do animal (Ativo/Inativo)', textAlign: TextAlign.left),
              _MyStatefulWidgetState(context),
            ]),
              MaterialButton(
                onPressed: () async {
                  if (_findRegister) {
                    var s = await Database.updateItem(id: _docEdit!, description: descriptionController.text,
                      sisbovEarring: sisbovEarringController.text,
                      birthDate: birthDateController.text,
                      flock: flockController.text,
                      breed: breedController.text,
                      leatherColor: leatherColorController.text,
                      sex: sexController.text,
                      slaughterRecord: slaughterRecordController.text,
                      status: isChecked,);
                    if(s == 'done'){
                      msg = "Dados alterado com sucesso!";
                      corToast = Colors.green;
                      iconToast = Icons.update;
                      cleanForm(true);
                    }else{
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
                    var s = await Database.addItem(
                      description: descriptionController.text,
                      sisbovEarring: sisbovEarringController.text,
                      birthDate: birthDateController.text,
                      flock: flockController.text,
                      breed: breedController.text,
                      leatherColor: leatherColorController.text,
                      sex: sexController.text,
                      slaughterRecord: slaughterRecordController.text,
                      status: isChecked,
                      );
                      if( s == 'done'){
                        msg = "Dados registrado com sucesso!";
                        corToast = Colors.green;
                        iconToast = Icons.update;
                        cleanForm(false);
                      }else{
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
          if(isChecked){
            statusController.text = "true";
          }else{
            statusController.text = "false";
            isChecked = false;
          }
        });
    },
    );
  }



}


