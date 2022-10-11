import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreabilidade_pec_corte_app/screens/Animal/listAnimal.dart';
import 'package:rastreabilidade_pec_corte_app/screens/Login/login_page.dart';
import 'package:rastreabilidade_pec_corte_app/utils/fire_auth.dart';
import 'package:rastreabilidade_pec_corte_app/screens/Animal/add_animal_form.dart';

import '../db/database_animal.dart';
import '../widgets/buttonHome.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Dashboard',
          style: TextStyle(color: Color(0xffffffff)),

        ),
        actions: <Widget>[
          if (_currentUser != null)
            Row(
              children:[
                  Icon(Icons.account_circle),
                  Text(
                  '${_currentUser.displayName}',
                  style: TextStyle (color: Colors.white, fontSize: 18),
                  ),
              ]

            )


        ],
      ),
      body:
          ButtonHome(currentUser: _currentUser),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text(
        //       'EMAIL: ${_currentUser.email}',
        //       style: Theme.of(context).textTheme.bodyText1,
        //     ),
        //     SizedBox(height: 16.0),
        //     _isSendingVerification
        //         ? CircularProgressIndicator()
        //         : Row(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               ElevatedButton(
        //                 onPressed: () async {
        //                   setState(() {
        //                     _isSendingVerification = true;
        //                   });
        //                   await _currentUser.sendEmailVerification();
        //                   setState(() {
        //                     _isSendingVerification = false;
        //                   });
        //                 },
        //                 child: Text('Verify email'),
        //               ),
        //               ElevatedButton(
        //                 onPressed: () async {
        //                   Navigator.of(context).push(
        //                     MaterialPageRoute(
        //                       builder: (context) => AddAnimalForm(
        //                         doc: "",user: _currentUser,
        //                       ),
        //                     ),
        //                   );
        //                 },
        //                 child: Text('Registros'),
        //               ),
        //               SizedBox(width: 8.0),
        //               IconButton(
        //                 icon: Icon(Icons.refresh),
        //                 onPressed: () async {
        //                   User? user = await FireAuth.refreshUser(_currentUser);
        //
        //                   if (user != null) {
        //                     setState(() {
        //                       _currentUser = user;
        //                     });
        //                   }
        //                 },
        //               ),
        //             ],
        //           ),
        //     SizedBox(height: 16.0),
        //     _isSigningOut
        //         ? CircularProgressIndicator()
        //         : ElevatedButton(
        //             onPressed: () async {
        //               setState(() {
        //                 _isSigningOut = true;
        //               });
        //               await FirebaseAuth.instance.signOut();
        //               setState(() {
        //                 _isSigningOut = false;
        //               });
        //               Navigator.of(context).pushReplacement(
        //                 MaterialPageRoute(
        //                   builder: (context) => LoginPage(),
        //                 ),
        //               );
        //             },
        //             child: Text('Sign out'),
        //             style: ElevatedButton.styleFrom(
        //               primary: Colors.red,
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(30),
        //               ),
        //             ),
        //           ),
        //     MaterialButton(
        //       onPressed: () async {
        //         Navigator.of(context).pushReplacement(
        //           MaterialPageRoute(
        //             builder: (context) => ListAnimal(user: _currentUser),
        //           ),
        //         );
        //       },
        //       child: const Text('Lista registro'),
        //       color: Colors.blue,
        //       textColor: Colors.white,
        //       minWidth: 300,
        //       height: 40,
        //     ),
        //   ],
        // ),

    );
  }
}
