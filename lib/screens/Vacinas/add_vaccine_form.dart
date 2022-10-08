import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:rastreabilidade_pec_corte_app/db/database_vaccine.dart';
import 'package:rastreabilidade_pec_corte_app/model/vacina.dart';
import 'package:rastreabilidade_pec_corte_app/screens/Vacinas/list_vaccine.dart';

class AddVaccineForm extends StatefulWidget {
  final String? doc;
  final User user;
  const AddVaccineForm({Key? key, this.doc, required this.user}) : super(key: key);

  @override
  State<AddVaccineForm> createState() => _AddVaccineFormState();
}

/*
 description; // descrição
 dateFabrication; // data Fabricação
 dateValidity; // data de validade
 laboratory; // procedimento
 status = true ;
 */

class _AddVaccineFormState extends State<AddVaccineForm> {
  final descriptionController = TextEditingController();
  final dateFabricationController = TextEditingController();
  final dateValidityController = TextEditingController();
  final laboratoryController = TextEditingController();
  final statusController = TextEditingController();
  late String title = "Registrar Vacina";
  late String? _docEdit = "";
  late Future<Vaccine> identification;
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
      title = "Editar Vacina";
      lbButton = "Alterar";
      _asyncFindRegister();
    }
    user = widget.user;
    super.initState();
  }

  void cleanForm(bool r){
    descriptionController.text = "";
    dateFabricationController.text = "";
    dateValidityController.text = "";
    laboratoryController.text = "";
    statusController.text = "";

    if(r){
      _docEdit = "";
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => ListVaccine(user: user)));
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
        if(action == "fabr"){
          dateFabricationController.text = selectedDate.toString();
        }else{
          dateValidityController.text = selectedDate.toString();
        }
      });
    }
  }

  /*
  final dateFabrication = TextEditingController();
  final dateValidity = TextEditingController();
  final laboratory = TextEditingController();
   */

  _asyncFindRegister() async {
    identification = DatabaseVaccine.find(_docEdit!);
    identification.then((value) => {
      descriptionController.text = value.description.toString(),
      dateFabricationController.text = value.dateFabrication.toString(),
      dateValidityController.text = value.dateValidity.toString(),
      laboratoryController.text = value.laboratory.toString(),
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
                  hintText: 'Entre com informações da vacina',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: dateFabricationController,
                    keyboardType: TextInputType.text,
                    enabled: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Data fabricação da vacina',
                    ),
                  ),
                  SizedBox(height: 10,),
                  MaterialButton(
                    onPressed: () => _selectDate(context, "fabr"),
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
                    controller: dateValidityController,
                    keyboardType: TextInputType.text,
                    enabled: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Data validade da vacina',
                    ),
                  ),
                  SizedBox(height: 10,),
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

              TextField(
                controller: laboratoryController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Laboratório',
                  hintText: 'Entre com informações do laboratório',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Situação da vacina (Ativo/Inativo)', textAlign: TextAlign.left),
                    _MyStatefulWidgetState(context),
                  ]),
              MaterialButton(
                onPressed: () async {
                  if (_findRegister) {
                    var s = await DatabaseVaccine.updateItem(id: _docEdit!, description: descriptionController.text,
                      dateFabrication: dateFabricationController.text,
                      dateValidity: dateValidityController.text,
                      laboratory: laboratoryController.text,
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
                    var s = await DatabaseVaccine.addItem(description: descriptionController.text,
                      dateFabrication: dateFabricationController.text,
                      dateValidity: dateValidityController.text,
                      laboratory: laboratoryController.text,
                      status: isChecked,);

                    if(s == 'done'){
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


