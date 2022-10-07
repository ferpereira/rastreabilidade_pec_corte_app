import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rastreabilidade_pec_corte_app/screens/Animal/add_animal_form.dart';
import 'package:rastreabilidade_pec_corte_app/screens/Animal/listAnimal.dart';

import '../screens/Login/login_page.dart';

class ButtonHome extends StatelessWidget {
  final User currentUser;
  const ButtonHome({Key? key, required this.currentUser}) : super (key: key);



  @override
  Widget build(BuildContext context) {
    print(currentUser);
    return Center(
            child: Column(
              mainAxisAlignment:  MainAxisAlignment.spaceAround,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddAnimalForm(
                              doc: "",user: currentUser,
                            ),
                          ),
                        ),
                        child: Text('CADASTRO DE ANIMAL'),
                        color: Colors.blue,
                        textColor: Colors.black,
                        minWidth: 150,
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
                        minWidth: 170,
                        height: 120,
                      ),
                      ]
                ),

                MaterialButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  ),
                  child: Text('CADASTRO DE REBANHO'),
                  color: Colors.deepPurpleAccent,
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
                  child: Text('CADASTRO DE VACINAS'),
                  color: Colors.teal,
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
                  child: Text('INCLUIR PLANEJAMENTO'),
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
                  child: Text('REGISTRA ATIVIDADE PLANEJAMENTO'),
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