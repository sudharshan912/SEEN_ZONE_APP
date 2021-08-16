import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:io' as io;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:seenzone/client/hive_names.dart';
import 'package:seenzone/models/movie_list.dart';

//form for add/editing
class Form_add_edit extends StatefulWidget {
  //we get a bool as input to know if user intends to add/edit.
  bool isEdit;
  //GET POSITION IF EDIT MODE...ENSURES CHANGE IS MADE AT THE RIGHT DATA.
  int? position;
  String Genre;

  String Language;

  String Rating;
  Movie_list movie_list_Model;
  String mail_id;
  @override
  Form_add_edit(
      {Key? key,
      required this.mail_id,
      required this.Genre,
      required this.Language,
      required this.Rating,
      required this.isEdit,
      this.position,
      required this.movie_list_Model})
      : assert(mail_id != null),
        super(key: key);

  _Form_add_editState createState() =>
      _Form_add_editState(key: key, mail_id: mail_id);
}

class _Form_add_editState extends State<Form_add_edit> {
  String mail_id;

  _Form_add_editState({Key? key, required this.mail_id})
      : assert(mail_id != null);
  final _formKey = GlobalKey<FormState>();
  XFile? _image;

  //hinttext are initialy pre-populated..for add mode
  String movie_name = "";
  String director_name = "";
  String img_string = "";
  String genre = "";
  String Language = "";
  String Rating = "";
  String MovienameHinttext = "NAME OF THE MOVIE";
  String DirectornameHinttext = "DIRECTOR'S NAME";
  String languageHinttext = "WHAT LANGUAGE IS THE MOVIE";
  String genreHinttext = "WHAT IS THE GENRE";
  String ratingHinttext = "Rating(0-10)";
  final ImagePicker _picker = ImagePicker();


  //CONTROLERS FOR THE INPUTS
  TextEditingController controllerMovieName = new TextEditingController();
  TextEditingController controllerDirectorName = new TextEditingController();
  TextEditingController controllerlanguage = new TextEditingController();
  TextEditingController controllerGenre = new TextEditingController();
  //COULD HAVE BEEN MADE AS INT.
  TextEditingController controllerrating = new TextEditingController();

  _getvalue() async {
    //GETTING VALUES FROM THE HIVE DATABOX TO PRE-POPULATE THE FORM FOR EDIT-MODE
    controllerMovieName.text = widget.movie_list_Model.Movie_Name.toString();
    controllerDirectorName.text =
        widget.movie_list_Model.Director_name.toString();
    controllerGenre.text = widget.movie_list_Model.Genre.toString();
    controllerlanguage.text = widget.movie_list_Model.Language.toString();
    controllerrating.text = widget.movie_list_Model.Rating.toString();
    movie_name = widget.movie_list_Model.Movie_Name.toString();
    director_name = widget.movie_list_Model.Director_name.toString();
    img_string = widget.movie_list_Model.Image.toString();
    genre = widget.movie_list_Model.Genre.toString();
    Language = widget.movie_list_Model.Language.toString();
    Rating = widget.movie_list_Model.Rating.toString();
  }

