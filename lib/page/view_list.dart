import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seenzone/client/hive_names.dart';
import 'package:seenzone/models/movie_list.dart';
import 'package:seenzone/page/form_add_or_edit.dart';
import 'dart:io' as Io;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

const String dataBoxName = "movie_list_box";

class ViewList extends StatefulWidget {
  final String mail_id;

  @override
  const ViewList({Key? key, required this.mail_id}) : super(key: key);

  @override
  _ViewListState createState() => _ViewListState(key: key, mail_id: mail_id);
}

class _ViewListState extends State<ViewList> {
  final String mail_id;
  _ViewListState({Key? key, required this.mail_id}) : assert(mail_id != null);

  List<Movie_list> listMovies = [];
  String? location;
  void getMovies() async {
    final box = await Hive.openBox<Movie_list>(HiveBoxes.movie_list);
    setState(() {
      listMovies = box.values.toList();
    });
  }

  void getlocation() async {
    //get app directory to get access of the database
    Directory appDocDir = await getApplicationDocumentsDirectory();
    location = appDocDir.path;
    print(location);
    
  }

  @override
  void initState() {
    //initialize by getting app directory and the data from database
    getlocation();
    getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).bottomAppBarColor),
          backgroundColor: Theme.of(context).backgroundColor,
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              "YOUR WATCH LIST",
              style: TextStyle(color: Colors.black),
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).buttonColor),
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      elevation: MaterialStateProperty.all<double>(10.0)),
                  child: Text(
                    "+ ADD",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Form_add_edit(
                                  mail_id: mail_id,
                                  movie_list_Model: new Movie_list(),
                                  isEdit: false,
                                  Language: "",
                                  Rating: "rating",
                                  Genre: "",
                                )));

                    setState(() {});
                  }),
            )
          ],
        ),
        body: Container(
          color: Theme.of(context).backgroundColor.withOpacity(0.5),
          padding: EdgeInsets.all(15),
          // to implement scroll to refresh
          child: RefreshIndicator(
            child: ListView.builder(
                itemCount: listMovies.length,
                itemBuilder: (context, position) {
                  Movie_list getMovie = listMovies[position];
                  //store data from database
                  var mailId = getMovie.mail_id;
                  var MovieName = getMovie.Movie_Name;
                  var DirectorName = getMovie.Director_name;
                  var image = getMovie.Image;
                  var genre = getMovie.Genre;
                  var language = getMovie.Language;
                  var rating = getMovie.Rating;
                  //since all data stored in database...we progamatically stored e-mail-id to database along with data.
                  // So when a user is logged in..only data associated with that id is shown.
                  if (mailId == mail_id) {
                    print(image);

                    return Column(
                      children: [
                        Card(
                          color: Theme.of(context).backgroundColor,
                          child: ExpansionTile(
                            collapsedBackgroundColor: Colors.white,
                            tilePadding: EdgeInsets.all(8),
                            subtitle: Text("By Director " +
                                getMovie.Director_name.toString()),
                            leading: (image != "")
                                ? Image.memory(
                                    base64Decode(image.toString()),
                                    height: 100,
                                    width: 100,
                                  )
                                : Image.asset('assets/images/logo.png',
                                    height: 100, width: 100),
                            title: Text(getMovie.Movie_Name.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                            children: [
                              Card(
                                shadowColor: Colors.red,
                                elevation: 10,
                                borderOnForeground: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch, // add this
                                  children: <Widget>[
                                    Container(
                                      color: Colors.black,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Spacer(),
                                          Text(
                                            "SEENZONE",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .bottomAppBarColor,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 5.0),
                                          ),
                                          Spacer(),
                                          IconButton(
                                            icon: FaIcon(
                                              FontAwesomeIcons.checkDouble,
                                              color: Colors.blue[400],
                                            ),
                                            onPressed: () {},
                                          ),
                                          Spacer(),
                                          IconButton(
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.green,
                                              ),
                                              onPressed: () {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Edit data : )",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            Form_add_edit(
                                                              isEdit: true,
                                                              position:
                                                                  position,
                                                              movie_list_Model:
                                                                  listMovies[
                                                                      position],
                                                              mail_id: mailId!,
                                                              Language: "",
                                                              Rating: "rating",
                                                              Genre: "",
                                                            )));
                                              }),
                                          IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Container(
                                                        color: Colors.black54,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: AlertDialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            title: Text(
                                                              "YOU CLICKED ON DELETE !!!",
                                                              style: TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            content: Text(
                                                              "Are you Sure ??",
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              Row(
                                                                
                                                                children: [
                                                                  Spacer(),
                                                                   ElevatedButton(
                                                                    style: ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all<Color>(Colors
                                                                                .green),
                                                                        shadowColor:
                                                                            MaterialStateProperty.all<Color>(Colors
                                                                                .red),
                                                                        elevation:
                                                                            MaterialStateProperty.all<double>(10.0)),
                                                                    child: Text(
                                                                      "NO",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                  Container(
                                                                    width: 5,
                                                                  ),
                                                                  ElevatedButton(
                                                                    style: ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all<Color>(Colors
                                                                                .red),
                                                                        shadowColor:
                                                                            MaterialStateProperty.all<Color>(Colors
                                                                                .red),
                                                                        elevation:
                                                                            MaterialStateProperty.all<double>(10.0)),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      final box = Hive.box<
                                                                              Movie_list>(
                                                                          HiveBoxes
                                                                              .movie_list);
                                                                      box.deleteAt(
                                                                          position);
                                                                      setState(
                                                                          () =>
                                                                              {
                                                                                listMovies.removeAt(position),
                                                                                Navigator.pop(context),
                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => ViewList(
                                                                                            mail_id: mail_id,
                                                                                          )),
                                                                                ),
                                                                              });
                                                                    },
                                                                    child: Text(
                                                                      "YES",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                  ),
                                                                 
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }),
                                          Spacer(),
                                          Container(),
                                          Spacer(),
                                          Container(),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      color: Colors.blueAccent[100],
                                      height: 150,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8.0),
                                            topRight: Radius.circular(8.0),
                                          ),
                                          child: (image != "")
                                              ? Image.memory(base64Decode(
                                                  image.toString()))
                                              : Container(
                                                  child: Image.asset(
                                                    'assets/images/logo.png',
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                  ),
                                                )),
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.movie_creation_rounded,
                                        color: Colors.black,
                                      ),
                                      title: Text(
                                          getMovie.Movie_Name.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text(
                                        'Movie Name',
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.chair_alt_rounded,
                                        color: Colors.black,
                                      ),
                                      title: Text(
                                        getMovie.Director_name.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        'Director',
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    (genre != "" && genre != null)
                                        ? ListTile(
                                            leading: const Icon(
                                              Icons.theaters_rounded,
                                              color: Colors.black,
                                            ),
                                            title: Text(
                                              getMovie.Genre.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              'Genre',
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        : Offstage(offstage: true),
                                    (language != "" && language != null)
                                        ? ListTile(
                                            leading: const Icon(
                                              Icons.language,
                                              color: Colors.black,
                                            ),
                                            title: Text(
                                              getMovie.Language.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              'Language',
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        : Offstage(offstage: true),
                                    (rating != "" && rating != null)
                                        ? ListTile(
                                            leading: const Icon(
                                              Icons.rate_review,
                                              color: Colors.black,
                                            ),
                                            title: Text(
                                              getMovie.Rating.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              'Your Rating',
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        : Offstage(offstage: true)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Card(
                      
                    );
                  }
                }),
            onRefresh: () {
              return Future.delayed(Duration(seconds: 1), () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewList(
                            mail_id: mail_id,
                          )),
                );
              });
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).backgroundColor,
          
          child:FittedBox(
            fit: BoxFit.fill,
            child: Column(
              children: [
                Text("   PLEASE REFRESH PAGE TO VIEW ANY CHANGES TO THE LIST   ",style: TextStyle(color: Colors.white),),
                Text("   PULL DOWN TO REFRESH / USE THE REFRESH BUTTON  ",style: TextStyle(color: Colors.white),),
              ],
            )) ,),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          elevation: 10,
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewList(
                        mail_id: mail_id,
                      )),
            );
          },
          child: Icon(
            Icons.refresh,
            color: Theme.of(context).bottomAppBarColor,
          ),
        ),
      ),
    );
  }
}
