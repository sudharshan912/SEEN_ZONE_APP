import 'package:hive/hive.dart';
part 'movie_list.g.dart';


//the structure of the hive databox
@HiveType(typeId: 0)
class Movie_list extends HiveObject {
  @HiveField(0)
  String? mail_id;
  @HiveField(1)
  String? Movie_Name;
  @HiveField(2)
  String? Director_name;
  @HiveField(3)
  String? Image;
  @HiveField(4)
  String? Genre;
  @HiveField(5)
  String? Language;
  @HiveField(6)
  String? Rating;


  Movie_list({this.mail_id = "", this.Movie_Name = '', this.Director_name="",this.Image="",this.Genre="",this.Language="",this.Rating=""});
}
