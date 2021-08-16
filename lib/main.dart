import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/material.dart';
import 'package:seenzone/models/movie_list.dart';
import 'package:seenzone/page/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'client/hive_names.dart';


// INITIAL SETUP OF THE APP IS DONE IN THIS FILE

Future main() async {
  // ensure proper setup of all app widgets.
  WidgetsFlutterBinding.ensureInitialized();
  // ensure firebase is connected for the initial login part.
  await Firebase.initializeApp();
  // get app's working directory to store hive data box there.
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  // Connect the Adapters of Hive Database
  Hive.registerAdapter(MovielistAdapter());
  // Connect to databox whose name is stored at the class HiveBoxes.
  await Hive.openBox<Movie_list>(HiveBoxes.movie_list);

  //Run App
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // establishing title of the App for setting up the MaterialApp
  static final String title = 'Seen Zone';

  @override
  Widget build(BuildContext context) => MaterialApp(
        //to remove the debug banner
        debugShowCheckedModeBanner: false,

        title: title,

        //Setting up a primary theme of Orange Shade.
        theme: ThemeData(primarySwatch: Colors.deepOrange),

        //Home_Page_Invoke
        home: HomePage(),
      );
}
