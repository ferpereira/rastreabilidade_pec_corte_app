import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:rastreabilidade_pec_corte_app/db/database_flock.dart';
import 'package:rastreabilidade_pec_corte_app/screens/Rebanho/list_flock.dart';

import '../../model/rebanho.dart';

class AddFlockForm extends StatefulWidget {
  final String? doc;
  final User user;
  const AddFlockForm({Key? key, this.doc, required this.user}) : super(key: key);

  @override
  State<AddFlockForm> createState() => _AddFlockFormState();
}

/*
id; códigoDoc
description;  descrição
maximumAmount;  quantidade máxima
farm; fazenda
herdDate; data rebanho
status; situação
 */

class _AddFlockFormState extends State<AddFlockForm> {
  final descriptionController = TextEditingController();
  final maximumAmountController = TextEditingController();
  final farmController = TextEditingController();
  final herdDateController = TextEditingController();
  final statusController = TextEditingController();
  late String title = "Registrar Rebanho";
  late String? _docEdit = "";
  late Future<Flock> identification;
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
      title = "Editar Rebanho";
      lbButton = "Alterar";
      _asyncFindRegister();
    }
    user = widget.user;
    super.initState();
  }

void cleanForm(bool r){
    descriptionController.text = "";
    maximumAmountController.text = "";
    farmController.text = "";
    herdDateController.text = "";
    statusController.text = "";

    if(r){
      _docEdit = "";
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => ListFlock(user: user)));
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
          herdDateController.text = selectedDate.toString();
      });
    }
  }

  _asyncFindRegister() async {
    identification = DatabaseFlock.find(_docEdit!);
    identification.then((value) => {
      descriptionController.text = value.description.toString(),
      maximumAmountController.text = value.maximumAmount.toString(),
      farmController.text = value.farm.toString(),
      herdDateController.text = value.herdDate.toString(),
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
                  hintText: 'Entre com informações do rebanho',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: maximumAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Quantidade de animal',
                  hintText: 'Informe a a quantidade de animal',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: herdDateController,
                    keyboardType: TextInputType.text,
                    enabled: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Data criação do Rebanho',
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
                controller: farmController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Fazenda',
                  hintText: 'Informe a fazenda do rebanho ',
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Situação do rebanho (Ativo/Inativo)', textAlign: TextAlign.left),
                    _MyStatefulWidgetState(context),
                  ]),
              MaterialButton(
                onPressed: () async {
                  if (_findRegister) {
                    var s = await DatabaseFlock.updateItem(id: _docEdit!, description: descriptionController.text,
                      maximumAmount: maximumAmountController.text,
                      farm: farmController.text,
                      herdDate: herdDateController.text,
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
                    await DatabaseFlock.addItem(
                      description: descriptionController.text,
                      maximumAmount: maximumAmountController.text,
                      farm: farmController.text,
                      herdDate: herdDateController.text,
                      status: isChecked,);
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