  _imgFromCamera() async {
    //FUNCTION TO STORE IMAGE TAKEN FROM CAMERA FOR POSTER
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _storepath() {
    //CODE TO CONVERT IMAGE TO A BASE64 STRING THAT CAN BE STORED IN DATABASE
    final bytes = io.File(_image!.path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    setState(() {
      img_string = img64;
    });
  }

  _imgFromGallery() async {
       //FUNCTION TO STORE IMAGE TAKEN FROM GALLERY FOR POSTER
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    //THE IMAGE PICKER CODE
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    //CHECKING INITIALYY IF FORM IS OPENED FOR ADDING/EDITING
    if (widget.isEdit) {
      _getvalue();
      MovienameHinttext = widget.movie_list_Model.Movie_Name.toString();
      DirectornameHinttext = widget.movie_list_Model.Director_name.toString();
      if (Language.toString() == "language") {
        languageHinttext = widget.movie_list_Model.Language.toString();
      }
      if (genre.toString() == "genre") {
        genreHinttext = widget.movie_list_Model.Genre.toString();
      }
      if (Rating.toString() == "rating") {
        ratingHinttext = widget.movie_list_Model.Rating.toString();
      }

      
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).bottomAppBarColor),
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        title: FittedBox(
          fit: BoxFit.fitWidth,
          //change appbar text based on user's intent.
          child: (widget.isEdit)
              ? Text(
                  "EDIT MOVIE DETAILS",
                  style: TextStyle(color: Colors.black),
                )
              : Text(
                  "ADD MOVIE TO LIST : )",
                  style: TextStyle(color: Colors.black),
                ),
        ),
        actions: [],
      ),
      body: Container(
        color: Theme.of(context).bottomAppBarColor,
        //form starts here
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "* - REQUIRED FIELDS",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Movie Name",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text(
                          " * ",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text(
                          ": ",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllerMovieName,

                      decoration: InputDecoration(
                        hintText: MovienameHinttext,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.redAccent, width: 2.0),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),

                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter The Name Of The Movie ...';
                        } else {
                          movie_name = value;
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Director Name",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text(
                          " * ",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text(
                          ": ",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllerDirectorName,

                      decoration: InputDecoration(
                        hintText: DirectornameHinttext,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.redAccent, width: 2.0),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),

                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter The Director's Name ...";
                        }
                        return null;
                      },
                    ),
                  ),
                  
                  // Text(
                  //   "Feel free to Update later 👇",
                  //   style: TextStyle(
                  //       color: Colors.red,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 15),
                  // ),
                   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Language: ",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllerlanguage,

                      decoration: InputDecoration(
                        hintText: languageHinttext,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.redAccent, width: 2.0),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onChanged: (value) {
                        Language = value;
                      },
                      // The validator receives the text that the user has entered.
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Genre: ",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllerGenre,

                      decoration: InputDecoration(
                        hintText: genreHinttext,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.redAccent, width: 2.0),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onChanged: (value) {
                        genre = value;
                      },
                      // The validator receives the text that the user has entered.
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Rating: ",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllerrating,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: ratingHinttext,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.redAccent, width: 2.0),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      //check if user inputs a range 0-10 as rating
                      onChanged: (value) {
                        if (int.parse(value.toString()) < 0 ||
                            int.parse(value.toString()) > 10) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please Enter a value within 0-10 ...',
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else {
                          Rating = value.toString();
                        }
                      },

                      // The validator receives the text that the user has entered.
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Movie Poster :",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Color(0xffFDCF09),
                        child: (_image != null)
                            ? (widget.isEdit == false)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.file(
                                      io.File(_image!.path),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.file(
                                      io.File(_image!.path),
                                      // Image.memory(base64Decode(img_string),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )
                            : (widget.isEdit == false)
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  )
                                : (img_string == "")
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        width: 100,
                                        height: 100,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey[800],
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.memory(
                                          base64Decode(img_string),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                      ),
                    ),
                  ),
                 
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: ElevatedButton(
                            style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).accentColor),
                        
                        shadowColor: MaterialStateProperty.all<Color>(Colors.red),
                        elevation: MaterialStateProperty.all<double>(10.0)
                      ),
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.
                           
                          if (_formKey.currentState!.validate()) {
                            

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Processing Data . . .',
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );

                            //PROCESS THE STORING BASED ON ADD/EDIT AND THE POSITION OF THE LIST IF IN EDIT MODE
                            if (widget.isEdit && _image == null) {
                              Movie_list updateMovie_list = new Movie_list(
                                  Movie_Name: controllerMovieName.text,
                                  Director_name: controllerDirectorName.text,
                                  Image: img_string,
                                  mail_id: mail_id,
                                  Language: Language,
                                  Genre: genre,
                                  Rating: Rating);
                              var box = await Hive.openBox<Movie_list>(
                                  HiveBoxes.movie_list);
                              box.putAt(widget.position!, updateMovie_list);
                            } else if (widget.isEdit && _image != null) {
                              _storepath();

                              Movie_list updateMovie_list = new Movie_list(
                                  Movie_Name: controllerMovieName.text,
                                  Director_name: controllerDirectorName.text,
                                  Image: img_string,
                                  mail_id: mail_id,
                                  Language: Language,
                                  Genre: genre,
                                  Rating: Rating);
                              var box = await Hive.openBox<Movie_list>(
                                  HiveBoxes.movie_list);
                              box.putAt(widget.position!, updateMovie_list);
                            } else if (!(widget.isEdit) && _image != null) {
                              _storepath();

                              Movie_list addMovie_list = new Movie_list(
                                  Movie_Name: controllerMovieName.text,
                                  Director_name: controllerDirectorName.text,
                                  Image: img_string,
                                  mail_id: mail_id,
                                  Language: Language,
                                  Genre: genre,
                                  Rating: Rating);
                              var box = await Hive.openBox<Movie_list>(
                                  HiveBoxes.movie_list);
                              box.add(addMovie_list);
                            } else if (!(widget.isEdit) && _image == null) {
                              //&&_image==null) {

                              Movie_list addMovie_list = new Movie_list(
                                  Movie_Name: controllerMovieName.text,
                                  Director_name: controllerDirectorName.text,
                                  Image: img_string,
                                  mail_id: mail_id,
                                  Language: Language,
                                  Genre: genre,
                                  Rating: Rating);
                              var box = await Hive.openBox<Movie_list>(
                                  HiveBoxes.movie_list);
                              box.add(addMovie_list);
                            } else if (widget.isEdit && _image != null) {
                              _storepath();
                              Movie_list updateMovie_list = new Movie_list(
                                  Movie_Name: controllerMovieName.text,
                                  Director_name: controllerDirectorName.text,
                                  Image: img_string,
                                  mail_id: mail_id,
                                  Language: Language,
                                  Genre: genre,
                                  Rating: Rating);
                              var box = await Hive.openBox<Movie_list>(
                                  HiveBoxes.movie_list);
                              box.putAt(widget.position!, updateMovie_list);
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Data Saved : )",
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.of(context).pop();
                          }
       
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
