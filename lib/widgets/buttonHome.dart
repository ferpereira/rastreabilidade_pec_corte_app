import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rastreabilidade_pec_corte_app/screens/Animal/add_animal_form.dart';
import 'package:rastreabilidade_pec_corte_app/screens/Animal/listAnimal.dart';
import 'package:rastreabilidade_pec_corte_app/screens/Rebanho/add_flock_from.dart';
import 'package:rastreabilidade_pec_corte_app/screens/Rebanho/list_flock.dart';
import 'package:rastreabilidade_pec_corte_app/screens/Vacinas/add_vaccine_form.dart';
import 'package:rastreabilidade_pec_corte_app/screens/Vacinas/list_vaccine.dart';

import '../screens/Login/login_page.dart';

class ButtonHome extends StatelessWidget {
  final User currentUser;
  const ButtonHome({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(currentUser);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            MaterialButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddAnimalForm(
                    doc: "",
                    user: currentUser,
                  ),
                ),
              ),
              child: Text('CADASTRO DE ANIMAL'),
              color: Colors.blue,
              textColor: Colors.black,
              minWidth: 160,
              height: 120,
            ),
            MaterialButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ListAnimal(
                    user: currentUser,
                  ),
                ),
              ),
              child: Text('LISTA DE ANIMAL'),
              color: Colors.lightBlue,
              textColor: Colors.black,
              minWidth: 160,
              height: 120,
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            MaterialButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddFlockForm(
                    doc: "",
                    user: currentUser,
                  ),
                ),
              ),
              child: Text('CADASTRO DE REBANHO'),
              color: Colors.deepPurpleAccent,
              textColor: Colors.black,
              minWidth: 150,
              height: 120,
            ),
            MaterialButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ListFlock(user: currentUser),
                ),
              ),
              child: Text('LISTA DE REBANHO'),
              color: Colors.deepPurpleAccent,
              textColor: Colors.black,
              minWidth: 150,
              height: 120,
            ),
          ]),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          MaterialButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddVaccineForm(doc: "",
                user: currentUser,
              ),
            ),
          ),
          child: Text('CADASTRO DE VACINAS'),
          color: Colors.teal,
          textColor: Colors.black,
          minWidth: 160,
          height: 120,
        ),
        MaterialButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ListVaccine(user: currentUser),
            ),
          ),
          child: Text('LISTA DE VACINAS'),
          color: Colors.lightGreen,
          textColor: Colors.black,
          minWidth: 160,
          height: 120,
        ),
      ]),
          MaterialButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            ),
            child: Text('REGISTRAR VACINAÇÃO'),
            color: Colors.deepPurple,
            textColor: Colors.black,
            minWidth: 350,
            height: 120,
          ),
          MaterialButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            ),
            child: Text('LISTAR VACINAÇÃO'),
            color: Colors.lightBlue,
            textColor: Colors.black,
            minWidth: 350,
            height: 120,
          ),
        ],
      ),
    );
  }
}
