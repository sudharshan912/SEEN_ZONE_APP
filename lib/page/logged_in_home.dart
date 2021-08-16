import 'dart:ffi';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seenzone/models/movie_list.dart';
import 'package:seenzone/page/view_list.dart';
import 'package:seenzone/provider/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:seenzone/page/form_add_or_edit.dart';

//when user is logged in this page is shown
class LoggedInWidget extends StatelessWidget {
  //key for the form if needed.
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // Get details of user from firebase.
    final user = FirebaseAuth.instance.currentUser;
    BuildContext logout_context = context;

    //FURTHER DESIGN OF THE PAGE
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        leading: Icon(
          Icons.home,
          color: Theme.of(context).accentColor
        ),
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            user!.displayName!,
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor
            ),
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.network(
                user.photoURL!,
               
              ),
            ),
          )
          
        ],
      ),
      body: SizedBox(
        
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Container(
                
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Theme.of(context).bottomAppBarColor,
                          width: 5,
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 100,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          
                          color: Colors.black,
                          width: 5,
                        ),
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).buttonColor) ,
                          shadowColor: MaterialStateProperty.all<Color>(Colors.black),
                          elevation: MaterialStateProperty.all<double>(10.0)
                        ),
                        child: Text(
                          "ADD MOVIE",
                          style: TextStyle(fontSize: 20,color:Colors.black),
                          
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Form_add_edit(
                                isEdit: false,
                                movie_list_Model: new Movie_list(),
                                mail_id: user.email.toString(),
                                Language: "",
                                Rating: "rating",
                                Genre: "",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // color: Colors.amberAccent[400],
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          
                          color: Theme.of(context).bottomAppBarColor,
                          width: 5,
                        ),
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:MaterialStateProperty.all<Color>(Colors.black) ,
                          shadowColor: MaterialStateProperty.all<Color>(Theme.of(context).buttonColor),
                          elevation: MaterialStateProperty.all<double>(10.0)
                        ),
                        child: Text(
                          "VIEW LIST",
                          style: TextStyle(fontSize: 20,color: Theme.of(context).buttonColor),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewList(
                                      mail_id: user.email!,
                                    )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        
                        shadowColor: MaterialStateProperty.all<Color>(Colors.red),
                        elevation: MaterialStateProperty.all<double>(10.0)
                      ),
                          child: Text(
                            "LOG OUT",
                            style: TextStyle(fontSize: 20,color: Theme.of(context).buttonColor),
                          ),
                          onPressed: () {
                           

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    color: Colors.black54,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AlertDialog(
                                        backgroundColor: Colors.white,
                                        title: Text(
                                          "YOU CLICKED ON LOG-OUT !!!",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                        content: Text(
                                            "Are you Sure  ?"),
                                        actions: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        
                        shadowColor: MaterialStateProperty.all<Color>(Colors.red),
                        elevation: MaterialStateProperty.all<double>(10.0)
                      ),
                                                child: Text(
                                                  "NO",
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              Container(
                                                width: 5,
                                              ),
                                              ElevatedButton(
                                                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                        
                        shadowColor: MaterialStateProperty.all<Color>(Colors.red),
                        elevation: MaterialStateProperty.all<double>(10.0)
                      ),
                                                onPressed: () {
                                                 
                                                  final provider =
                                                      Provider.of<GoogleSignInProvider>(
                                                          logout_context,
                                                          listen: false);
                                                  provider.logout();
                                                   Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "YES",
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                              ),
                                             
                                          
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).buttonColor), 
                        
                        shadowColor: MaterialStateProperty.all<Color>(Colors.red),
                        elevation: MaterialStateProperty.all<double>(10.0)
                      ),
                          child: Text(
                            "EXIT APP",
                            style: TextStyle(fontSize: 20,color:Colors.black),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    color: Colors.black54,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AlertDialog(
                                        backgroundColor: Colors.white,
                                        title: Text(
                                          "YOU CLICKED ON EXIT !!!",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                        content: Text(
                                            "Are you Sure  ?"),
                                        actions: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                               ElevatedButton(
                                                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        
                        shadowColor: MaterialStateProperty.all<Color>(Colors.red),
                        elevation: MaterialStateProperty.all<double>(10.0)
                      ),
                                                child: Text(
                                                  "NO",
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              Container(
                                                width: 5,
                                              ),
                                              ElevatedButton(
                                                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                        
                        shadowColor: MaterialStateProperty.all<Color>(Colors.red),
                        elevation: MaterialStateProperty.all<double>(10.0)
                      ),
                                                child: Text(
                                                  "YES",
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                                onPressed: () {
                                                  exit(0);
                                                },
                                              ),
                                              
                                             
                                              
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            Spacer(),
            
            ],
          ),
        ),
      ),
    );

    // return Container(
    //   alignment: Alignment.center,
    //   color: Colors.blueGrey.shade900,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Text(
    //         'Logged In',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //       SizedBox(height: 8),
    //       CircleAvatar(
    //         maxRadius: 25,
    //         backgroundImage: NetworkImage(user!.photoURL!),
    //       ),
    //       SizedBox(height: 8),
    //       Text(
    //         'Name: ' + user.displayName!,
    //         style: TextStyle(color: Colors.white),
    //       ),
    //       SizedBox(height: 8),
    //       Text(
    //         'Email: ' + user.email!,
    //         style: TextStyle(color: Colors.white),
    //       ),
    //       SizedBox(height: 8),
    //       ElevatedButton(
    //         onPressed: () {
    //           final provider =
    //               Provider.of<GoogleSignInProvider>(context, listen: false);
    //           provider.logout();
    //         },
    //         child: Text('Logout'),
    //       )
    //     ],
    //   ),
    // );
  }
}
// void SelectedItem(BuildContext context, item) {
//   switch (item) {

//     case 0:

//       final provider =Provider.of<GoogleSignInProvider>(context, listen: false);
//       provider.logout();
//       break;
//   }
// }
