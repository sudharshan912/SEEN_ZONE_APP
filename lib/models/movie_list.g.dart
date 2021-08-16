// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovielistAdapter extends TypeAdapter<Movie_list> {
  @override
  final int typeId = 0;

  @override
  Movie_list read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Movie_list(
      mail_id: fields[0] as String?,
      Movie_Name: fields[1] as String?,
      Director_name: fields[2] as String?,
      Image: fields[3] as String?,
      Genre: fields[4] as String?,
      Language: fields[5] as String?,
      Rating: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Movie_list obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.mail_id)
      ..writeByte(1)
      ..write(obj.Movie_Name)
      ..writeByte(2)
      ..write(obj.Director_name)
      ..writeByte(3)
      ..write(obj.Image)
      ..writeByte(4)
      ..write(obj.Genre)
      ..writeByte(5)
      ..write(obj.Language)
      ..writeByte(6)
      ..write(obj.Rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovielistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
